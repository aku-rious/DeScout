// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Auth and user-profile data access.
class AuthRepository {
  const AuthRepository(this._client, this._errors);

  final SupabaseClient _client;
  final ErrorReporter _errors;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _errors.guard(
      userMessage: ErrorMapper.authMessage,
      action: () =>
          _client.auth.signInWithPassword(email: email, password: password),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _errors.guard(
      userMessage: ErrorMapper.authMessage,
      action: () => _client.auth.signUp(email: email, password: password),
    );
  }

  Future<void> signOut() {
    return _errors.guard(
      userMessage: ErrorMapper.genericMessage,
      action: () => _client.auth.signOut(),
    );
  }

  /// Returns whether the signed-in user has admin privileges.
  Future<bool> isCurrentUserAdmin() {
    return _errors.guard(
      userMessage: ErrorMapper.genericMessage,
      action: () async {
        final userId = _client.auth.currentUser?.id;
        if (userId == null) {
          return false;
        }
        final response = await _client
            .from(Tables.users)
            .select(Cols.isAdmin)
            .eq(Cols.id, userId)
            .maybeSingle();
        if (response == null) {
          return false;
        }
        return UsersRow.fromJson(response).isAdmin;
      },
    );
  }
}
