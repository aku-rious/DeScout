// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:supabase_flutter/supabase_flutter.dart";

/// Initialises Supabase once per app process. Call from each `main_*.dart`.
Future<void> initSupabase() async {
  await Supabase.initialize(
    url: const String.fromEnvironment("DESCOUT_SUPABASE_URL"),
    publishableKey: const String.fromEnvironment("DESCOUT_SUPABASE_ANON_KEY"),
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}
