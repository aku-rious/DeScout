// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "dart:async";

import "package:de_scout/src/core/notifications/notification_service.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:de_scout/src/features/saved/data/saved_repository.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";
import "package:de_scout/src/features/saved/domain/saved_programme.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "saved_provider.g.dart";

const _notificationPromptShownKey = "notification_prompt_shown";

@riverpod
class SavedProgrammes extends _$SavedProgrammes {
  @override
  Stream<List<SavedProgramme>> build() {
    ref.listen(authStateProvider, (previous, next) {
      final wasLoggedIn = previous?.value?.session != null;
      final isLoggedIn = next.value?.session != null;
      if (wasLoggedIn != isLoggedIn) {
        ref.invalidateSelf();
      }
    });

    final session = ref.watch(authStateProvider).value?.session;
    if (session == null) {
      return Stream.value([]);
    }

    final repository = ref.watch(savedRepositoryProvider);
    return repository.watchSavedProgrammes();
  }
}

@riverpod
bool isSaved(IsSavedRef ref, String programmeId) {
  final savedAsync = ref.watch(savedProgrammesProvider);
  final saved = savedAsync.valueOrNull ?? [];
  return saved.any((item) => item.programmeId == programmeId);
}

@riverpod
SavedProgramme? savedProgrammeById(
  SavedProgrammeByIdRef ref,
  String programmeId,
) {
  final savedAsync = ref.watch(savedProgrammesProvider);
  final saved = savedAsync.valueOrNull ?? [];
  for (final item in saved) {
    if (item.programmeId == programmeId) {
      return item;
    }
  }
  return null;
}

@riverpod
class SavedController extends _$SavedController {
  @override
  FutureOr<void> build() {}

  Future<void> toggleSave(String programmeId) async {
    final repository = ref.read(savedRepositoryProvider);
    final saved = ref.read(isSavedProvider(programmeId));
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (saved) {
        await repository.unsaveProgramme(programmeId);
      } else {
        await repository.saveProgramme(programmeId);
        await _maybePromptForNotifications();
      }
    });
  }

  Future<void> unsave(String programmeId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(savedRepositoryProvider).unsaveProgramme(programmeId),
    );
  }

  Future<void> restoreSave(String programmeId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(savedRepositoryProvider).saveProgramme(programmeId),
    );
  }

  Future<void> updateStatus(
    String programmeId,
    ApplicationStatus status,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(savedRepositoryProvider)
          .updateApplicationStatus(programmeId, status),
    );
  }

  Future<void> updateNotes(String programmeId, String notes) async {
    state = await AsyncValue.guard(
      () => ref.read(savedRepositoryProvider).updateNotes(programmeId, notes),
    );
  }

  Future<void> _maybePromptForNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_notificationPromptShownKey) ?? false) {
      return;
    }
    await prefs.setBool(_notificationPromptShownKey, true);
    await ref.read(notificationServiceProvider).promptForPermission();
  }
}
