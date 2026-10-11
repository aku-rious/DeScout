// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/data/programme_tips_repository.dart";
import "package:de_scout/src/features/programmes/data/programmes_repository.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/domain/programme_tip.dart";
import "package:de_scout/src/features/programmes/domain/tag.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "programme_tips_provider.g.dart";

@riverpod
class ProgrammeTips extends _$ProgrammeTips {
  @override
  Future<List<ProgrammeTip>> build(String programmeId) {
    return ref
        .watch(programmeTipsRepositoryProvider)
        .fetchTips(programmeId);
  }

  Future<void> addTip(String text) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(programmeTipsRepositoryProvider).addTip(programmeId, text);
      return ref.read(programmeTipsRepositoryProvider).fetchTips(programmeId);
    });
  }
}

@riverpod
Future<List<Tag>> programmeTags(ProgrammeTagsRef ref, String programmeId) {
  return ref.watch(programmesRepositoryProvider).fetchProgrammeTags(programmeId);
}

@riverpod
Future<List<Programme>> similarProgrammes(
  SimilarProgrammesRef ref,
  String programmeId,
  List<String> tagIds,
) {
  return ref
      .watch(programmesRepositoryProvider)
      .fetchSimilarProgrammes(programmeId, tagIds);
}
