// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:riverpod_annotation/riverpod_annotation.dart";

part "notification_service.g.dart";

/// Flavor-agnostic push notification interface.
abstract class NotificationService {
  Future<void> initialize();

  /// Schedule a push notification [daysBefore] days before [closesAt].
  ///
  /// [programmeId] is used as the notification identifier for cancellation.
  Future<void> scheduleDeadlineReminder({
    required String programmeId,
    required String programmeName,
    required DateTime closesAt,
    required int daysBefore,
  });

  Future<void> cancel(String programmeId);
}

/// Overridden in each `main_*.dart` via [ProviderScope].
@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  throw UnimplementedError("notificationServiceProvider not overridden");
}
