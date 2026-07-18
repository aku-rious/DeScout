// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/features/programmes/data/programmes_remote_data_source.dart";
import "package:de_scout/src/features/programmes/domain/filter_state.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "programmes_repository.g.dart";

@riverpod
ProgrammesRemoteDataSource programmesRemoteDataSource(
  ProgrammesRemoteDataSourceRef ref,
) {
  return ProgrammesRemoteDataSource(ref.watch(supabaseClientProvider));
}

/// Loads and maps reviewed programmes from Supabase.
class ProgrammesRepository {
  const ProgrammesRepository(this._remote, this._errors);

  final ProgrammesRemoteDataSource _remote;
  final ErrorReporter _errors;

  Future<List<Programme>> fetchProgrammes(FilterState filters) {
    return _errors.guard(
      userMessage: ErrorMapper.programmesMessage,
      action: () async {
        final rows = await _remote.fetchReviewedProgrammes(filters);
        return rows.map(Programme.fromRow).toList();
      },
    );
  }

  Future<Programme?> fetchProgrammeById(String id) {
    return _errors.guard(
      userMessage: ErrorMapper.programmesMessage,
      action: () async {
        final row = await _remote.fetchProgrammeById(id);
        return row == null ? null : Programme.fromRow(row);
      },
    );
  }
}

@riverpod
ProgrammesRepository programmesRepository(ProgrammesRepositoryRef ref) {
  return ProgrammesRepository(
    ref.watch(programmesRemoteDataSourceProvider),
    ref.watch(errorReporterProvider),
  );
}
