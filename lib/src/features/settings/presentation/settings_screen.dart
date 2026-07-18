// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/logging/talker_provider.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:talker_flutter/talker_flutter.dart";

/// Account settings, sign-out, and admin diagnostics.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final email = authAsync.value?.session?.user.email;
    final isAdmin = ref.watch(isAdminProvider).value ?? false;
    final showDiagnostics = talkerUiEnabled(isAdmin: isAdmin);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (email != null)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Signed in as"),
              subtitle: Text(email),
            ),
          if (showDiagnostics) ...[
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: const Text("Diagnostics"),
              subtitle: Text(
                kDebugMode
                    ? "View Talker logs (dev build)"
                    : "View Talker logs (admin)",
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        TalkerScreen(talker: ref.read(talkerProvider)),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go(Routes.programmes);
              }
            },
            child: const Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
