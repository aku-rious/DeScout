// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/notifications/notification_service.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:de_scout/src/features/settings/presentation/providers/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

const _notificationDayOptions = [3, 5, 7, 14];

/// Account settings, sign-out, and admin diagnostics.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final email = authAsync.value?.session?.user.email;
    final isLoggedIn = authAsync.value?.session != null;
    final notificationService = ref.watch(notificationServiceProvider);
    final daysAsync = ref.watch(notificationDaysBeforeProvider);
    final permissionAsync = ref.watch(notificationPermissionGrantedProvider);

    ref.listen(notificationDaysBeforeProvider, (previous, next) {
      if (previous?.isLoading != true || next.isLoading) {
        return;
      }
      if (next.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMapper.userMessage(next.error))),
        );
      }
    });

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (email != null)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Signed in as"),
              subtitle: Text(email),
            ),
          if (isLoggedIn) ...[
            const SizedBox(height: 8),
            daysAsync.when(
              data: (days) => ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text("Notify me before deadline"),
                subtitle: Text("$days days before"),
                trailing: DropdownButton<int>(
                  value: days,
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final option in _notificationDayOptions)
                      DropdownMenuItem(
                        value: option,
                        child: Text("$option days"),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(notificationDaysBeforeProvider.notifier)
                          .updateDays(value);
                    }
                  },
                ),
              ),
              loading: () => const ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text("Notify me before deadline"),
                trailing: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, _) => const ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text("Notify me before deadline"),
                subtitle: Text("Could not load preference"),
              ),
            ),
            if (notificationService.pushAvailable)
              permissionAsync.when(
                data: (granted) {
                  if (granted) {
                    return const SizedBox.shrink();
                  }
                  return ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: const Text("Enable notifications"),
                    subtitle: const Text(
                      "Get deadline reminders for saved programmes",
                    ),
                    onTap: () async {
                      await notificationService.promptForPermission();
                      ref.invalidate(notificationPermissionGrantedProvider);
                    },
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
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
