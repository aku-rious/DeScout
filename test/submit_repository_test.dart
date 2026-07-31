// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:de_scout/src/features/submit/data/submit_remote_data_source.dart";
import "package:de_scout/src/features/submit/data/submit_repository.dart";
import "package:de_scout/src/features/submit/domain/submit_programme_input.dart";
import "package:flutter_test/flutter_test.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:talker/talker.dart";

void main() {
  group("SubmitRepository.submitProgramme", () {
    late _FakeSubmitRemote remote;
    late SubmitRepository repository;

    setUp(() {
      remote = _FakeSubmitRemote();
      repository = SubmitRepository(
        remote,
        ErrorReporter(Talker()),
        () => remote.currentUserId,
      );
    });

    test("throws when user is not authenticated", () async {
      remote.currentUserId = null;

      await expectLater(
        repository.submitProgramme(
          const SubmitProgrammeInput(
            name: "Test Hack",
            url: "https://example.com/hack",
            type: ProgrammeType.hackathon,
          ),
        ),
        throwsA(
          isA<DeScoutException>().having(
            (e) => e.userMessage,
            "message",
            SubmitRepository.signInMessage,
          ),
        ),
      );
      expect(remote.lastInsert, isNull);
    });

    test("inserts unreviewed community row for authenticated user", () async {
      remote.currentUserId = "user-1";

      await repository.submitProgramme(
        const SubmitProgrammeInput(
          name: "Test Hack",
          url: "https://example.com/hack",
          type: ProgrammeType.hackathon,
          remote: true,
        ),
      );

      expect(remote.lastInsert, {
        "name": "Test Hack",
        "url": "https://example.com/hack",
        "type": "hackathon",
        "reviewed": false,
        "source": "community",
        "contributor_id": "user-1",
        "status": "unknown",
        "remote": true,
      });
    });

    test("maps duplicate URL to friendly message", () async {
      remote.currentUserId = "user-1";
      remote.insertError = const PostgrestException(
        message: "duplicate key",
        code: "23505",
      );

      await expectLater(
        repository.submitProgramme(
          const SubmitProgrammeInput(
            name: "Test Hack",
            url: "https://example.com/hack",
            type: ProgrammeType.hackathon,
          ),
        ),
        throwsA(
          isA<DeScoutException>().having(
            (e) => e.userMessage,
            "message",
            ErrorMapper.duplicateUrlMessage,
          ),
        ),
      );
    });
  });
}

class _FakeSubmitRemote implements SubmitRemoteDataSourceLike {
  String? currentUserId;
  Map<String, Object?>? lastInsert;
  Object? insertError;

  @override
  Future<void> insertProgramme(Map<String, Object?> payload) async {
    if (insertError != null) {
      throw insertError!;
    }
    lastInsert = payload;
  }
}
