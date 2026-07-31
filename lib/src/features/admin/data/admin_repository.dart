// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/features/admin/data/admin_functions_client.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "admin_repository.g.dart";

/// Admin review-queue data access via Edge Functions.
class AdminRepository {
  const AdminRepository(this._functions, this._errors);

  final AdminFunctionsClientLike _functions;
  final ErrorReporter _errors;

  Future<List<Programme>> fetchUnreviewedProgrammes() {
    return _errors.guard(
      userMessage: ErrorMapper.adminMessage,
      action: () async {
        final response = await _functions.invokeFetchUnreviewed();
        _ensureSuccess(response);
        final data = response.data;
        if (data is! List) {
          return [];
        }
        return data
            .cast<Map<String, dynamic>>()
            .map((row) => Programme.fromRow(ProgrammesRow.fromJson(row)))
            .toList();
      },
    );
  }

  Future<void> approveProgramme(String id) {
    return _updateProgramme(id: id, action: "approve");
  }

  Future<void> rejectProgramme(String id) {
    return _updateProgramme(id: id, action: "reject");
  }

  Future<void> updateProgrammeField(String id, Map<String, dynamic> fields) {
    return _updateProgramme(id: id, action: "update", fields: fields);
  }

  Future<void> _updateProgramme({
    required String id,
    required String action,
    Map<String, dynamic>? fields,
  }) {
    return _errors.guard(
      userMessage: ErrorMapper.adminMessage,
      action: () async {
        final body = <String, dynamic>{"id": id, "action": action};
        if (fields != null && fields.isNotEmpty) {
          body["fields"] = fields;
        }
        final response = await _functions.invokeUpdateProgramme(body);
        _ensureSuccess(response);
      },
    );
  }

  void _ensureSuccess(FunctionResponse response) {
    if (response.status == 403) {
      throw const DeScoutException(ErrorMapper.adminAccessMessage);
    }
    if (response.status < 200 || response.status >= 300) {
      throw const DeScoutException(ErrorMapper.adminMessage);
    }
  }
}

@riverpod
AdminFunctionsClient adminFunctionsClient(AdminFunctionsClientRef ref) {
  return AdminFunctionsClient(ref.watch(supabaseClientProvider));
}

@riverpod
AdminRepository adminRepository(AdminRepositoryRef ref) {
  return AdminRepository(
    ref.watch(adminFunctionsClientProvider),
    ref.watch(errorReporterProvider),
  );
}
