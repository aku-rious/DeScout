// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/submit/data/submit_remote_data_source.dart";
import "package:de_scout/src/features/submit/domain/submit_programme_input.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "submit_repository.g.dart";

/// Community programme submission data access.
class SubmitRepository {
  const SubmitRepository(this._remote, this._errors, this._currentUserId);

  static const signInMessage = "Sign in to submit a programme.";

  final SubmitRemoteDataSourceLike _remote;
  final ErrorReporter _errors;
  final String? Function() _currentUserId;

  Future<void> submitProgramme(SubmitProgrammeInput input) {
    return _errors.guard(
      userMessage: ErrorMapper.submitMessage,
      action: () async {
        final userId = _requireUserId();
        try {
          await _remote.insertProgramme(_toPayload(input, userId));
        } on PostgrestException catch (error) {
          if (error.code == "23505") {
            throw const DeScoutException(ErrorMapper.duplicateUrlMessage);
          }
          rethrow;
        }
      },
    );
  }

  Map<String, Object?> _toPayload(SubmitProgrammeInput input, String userId) {
    final payload = <String, Object?>{
      Cols.name: input.name,
      Cols.url: input.url,
      Cols.type: input.type.name,
      Cols.reviewed: false,
      Cols.source: "community",
      Cols.contributorId: userId,
      Cols.status: "unknown",
    };

    if (input.stipendUsd != null) {
      payload[Cols.stipendUsd] = input.stipendUsd;
    }
    if (input.remote != null) {
      payload[Cols.remote] = input.remote;
    }
    if (input.nigeriaEligible != null) {
      payload[Cols.nigeriaEligible] = input.nigeriaEligible;
    }
    if (input.opensAt != null) {
      payload[Cols.opensAt] = input.opensAt!.toUtc().toIso8601String();
    }
    if (input.closesAt != null) {
      payload[Cols.closesAt] = input.closesAt!.toUtc().toIso8601String();
    }
    if (input.description != null && input.description!.isNotEmpty) {
      payload[Cols.description] = input.description;
    }

    return payload;
  }

  String _requireUserId() {
    final userId = _currentUserId();
    if (userId == null) {
      throw const DeScoutException(signInMessage);
    }
    return userId;
  }
}

@riverpod
SubmitRemoteDataSource submitRemoteDataSource(SubmitRemoteDataSourceRef ref) {
  return SubmitRemoteDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
SubmitRepository submitRepository(SubmitRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return SubmitRepository(
    ref.watch(submitRemoteDataSourceProvider),
    ref.watch(errorReporterProvider),
    () => client.auth.currentUser?.id,
  );
}
