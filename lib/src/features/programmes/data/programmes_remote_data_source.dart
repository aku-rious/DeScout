// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/programmes/domain/filter_state.dart";
import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/tag.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Fetches programme rows from Supabase PostgREST.
class ProgrammesRemoteDataSource {
  const ProgrammesRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<List<ProgrammesRow>> fetchReviewedProgrammes(
    FilterState filters,
  ) async {
    final hasTagFilter = filters.tagSlug != null && filters.tagSlug!.isNotEmpty;

    var query = _client
        .from(Tables.programmes)
        .select(hasTagFilter ? "*, programme_tags!inner(tags!inner(slug))" : "*")
        .eq(Cols.reviewed, true)
        .neq(Cols.status, ProgrammeStatus.closed.name);

    if (hasTagFilter) {
      query = query.eq("programme_tags.tags.slug", filters.tagSlug!);
    }
    if (filters.type != null) {
      query = query.eq(Cols.type, filters.type!.name);
    }
    if (filters.remoteOnly) {
      query = query.eq(Cols.remote, true);
    }
    if (filters.nigeriaEligibleOnly) {
      query = query.eq(Cols.nigeriaEligible, true);
    }
    if (filters.paidOnly) {
      query = query.not(Cols.stipendUsd, "is", null);
    }
    if (filters.status != null) {
      query = query.eq(Cols.status, filters.status!.name);
    }
    if (filters.searchQuery.isNotEmpty) {
      query = query.ilike(Cols.name, "%${filters.searchQuery}%");
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

  Future<List<Tag>> fetchProgrammeTags(String programmeId) async {
    final response = await _client
        .from(Tables.programmeTags)
        .select("tags(id, name, slug)")
        .eq(Cols.programmeId, programmeId);

    return (response as List)
        .cast<Map<String, dynamic>>()
        .map((row) {
          final tagJson = row["tags"] as Map<String, dynamic>?;
          if (tagJson == null) {
            return null;
          }
          return Tag.fromRow(TagsRow.fromJson(tagJson));
        })
        .whereType<Tag>()
        .toList();
  }

  Future<List<ProgrammesRow>> fetchSimilarProgrammes({
    required String programmeId,
    required List<String> tagIds,
  }) async {
    if (tagIds.isEmpty) {
      return [];
    }

    final linkRows = await _client
        .from(Tables.programmeTags)
        .select(Cols.programmeId)
        .inFilter(Cols.tagId, tagIds)
        .neq(Cols.programmeId, programmeId);

    final programmeIds = (linkRows as List)
        .cast<Map<String, dynamic>>()
        .map((row) => row[Cols.programmeId] as String)
        .toSet()
        .toList();

    if (programmeIds.isEmpty) {
      return [];
    }

    final response = await _client
        .from(Tables.programmes)
        .select()
        .inFilter(Cols.id, programmeIds)
        .eq(Cols.reviewed, true)
        .neq(Cols.status, ProgrammeStatus.closed.name)
        .order(Cols.closesAt, ascending: true)
        .limit(5);

    return (response as List)
        .cast<Map<String, dynamic>>()
        .map(ProgrammesRow.fromJson)
        .toList();
  }
}
