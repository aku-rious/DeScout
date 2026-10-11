// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/data/exchange_rate_repository.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "exchange_rate_provider.g.dart";

@riverpod
class ExchangeRate extends _$ExchangeRate {
  @override
  Future<double> build() {
    return ref.watch(exchangeRateRepositoryProvider).fetchNgnRate();
  }

  Future<void> refresh() async {
    ref.read(exchangeRateRepositoryProvider).invalidateCache();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
