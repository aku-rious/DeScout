// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/programmes/domain/filter_state.dart";
import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Fetches programme rows from Supabase PostgREST.
class ProgrammesRemoteDataSource {
  const ProgrammesRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<List<ProgrammesRow>> fetchReviewedProgrammes(
    FilterState filters,
  ) async {
    var query = _client
        .from(Tables.programmes)
        .select()
        .eq(Cols.reviewed, true)
        .neq(Cols.status, ProgrammeStatus.closed.name);

    if (filters.type != null) {
      query = query.eq(Cols.type, filters.type!.name);
    }
    if (filters.remoteOnly) {
      query = query.eq("remote", true);
    }
    if (filters.nigeriaEligibleOnly) {
      query = query.eq(Cols.nigeriaEligible, true);
    }
    if (filters.paidOnly) {
      query = query.not("stipend_usd", "is", null);
    }
    if (filters.status != null) {
      query = query.eq(Cols.status, filters.status!.name);
    }

    final response = await query.order(Cols.closesAt, ascending: true);
    return (response as List)
        .cast<Map<String, dynamic>>()
        .map(ProgrammesRow.fromJson)
        .toList();
  }

  Future<ProgrammesRow?> fetchProgrammeById(String id) async {
    final response = await _client
        .from(Tables.programmes)
        .select()
        .eq(Cols.id, id)
        .eq(Cols.reviewed, true)
        .maybeSingle();
    if (response == null) {
      return null;
    }
    return ProgrammesRow.fromJson(response);
  }
}
