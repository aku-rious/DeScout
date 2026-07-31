// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/features/admin/data/admin_functions_client.dart";
import "package:de_scout/src/features/admin/data/admin_repository.dart";
import "package:flutter_test/flutter_test.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:talker/talker.dart";

void main() {
  group("AdminRepository", () {
    late _FakeAdminFunctions functions;
    late AdminRepository repository;

    setUp(() {
      functions = _FakeAdminFunctions();
      repository = AdminRepository(functions, ErrorReporter(Talker()));
    });

    test("fetchUnreviewedProgrammes parses invoke response", () async {
      functions.fetchResponse = FunctionResponse(
        status: 200,
        data: [
          {
            "id": "prog-1",
            "name": "Pending Hack",
            "url": "https://example.com/pending",
            "type": "hackathon",
            "status": "unknown",
            "source": "community",
            "reviewed": false,
            "is_admin_submitted": false,
            "created_at": "2026-01-01T00:00:00.000Z",
            "updated_at": "2026-01-01T00:00:00.000Z",
          },
        ],
      );

      final programmes = await repository.fetchUnreviewedProgrammes();

      expect(functions.lastFetchInvoke, "admin_fetch_unreviewed");
      expect(programmes, hasLength(1));
      expect(programmes.first.name, "Pending Hack");
      expect(programmes.first.source, "community");
    });

    test("approveProgramme sends approve action", () async {
      functions.updateResponse = FunctionResponse(
        status: 200,
        data: {"ok": true},
      );

      await repository.approveProgramme("prog-1");

      expect(functions.lastUpdateBody, {"id": "prog-1", "action": "approve"});
    });

    test("maps 403 from edge function to admin access message", () async {
      functions.fetchResponse = FunctionResponse(
        status: 403,
        data: {"error": "Forbidden"},
      );

      await expectLater(
        repository.fetchUnreviewedProgrammes(),
        throwsA(
          isA<DeScoutException>().having(
            (e) => e.userMessage,
            "message",
            ErrorMapper.adminAccessMessage,
          ),
        ),
      );
    });
  });
}

class _FakeAdminFunctions implements AdminFunctionsClientLike {
  FunctionResponse? fetchResponse;
  FunctionResponse? updateResponse;
  String? lastFetchInvoke;
  Map<String, dynamic>? lastUpdateBody;

  @override
  Future<FunctionResponse> invokeFetchUnreviewed() async {
    lastFetchInvoke = "admin_fetch_unreviewed";
    return fetchResponse!;
  }

  @override
  Future<FunctionResponse> invokeUpdateProgramme(
    Map<String, dynamic> body,
  ) async {
    lastUpdateBody = body;
    return updateResponse!;
  }
}
