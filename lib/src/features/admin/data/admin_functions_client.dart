// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:supabase_flutter/supabase_flutter.dart";

/// Contract for admin Edge Function invocations (testable via fake).
abstract interface class AdminFunctionsClientLike {
  Future<FunctionResponse> invokeFetchUnreviewed();
  Future<FunctionResponse> invokeUpdateProgramme(Map<String, dynamic> body);
}

/// Invokes admin Edge Functions with the user's JWT.
class AdminFunctionsClient implements AdminFunctionsClientLike {
  const AdminFunctionsClient(this._client);

  final SupabaseClient _client;

  static const _fetchUnreviewed = "admin_fetch_unreviewed";
  static const _updateProgramme = "admin_update_programme";

  @override
  Future<FunctionResponse> invokeFetchUnreviewed() {
    return _client.functions.invoke(_fetchUnreviewed);
  }

  @override
  Future<FunctionResponse> invokeUpdateProgramme(Map<String, dynamic> body) {
    return _client.functions.invoke(_updateProgramme, body: body);
  }
}
