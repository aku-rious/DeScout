// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_reporter.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/features/auth/data/auth_repository.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "auth_provider.g.dart";

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(errorReporterProvider),
  );
}

@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
}

@riverpod
Future<bool> isAdmin(IsAdminRef ref) async {
  final authAsync = ref.watch(authStateProvider);
  final session = authAsync.value?.session;
  if (session == null) {
    return false;
  }
  return ref.read(authRepositoryProvider).isCurrentUserAdmin();
}

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
  }
}
