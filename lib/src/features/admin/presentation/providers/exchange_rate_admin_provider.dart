// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/admin/data/admin_repository.dart";
import "package:de_scout/src/features/programmes/data/exchange_rate_repository.dart";
import "package:de_scout/src/features/programmes/presentation/providers/exchange_rate_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "exchange_rate_admin_provider.g.dart";

@riverpod
class ExchangeRateAdmin extends _$ExchangeRateAdmin {
  @override
  Future<ExchangeRateDetails> build() {
    return ref.watch(exchangeRateRepositoryProvider).fetchRateDetails();
  }

  Future<void> updateRate(double rate) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).updateExchangeRate(rate);
      ref.read(exchangeRateRepositoryProvider).invalidateCache();
      ref.invalidate(exchangeRateProvider);
      return ref.read(exchangeRateRepositoryProvider).fetchRateDetails();
    });
  }
}
