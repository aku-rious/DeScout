// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/data/exchange_rate_repository.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("fallback rate is 1550 for silent client-side default", () {
    expect(ExchangeRateRepository.fallbackRate, 1550.0);
  });
}
