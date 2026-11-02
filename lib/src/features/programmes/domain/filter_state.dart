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
    this.tagSlug,
    this.searchQuery = "",
    this.verifiedOnly = false,
  });

  final ProgrammeType? type;
  final bool remoteOnly;
  final bool nigeriaEligibleOnly;
  final bool paidOnly;
  final ProgrammeStatus? status;
  final String? tagSlug;
  final String searchQuery;
  final bool verifiedOnly;

  FilterState copyWith({
    ProgrammeType? type,
    bool? remoteOnly,
    bool? nigeriaEligibleOnly,
    bool? paidOnly,
    ProgrammeStatus? status,
    String? tagSlug,
    String? searchQuery,
    bool? verifiedOnly,
    bool clearType = false,
    bool clearStatus = false,
    bool clearTagSlug = false,
  }) {
    return FilterState(
      type: clearType ? null : (type ?? this.type),
      remoteOnly: remoteOnly ?? this.remoteOnly,
      nigeriaEligibleOnly: nigeriaEligibleOnly ?? this.nigeriaEligibleOnly,
      paidOnly: paidOnly ?? this.paidOnly,
      status: clearStatus ? null : (status ?? this.status),
      tagSlug: clearTagSlug ? null : (tagSlug ?? this.tagSlug),
      searchQuery: searchQuery ?? this.searchQuery,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
    );
  }

  bool get hasActiveFilters =>
      type != null ||
      remoteOnly ||
      nigeriaEligibleOnly ||
      paidOnly ||
      status != null ||
      tagSlug != null ||
      searchQuery.isNotEmpty ||
      verifiedOnly;
}
