// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/features/saved/data/saved_remote_data_source.dart";
import "package:de_scout/src/features/saved/data/saved_repository.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";
import "package:de_scout/src/features/saved/domain/saved_programme.dart";
import "package:flutter_test/flutter_test.dart";
import "package:talker/talker.dart";

void main() {
  group("SavedProgramme", () {
    test("fromRow maps available programme", () {
      final row = SavedProgrammesRow(
        id: "save-1",
        userId: "user-1",
        programmeId: "prog-1",
        applicationStatus: ApplicationStatusDb.interested,
        notes: "Apply soon",
        createdAt: DateTime.utc(2026, 1, 1),
        programme: ProgrammesRow(
          id: "prog-1",
          name: "GSoC",
          url: "https://summerofcode.withgoogle.com",
          type: ProgrammeTypeDb.fellowship,
          status: ProgrammeStatusDb.open,
          source: "seed",
          reviewed: true,
          isAdminSubmitted: false,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );

      final saved = SavedProgramme.fromRow(row);

      expect(saved.isAvailable, isTrue);
      expect(saved.programme?.name, "GSoC");
      expect(saved.applicationStatus, ApplicationStatus.interested);
    });

    test("fromRow maps unavailable programme when join is null", () {
      final row = SavedProgrammesRow(
        id: "save-2",
        userId: "user-1",
        programmeId: "prog-2",
        applicationStatus: ApplicationStatusDb.applied,
        createdAt: DateTime.utc(2026, 1, 2),
      );

      final saved = SavedProgramme.fromRow(row);

      expect(saved.isAvailable, isFalse);
      expect(saved.programme, isNull);
      expect(saved.programmeId, "prog-2");
    });
  });

  group("SavedRepository.saveProgramme", () {
    late _FakeSavedRemote remote;
    late SavedRepository repository;

    setUp(() {
      remote = _FakeSavedRemote();
      repository = SavedRepository(
        remote,
        ErrorReporter(Talker()),
        () => remote.currentUserId,
      );
    });

    test("throws when user is not authenticated", () async {
      remote.currentUserId = null;

      await expectLater(
        repository.saveProgramme("prog-1"),
        throwsA(
          isA<DeScoutException>().having(
            (e) => e.userMessage,
            "message",
            "Sign in to save programmes.",
          ),
        ),
      );
      expect(remote.lastUpsert, isNull);
    });

    test("upserts interested row for authenticated user", () async {
      remote.currentUserId = "user-1";

      await repository.saveProgramme("prog-1");

      expect(remote.lastUpsert, {
        "userId": "user-1",
        "programmeId": "prog-1",
        "status": ApplicationStatus.interested,
      });
    });
  });

  group("SavedRepository.updateNotes", () {
    late _FakeSavedRemote remote;
    late SavedRepository repository;

    setUp(() {
      remote = _FakeSavedRemote();
      repository = SavedRepository(
        remote,
        ErrorReporter(Talker()),
        () => remote.currentUserId,
      );
      remote.currentUserId = "user-1";
    });

    test("rejects notes longer than 2000 characters", () async {
      final longNotes = "a" * 2001;

      await expectLater(
        repository.updateNotes("prog-1", longNotes),
        throwsA(
          isA<DeScoutException>().having(
            (e) => e.userMessage,
            "message",
            ErrorMapper.savedMessage,
          ),
        ),
      );
    });
  });
}

class _FakeSavedRemote implements SavedRemoteDataSourceLike {
  String? currentUserId;
  Map<String, Object?>? lastUpsert;

  @override
  Future<void> upsertSaved({
    required String userId,
    required String programmeId,
    required ApplicationStatus status,
  }) async {
    lastUpsert = {
      "userId": userId,
      "programmeId": programmeId,
      "status": status,
    };
  }

  @override
  Future<void> deleteSaved({
    required String userId,
    required String programmeId,
  }) async {}

  @override
  Future<void> updateApplicationStatus({
    required String userId,
    required String programmeId,
    required ApplicationStatus status,
  }) async {}

  @override
  Future<void> updateNotes({
    required String userId,
    required String programmeId,
    required String? notes,
  }) async {}

  @override
  Future<List<SavedProgrammesRow>> fetchSavedProgrammes(String userId) async =>
      [];

  @override
  Stream<List<SavedProgrammesRow>> watchSavedProgrammes(String userId) =>
      const Stream.empty();
}
