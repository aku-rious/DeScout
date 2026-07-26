// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "dart:async";

import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// PostgREST access for `saved_programmes`.
class SavedRemoteDataSource implements SavedRemoteDataSourceLike {
  const SavedRemoteDataSource(this._client);

  final SupabaseClient _client;

  SupabaseClient get client => _client;

  @override
  Future<void> upsertSaved({
    required String userId,
    required String programmeId,
    required ApplicationStatus status,
  }) async {
    await _client.from(Tables.savedProgrammes).upsert({
      Cols.userId: userId,
      Cols.programmeId: programmeId,
      Cols.applicationStatus: status.toDb().name,
    }, onConflict: "${Cols.userId},${Cols.programmeId}");
  }

  @override
  Future<void> deleteSaved({
    required String userId,
    required String programmeId,
  }) async {
    await _client
        .from(Tables.savedProgrammes)
        .delete()
        .eq(Cols.userId, userId)
        .eq(Cols.programmeId, programmeId);
  }

  @override
  Future<void> updateApplicationStatus({
    required String userId,
    required String programmeId,
    required ApplicationStatus status,
  }) async {
    await _client
        .from(Tables.savedProgrammes)
        .update({Cols.applicationStatus: status.toDb().name})
        .eq(Cols.userId, userId)
        .eq(Cols.programmeId, programmeId);
  }

  @override
  Future<void> updateNotes({
    required String userId,
    required String programmeId,
    required String? notes,
  }) async {
    await _client
        .from(Tables.savedProgrammes)
        .update({Cols.notes: notes})
        .eq(Cols.userId, userId)
        .eq(Cols.programmeId, programmeId);
  }

  @override
  Future<List<SavedProgrammesRow>> fetchSavedProgrammes(String userId) async {
    final response = await _client
        .from(Tables.savedProgrammes)
        .select("*, programmes(*)")
        .eq(Cols.userId, userId)
        .order(Cols.createdAt, ascending: false);

    return (response as List)
        .cast<Map<String, dynamic>>()
        .map(SavedProgrammesRow.fromJson)
        .toList();
  }

  @override
  Stream<List<SavedProgrammesRow>> watchSavedProgrammes(String userId) {
    final controller = StreamController<List<SavedProgrammesRow>>();

    Future<void> emitLatest() async {
      if (controller.isClosed) {
        return;
      }
      try {
        final rows = await fetchSavedProgrammes(userId);
        if (!controller.isClosed) {
          controller.add(rows);
        }
      } catch (error, stackTrace) {
        if (!controller.isClosed) {
          controller.addError(error, stackTrace);
        }
      }
    }

    final channel = _client
        .channel("saved_programmes:$userId")
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: "public",
          table: Tables.savedProgrammes,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: Cols.userId,
            value: userId,
          ),
          callback: (_) => unawaited(emitLatest()),
        )
        .subscribe();

    unawaited(emitLatest());

    controller.onCancel = () async {
      await _client.removeChannel(channel);
      await controller.close();
    };

    return controller.stream;
  }
}

/// Data access contract for [SavedRepository] (enables fakes in tests).
abstract interface class SavedRemoteDataSourceLike {
  Future<void> upsertSaved({
    required String userId,
    required String programmeId,
    required ApplicationStatus status,
  });

  Future<void> deleteSaved({
    required String userId,
    required String programmeId,
  });

  Future<void> updateApplicationStatus({
    required String userId,
    required String programmeId,
    required ApplicationStatus status,
  });

  Future<void> updateNotes({
    required String userId,
    required String programmeId,
    required String? notes,
  });

  Future<List<SavedProgrammesRow>> fetchSavedProgrammes(String userId);

  Stream<List<SavedProgrammesRow>> watchSavedProgrammes(String userId);
}
