// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/de_scout_exception.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// User profile preferences stored in `users`.
class UserSettingsRepository {
  const UserSettingsRepository(this._client, this._errors);

  final SupabaseClient _client;
  final ErrorReporter _errors;

  Future<int> fetchNotificationDaysBefore() {
    return _errors.guard(
      userMessage: ErrorMapper.genericMessage,
      action: () async {
        final userId = _requireUserId();
        final response = await _client
            .from(Tables.users)
            .select(Cols.notificationDaysBefore)
            .eq(Cols.id, userId)
            .single();
        return UsersRow.fromJson(response).notificationDaysBefore;
      },
    );
  }

  Future<void> updateNotificationDaysBefore(int days) {
    return _errors.guard(
      userMessage: ErrorMapper.genericMessage,
      action: () async {
        final userId = _requireUserId();
        await _client
            .from(Tables.users)
            .update({Cols.notificationDaysBefore: days})
            .eq(Cols.id, userId);
      },
    );
  }

  Future<void> updatePushFlavor({
    required String userId,
    required String flavor,
  }) {
    return _errors.guard(
      userMessage: ErrorMapper.genericMessage,
      action: () async {
        final currentUserId = _client.auth.currentUser?.id;
        if (currentUserId == null || currentUserId != userId) {
          throw const DeScoutException(ErrorMapper.genericMessage);
        }
        await _client
            .from(Tables.users)
            .update({Cols.pushFlavor: flavor})
            .eq(Cols.id, userId);
      },
    );
  }

  String _requireUserId() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const DeScoutException(ErrorMapper.genericMessage);
    }
    return userId;
  }
}
