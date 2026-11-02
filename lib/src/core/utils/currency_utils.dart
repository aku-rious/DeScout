// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:intl/intl.dart";

/// Formats a USD stipend as approximate NGN (no decimals above ₦1000).
String formatNgn(double usd, double ngnRate) {
  final ngn = usd * ngnRate;
  return "≈ ₦${NumberFormat("#,###", "en_US").format(ngn.round())}";
}
