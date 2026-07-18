// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/filter_state.dart";
import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "filter_provider.g.dart";

@riverpod
class Filter extends _$Filter {
  @override
  FilterState build() => const FilterState();

  void setType(ProgrammeType? type) {
    state = state.copyWith(type: type, clearType: type == null);
  }

  void toggleRemoteOnly() {
    state = state.copyWith(remoteOnly: !state.remoteOnly);
  }

  void toggleNigeriaEligibleOnly() {
    state = state.copyWith(nigeriaEligibleOnly: !state.nigeriaEligibleOnly);
  }

  void togglePaidOnly() {
    state = state.copyWith(paidOnly: !state.paidOnly);
  }

  void setStatus(ProgrammeStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void clearAll() {
    state = const FilterState();
  }
}
