// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/notifications/notification_service.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/features/settings/data/user_settings_repository.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "settings_provider.g.dart";

@riverpod
UserSettingsRepository userSettingsRepository(UserSettingsRepositoryRef ref) {
  return UserSettingsRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(errorReporterProvider),
  );
}

@riverpod
class NotificationDaysBefore extends _$NotificationDaysBefore {
  @override
  Future<int> build() {
    return ref
        .watch(userSettingsRepositoryProvider)
        .fetchNotificationDaysBefore();
  }

  Future<void> updateDays(int days) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(userSettingsRepositoryProvider)
          .updateNotificationDaysBefore(days);
      return days;
    });
  }
}

@riverpod
Future<bool> notificationPermissionGranted(
  NotificationPermissionGrantedRef ref,
) {
  return ref.watch(notificationServiceProvider).hasPermission();
}
