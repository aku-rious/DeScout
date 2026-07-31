// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/admin/data/admin_repository.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "review_queue_provider.g.dart";

@riverpod
class ReviewQueue extends _$ReviewQueue {
  @override
  Future<List<Programme>> build() {
    return ref.read(adminRepositoryProvider).fetchUnreviewedProgrammes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> approve(String id) async {
    await ref.read(adminRepositoryProvider).approveProgramme(id);
    ref.invalidateSelf();
  }

  Future<void> reject(String id) async {
    await ref.read(adminRepositoryProvider).rejectProgramme(id);
    ref.invalidateSelf();
  }

  Future<void> editAndApprove(String id, Map<String, dynamic> fields) async {
    final repository = ref.read(adminRepositoryProvider);
    await repository.updateProgrammeField(id, fields);
    await repository.approveProgramme(id);
    ref.invalidateSelf();
  }
}
