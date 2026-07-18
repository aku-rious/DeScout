// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/app.dart";
import "package:de_scout/src/core/notifications/notification_service.dart";
import "package:de_scout/src/core/notifications/onesignal_notification_service.dart";
import "package:de_scout/src/core/supabase/supabase_init.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:sentry_flutter/sentry_flutter.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init((options) {
    options.dsn = const String.fromEnvironment("SENTRY_DSN");
    options.environment = "standard";
  }, appRunner: _run);
}

Future<void> _run() async {
  await initSupabase();
  // TODO(#1): add shorebird_code_push init
  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(
          OneSignalNotificationService(),
        ),
      ],
      child: const DeScoutApp(),
    ),
  );
}
