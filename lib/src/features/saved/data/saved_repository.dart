// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "dart:async";

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/features/saved/data/saved_remote_data_source.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";
import "package:de_scout/src/features/saved/domain/saved_programme.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "saved_repository.g.dart";

/// User bookmark and application-tracking data access.
class SavedRepository {
  SavedRepository(this._remote, this._errors, this._currentUserId);

  final SavedRemoteDataSourceLike _remote;
  final ErrorReporter _errors;
  final String? Function() _currentUserId;

  static const _maxNotesLength = 2000;
  static const _signInMessage = "Sign in to save programmes.";

  Future<void> saveProgramme(String programmeId) {
    return _errors.guard(
      userMessage: ErrorMapper.savedMessage,
      action: () async {
        final userId = _requireUserId();
        await _remote.upsertSaved(
          userId: userId,
          programmeId: programmeId,
          status: ApplicationStatus.interested,
        );
      },
    );
  }

  Future<void> unsaveProgramme(String programmeId) {
    return _errors.guard(
      userMessage: ErrorMapper.savedMessage,
      action: () async {
        final userId = _requireUserId();
        await _remote.deleteSaved(userId: userId, programmeId: programmeId);
      },
    );
  }

  Future<void> updateApplicationStatus(
    String programmeId,
    ApplicationStatus status,
  ) {
    return _errors.guard(
      userMessage: ErrorMapper.savedMessage,
      action: () async {
        final userId = _requireUserId();
        await _remote.updateApplicationStatus(
          userId: userId,
          programmeId: programmeId,
          status: status,
        );
      },
    );
  }

  Future<void> updateNotes(String programmeId, String notes) {
    return _errors.guard(
      userMessage: ErrorMapper.savedMessage,
      action: () async {
        final userId = _requireUserId();
        if (notes.length > _maxNotesLength) {
          throw const DeScoutException(ErrorMapper.savedMessage);
        }
        await _remote.updateNotes(
          userId: userId,
          programmeId: programmeId,
          notes: notes.isEmpty ? null : notes,
        );
      },
    );
  }

  Stream<List<SavedProgramme>> watchSavedProgrammes() {
    final userId = _currentUserId();
    if (userId == null) {
      return Stream.value([]);
    }

    return _remote
        .watchSavedProgrammes(userId)
        .map((rows) => rows.map(SavedProgramme.fromRow).toList());
  }

  String _requireUserId() {
    final userId = _currentUserId();
    if (userId == null) {
      throw const DeScoutException(_signInMessage);
    }
    return userId;
  }
}

@riverpod
SavedRemoteDataSource savedRemoteDataSource(SavedRemoteDataSourceRef ref) {
  return SavedRemoteDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
SavedRepository savedRepository(SavedRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  final remote = ref.watch(savedRemoteDataSourceProvider);
  return SavedRepository(
    remote,
    ref.watch(errorReporterProvider),
    () => client.auth.currentUser?.id,
  );
}
