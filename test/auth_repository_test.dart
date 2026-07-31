// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/features/auth/data/auth_repository.dart";
import "package:flutter_test/flutter_test.dart";
import "package:talker/talker.dart";

void main() {
  group("AuthRepository.isCurrentUserAdmin", () {
    test("reads is_admin from partial select row", () async {
      final client = _FakeAuthClient(
        userId: "user-1",
        userRow: {"is_admin": true},
      );
      final repository = AuthRepository(client, ErrorReporter(Talker()));

      final isAdmin = await repository.isCurrentUserAdmin();

      expect(isAdmin, isTrue);
    });

    test("returns false when user row is missing", () async {
      final client = _FakeAuthClient(userId: "user-1");
      final repository = AuthRepository(client, ErrorReporter(Talker()));

      final isAdmin = await repository.isCurrentUserAdmin();

      expect(isAdmin, isFalse);
    });

    test("returns false when not signed in", () async {
      final client = _FakeAuthClient();
      final repository = AuthRepository(client, ErrorReporter(Talker()));

      final isAdmin = await isAdmin = await repository.isCurrentUserAdmin();

      expect(isAdmin, isFalse);
    });
  });
}

class _FakeAuthClient implements AuthClientLike {
  _FakeAuthClient({this.userId, this.userRow});

  final String? userId;
  final Map<String, dynamic>? userRow;

  @override
  String? get currentUserId => userId;

  @override
  Future<Map<String, dynamic>?> fetchIsAdmin(String userId) async => userRow;
}
