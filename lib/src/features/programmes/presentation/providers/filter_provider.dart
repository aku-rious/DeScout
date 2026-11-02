// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/filter_state.dart";
import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "filter_provider.g.dart";

const _verifiedOnlyKey = "verified_only";

@riverpod
class Filter extends _$Filter {
  @override
  FilterState build() {
    Future.microtask(_loadVerifiedOnlyFromPrefs);
    return const FilterState();
  }

  Future<void> _loadVerifiedOnlyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final verifiedOnly = prefs.getBool(_verifiedOnlyKey) ?? false;
    if (verifiedOnly != state.verifiedOnly) {
      state = state.copyWith(verifiedOnly: verifiedOnly);
    }
  }

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

  void setTagSlug(String? slug) {
    state = state.copyWith(tagSlug: slug, clearTagSlug: slug == null);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  Future<void> toggleVerifiedOnly() async {
    final next = !state.verifiedOnly;
    state = state.copyWith(verifiedOnly: next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_verifiedOnlyKey, next);
  }

  void clearTag() {
    state = state.copyWith(clearTagSlug: true);
  }

  void clearAll() {
    state = const FilterState();
  }
}
