// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/notifications/notification_service.dart";

/// Huawei Push Kit backend for the `huawei` flavor.
class HuaweiNotificationService implements NotificationService {
  @override
  Future<void> initialize() {
    // TODO(#1): implement huawei_push SDK
    throw UnimplementedError("HuaweiNotificationService.initialize");
  }

  @override
  Future<void> scheduleDeadlineReminder({
    required String programmeId,
    required String programmeName,
    required DateTime closesAt,
    required int daysBefore,
  }) {
    // TODO(#1): implement huawei_push SDK
    throw UnimplementedError(
      "HuaweiNotificationService.scheduleDeadlineReminder",
    );
  }

  @override
  Future<void> cancel(String programmeId) {
    // TODO(#1): implement huawei_push SDK
    throw UnimplementedError("HuaweiNotificationService.cancel");
  }
}
