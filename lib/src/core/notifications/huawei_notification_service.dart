// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/notifications/notification_service.dart";
import "package:flutter/foundation.dart";

/// Huawei push backend stub for the `huawei` flavor.
class HuaweiNotificationService implements NotificationService {
  @override
  bool get pushAvailable => false;

  @override
  Future<void> initialize() async {
    // TODO(#1): implement huawei_push SDK
    debugPrint("Push not configured for this flavor");
  }

  @override
  Future<bool> promptForPermission() async => false;

  @override
  Future<bool> hasPermission() async => false;

  @override
  Future<void> scheduleDeadlineReminder({
    required String programmeId,
    required String programmeName,
    required DateTime closesAt,
    required int daysBefore,
  }) async {}

  @override
  Future<void> cancel(String programmeId) async {}
}
