// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/submit/data/submit_repository.dart";
import "package:de_scout/src/features/submit/domain/submit_programme_input.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "submit_provider.g.dart";

@riverpod
class SubmitController extends _$SubmitController {
  @override
  FutureOr<void> build() {}

  Future<void> submit(SubmitProgrammeInput input) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(submitRepositoryProvider).submitProgramme(input),
    );
  }
}
