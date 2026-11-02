// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "exchange_rate_repository.g.dart";

/// USD→NGN rate for stipend display.
class ExchangeRateDetails {
  const ExchangeRateDetails({
    required this.rate,
    required this.updatedAt,
    required this.source,
  });

  final double rate;
  final DateTime updatedAt;
  final String source;
}

/// Fetches and caches the session USD→NGN exchange rate.
class ExchangeRateRepository {
  ExchangeRateRepository(this._client, this._errors);

  final SupabaseClient _client;
  final ErrorReporter _errors;

  static const fallbackRate = 1550.0;

  double? _cachedRate;
  ExchangeRateDetails? _cachedDetails;

  Future<double> fetchNgnRate() async {
    if (_cachedRate != null) {
      return _cachedRate!;
    }
    final details = await fetchRateDetails();
    _cachedRate = details.rate;
    return details.rate;
  }

  Future<ExchangeRateDetails> fetchRateDetails() async {
    if (_cachedDetails != null) {
      return _cachedDetails!;
    }
    return _errors.guard(
      userMessage: ErrorMapper.programmesMessage,
      action: () async {
        try {
          final response = await _client
              .from(Tables.exchangeRates)
              .select()
              .eq(Cols.currency, "USD")
              .maybeSingle();
          if (response == null) {
            return _fallbackDetails();
          }
          final row = ExchangeRatesRow.fromJson(response);
          final details = ExchangeRateDetails(
            rate: row.ngnRate,
            updatedAt: row.updatedAt,
            source: row.source,
          );
          _cachedDetails = details;
          _cachedRate = details.rate;
          return details;
        } catch (_) {
          return _fallbackDetails();
        }
      },
    );
  }

  void invalidateCache() {
    _cachedRate = null;
    _cachedDetails = null;
  }

  ExchangeRateDetails _fallbackDetails() {
    return ExchangeRateDetails(
      rate: fallbackRate,
      updatedAt: DateTime.now(),
      source: "fallback",
    );
  }
}

@riverpod
ExchangeRateRepository exchangeRateRepository(ExchangeRateRepositoryRef ref) {
  return ExchangeRateRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(errorReporterProvider),
  );
}
