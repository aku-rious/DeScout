// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/utils/currency_utils.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("formatNgn formats large USD amounts without decimals", () {
    expect(formatNgn(3000, 1500), "≈ ₦4,500,000");
  });

  test("formatNgn rounds fractional naira", () {
    expect(formatNgn(1, 1335.81), "≈ ₦1,336");
  });
}
