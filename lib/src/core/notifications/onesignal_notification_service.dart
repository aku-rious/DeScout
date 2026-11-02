// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:onesignal_flutter/onesignal_flutter.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "notification_service.dart";

/// OneSignal push backend for the `standard` flavor.
class OneSignalNotificationService implements NotificationService {
  bool _initialized = false;
  bool _devDialogShown = false;
  OnPushSubscriptionChangeObserver? _pushSubscriptionObserver;

  @override
  bool get pushAvailable => true;

  /// True when debug/profile uses OneSignal verification dialog for permission.
  static bool get usesDevVerificationFlow => kDebugMode || kProfileMode;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    final appId = const String.fromEnvironment("DESCOUT_ONESIGNAL_APP_ID");
    if (appId.isEmpty) {
      return;
    }

    OneSignal.initialize(appId);
    OneSignal.Notifications.addClickListener(_onNotificationClick);
    _initialized = true;
  }

  void loginUser(String externalId) {
    if (!_initialized) {
      return;
    }
    OneSignal.login(externalId);
  }

  void logoutUser() {
    if (!_initialized) {
      return;
    }
    OneSignal.logout();
  }

  void attachDevVerificationDialog(BuildContext context) {
    if (!_initialized || _devDialogShown || !usesDevVerificationFlow) {
      return;
    }

    void checkSubscription(String? subscriptionId) {
      if (!_isRegisteredSubscription(subscriptionId) || _devDialogShown) {
        return;
      }
      _devDialogShown = true;
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Your OneSignal SDK integration is complete!"),
          content: const Text(
            "You can now send Push Notifications & In-App Messages through "
            "OneSignal. Tap below to enable push notifications.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await promptForPermission();
              },
              child: const Text("Got it"),
            ),
          ],
        ),
      );
    }

    _pushSubscriptionObserver = (state) {
      checkSubscription(state.current.id);
    };
    OneSignal.User.pushSubscription.addObserver(_pushSubscriptionObserver!);

    checkSubscription(OneSignal.User.pushSubscription.id);
  }

  bool _isRegisteredSubscription(String? id) {
    return id != null && id.isNotEmpty && !id.startsWith("local-");
  }

  @override
  Future<bool> promptForPermission() async {
    final granted = await OneSignal.Notifications.requestPermission(true);
    if (granted) {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        await Supabase.instance.client
            .from(Tables.users)
            .update({Cols.pushFlavor: "standard"})
            .eq(Cols.id, userId);
      }
    }
    return granted;
  }

  @override
  Future<bool> hasPermission() async {
    return OneSignal.Notifications.permission;
  }

  void _onNotificationClick(OSNotificationClickEvent event) {
    final programmeId = event.notification.additionalData?["programme_id"];
    if (programmeId is! String || programmeId.isEmpty) {
      return;
    }
    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    context.go("${Routes.programmes}/$programmeId");
  }

  @override
  Future<void> scheduleDeadlineReminder({
    required String programmeId,
    required String programmeName,
    required DateTime closesAt,
    required int daysBefore,
  }) async {
    // Server-side scheduling in v0.3.
  }

  @override
  Future<void> cancel(String programmeId) async {
    // Server-side scheduling in v0.3.
  }
}
