// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";

/// Active filter selections for the programmes browse screen.
class FilterState {
  const FilterState({
    this.type,
    this.remoteOnly = false,
    this.nigeriaEligibleOnly = false,
    this.paidOnly = false,
    this.status,
  });

  final ProgrammeType? type;
  final bool remoteOnly;
  final bool nigeriaEligibleOnly;
  final bool paidOnly;
  final ProgrammeStatus? status;

  FilterState copyWith({
    ProgrammeType? type,
    bool? remoteOnly,
    bool? nigeriaEligibleOnly,
    bool? paidOnly,
    ProgrammeStatus? status,
    bool clearType = false,
    bool clearStatus = false,
  }) {
    return FilterState(
      type: clearType ? null : (type ?? this.type),
      remoteOnly: remoteOnly ?? this.remoteOnly,
      nigeriaEligibleOnly: nigeriaEligibleOnly ?? this.nigeriaEligibleOnly,
      paidOnly: paidOnly ?? this.paidOnly,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasActiveFilters =>
      type != null ||
      remoteOnly ||
      nigeriaEligibleOnly ||
      paidOnly ||
      status != null;
}
