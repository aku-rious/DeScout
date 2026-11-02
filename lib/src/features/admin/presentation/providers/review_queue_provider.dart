// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/admin/data/admin_repository.dart";
import "package:de_scout/src/features/admin/domain/curation_queue_status.dart";
import "package:de_scout/src/features/admin/presentation/providers/review_queue_action_lock_provider.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programmes_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "review_queue_provider.g.dart";

@riverpod
class CurationQueue extends _$CurationQueue {
  @override
  Future<List<Programme>> build(CurationQueueStatus status) {
    return ref
        .read(adminRepositoryProvider)
        .fetchProgrammesForCuration(status);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(status));
  }

  Future<void> _withLock(String programmeId, Future<void> Function() action) async {
    final lock = ref.read(reviewQueueActionLockProvider.notifier);
    if (ref.read(reviewQueueActionLockProvider) != null) {
      return;
    }
    lock.setActive(programmeId);
    try {
      await action();
      ref.invalidate(programmesProvider);
      ref.invalidateSelf();
    } finally {
      lock.setActive(null);
    }
  }

  Future<void> verify(String id, {List<String>? tagSlugs}) async {
    await _withLock(id, () async {
      await ref.read(adminRepositoryProvider).verifyProgramme(id, tagSlugs: tagSlugs);
    });
  }

  Future<void> reject(String id) async {
    await _withLock(id, () async {
      await ref.read(adminRepositoryProvider).rejectProgramme(id);
    });
  }

  Future<void> restore(String id) async {
    await _withLock(id, () async {
      await ref.read(adminRepositoryProvider).restoreProgramme(id);
    });
  }

  Future<void> editAndVerify(
    String id,
    Map<String, dynamic> fields, {
    List<String>? tagSlugs,
  }) async {
    await _withLock(id, () async {
      final repository = ref.read(adminRepositoryProvider);
      await repository.updateProgrammeField(id, fields);
      await repository.verifyProgramme(id, tagSlugs: tagSlugs);
    });
  }
}
