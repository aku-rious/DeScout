// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/notifications/notification_service.dart";
import "package:de_scout/src/core/notifications/onesignal_dev_integration_host.dart";
import "package:de_scout/src/core/notifications/onesignal_notification_service.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Standard flavor: OneSignal login/logout + dev integration dialog host.
class OneSignalStandardLifecycle extends ConsumerWidget {
  const OneSignalStandardLifecycle({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (previous, next) {
      final service = ref.read(notificationServiceProvider);
      if (service is! OneSignalNotificationService) {
        return;
      }
      final userId = next.value?.session?.user.id;
      if (userId != null) {
        service.loginUser(userId);
      } else {
        service.logoutUser();
      }
    });

    return OneSignalDevIntegrationHost(child: child);
  }
}
