// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/table_names.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Contract for programme submission inserts (testable via fake).
abstract interface class SubmitRemoteDataSourceLike {
  Future<void> insertProgramme(Map<String, Object?> payload);
}

/// Inserts community programme submissions via Supabase PostgREST.
class SubmitRemoteDataSource implements SubmitRemoteDataSourceLike {
  const SubmitRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<void> insertProgramme(Map<String, Object?> payload) async {
    await _client.from(Tables.programmes).insert(payload);
  }
}
