// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/logging/talker_diagnostics_host.dart";
import "package:de_scout/src/core/logging/talker_provider.dart";
import "package:de_scout/src/core/router/app_router.dart";
import "package:de_scout/src/core/theme/app_theme.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:talker_flutter/talker_flutter.dart";

/// Root widget: Material 3 shell with go_router and system theme mode.
class DeScoutApp extends ConsumerWidget {
  const DeScoutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final talker = ref.watch(talkerProvider);
    final isAdmin = ref.watch(isAdminProvider).value ?? false;
    final showTalker = talkerUiEnabled(isAdmin: isAdmin);

    return MaterialApp.router(
      title: "DeScout",
      routerConfig: router,
      theme: DeScoutLightTheme(Typography.material2021().black),
      darkTheme: DeScoutDarkTheme(Typography.material2021().white),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return TalkerWrapper(
          talker: talker,
          options: const TalkerWrapperOptions(
            enableErrorAlerts: false,
            enableExceptionAlerts: false,
          ),
          child: TalkerDiagnosticsHost(
            talker: talker,
            enabled: showTalker,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
