// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/data/programmes_repository.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "programmes_provider.g.dart";

@riverpod
Future<List<Programme>> programmes(ProgrammesRef ref) {
  final filters = ref.watch(filterProvider);
  return ref.watch(programmesRepositoryProvider).fetchProgrammes(filters);
}

@riverpod
Future<Programme?> programmeDetail(ProgrammeDetailRef ref, String id) {
  return ref.watch(programmesRepositoryProvider).fetchProgrammeById(id);
}
