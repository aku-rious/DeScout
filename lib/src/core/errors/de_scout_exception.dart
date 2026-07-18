// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

/// User-safe application failure. [userMessage] is shown in UI; [cause] is
/// logged via Talker/Sentry only.
final class DeScoutException implements Exception {
  const DeScoutException(this.userMessage, {this.cause});

  final String userMessage;
  final Object? cause;

  @override
  String toString() => userMessage;
}
