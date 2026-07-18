// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:flutter/foundation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:talker/talker.dart";

part "talker_provider.g.dart";

/// App-wide Talker instance for dev console and admin diagnostics.
@Riverpod(keepAlive: true)
Talker talker(TalkerRef ref) {
  return Talker(
    settings: TalkerSettings(useConsoleLogs: kDebugMode, maxHistoryItems: 500),
  );
}

/// Whether the Talker overlay / diagnostics UI should be available.
bool talkerUiEnabled({required bool isAdmin}) {
  return kDebugMode || isAdmin;
}
