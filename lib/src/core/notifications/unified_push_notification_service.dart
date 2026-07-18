// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/notifications/notification_service.dart";

/// UnifiedPush backend for the `fdroid` flavor.
class UnifiedPushNotificationService implements NotificationService {
  @override
  Future<void> initialize() {
    // TODO(#1): implement UnifiedPush SDK
    throw UnimplementedError("UnifiedPushNotificationService.initialize");
  }

  @override
  Future<void> scheduleDeadlineReminder({
    required String programmeId,
    required String programmeName,
    required DateTime closesAt,
    required int daysBefore,
  }) {
    // TODO(#1): implement UnifiedPush SDK
    throw UnimplementedError(
      "UnifiedPushNotificationService.scheduleDeadlineReminder",
    );
  }

  @override
  Future<void> cancel(String programmeId) {
    // TODO(#1): implement UnifiedPush SDK
    throw UnimplementedError("UnifiedPushNotificationService.cancel");
  }
}
