// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/programmes/domain/programme_tip.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "programme_tips_repository.g.dart";

/// Community tips for programmes.
class ProgrammeTipsRepository {
  ProgrammeTipsRepository(this._client, this._errors, this._currentUserId);

  final SupabaseClient _client;
  final ErrorReporter _errors;
  final String? Function() _currentUserId;

  static const _signInMessage = "Sign in to post a tip.";

  Future<List<ProgrammeTip>> fetchTips(String programmeId) {
    return _errors.guard(
      userMessage: ErrorMapper.programmesMessage,
      action: () async {
        final response = await _client
            .from(Tables.programmeTips)
            .select()
            .eq(Cols.programmeId, programmeId)
            .order(Cols.createdAt, ascending: false)
            .limit(10);
        return (response as List)
            .cast<Map<String, dynamic>>()
            .map((row) => ProgrammeTip.fromRow(ProgrammeTipsRow.fromJson(row)))
            .toList();
      },
    );
  }

  Future<void> addTip(String programmeId, String tipText) {
    return _errors.guard(
      userMessage: ErrorMapper.programmesMessage,
      action: () async {
        final userId = _currentUserId();
        if (userId == null) {
          throw const DeScoutException(_signInMessage);
        }
        final trimmed = tipText.trim();
        if (trimmed.length < 10 || trimmed.length > 280) {
          throw const DeScoutException(
            "Tips must be between 10 and 280 characters.",
          );
        }
        await _client.from(Tables.programmeTips).insert({
          Cols.programmeId: programmeId,
          Cols.userId: userId,
          Cols.tipText: trimmed,
        });
      },
    );
  }
}

@riverpod
ProgrammeTipsRepository programmeTipsRepository(
  ProgrammeTipsRepositoryRef ref,
) {
  final client = ref.watch(supabaseClientProvider);
  return ProgrammeTipsRepository(
    client,
    ref.watch(errorReporterProvider),
    () => client.auth.currentUser?.id,
  );
}
