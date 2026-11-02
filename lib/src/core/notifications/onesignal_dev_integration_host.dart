// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/notifications/notification_service.dart";
import "package:de_scout/src/core/notifications/onesignal_notification_service.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Debug/profile: OneSignal SDK integration verification dialog (standard flavor).
class OneSignalDevIntegrationHost extends ConsumerStatefulWidget {
  const OneSignalDevIntegrationHost({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<OneSignalDevIntegrationHost> createState() =>
      _OneSignalDevIntegrationHostState();
}

class _OneSignalDevIntegrationHostState
    extends ConsumerState<OneSignalDevIntegrationHost> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode || kProfileMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final service = ref.read(notificationServiceProvider);
        if (service is OneSignalNotificationService) {
          service.attachDevVerificationDialog(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
