// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/admin/presentation/review_queue_screen.dart";
import "package:de_scout/src/features/auth/presentation/login_screen.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:de_scout/src/features/auth/presentation/register_screen.dart";
import "package:de_scout/src/features/programmes/presentation/programme_detail_screen.dart";
import "package:de_scout/src/features/programmes/presentation/programmes_list_screen.dart";
import "package:de_scout/src/features/saved/presentation/saved_screen.dart";
import "package:de_scout/src/features/settings/presentation/settings_screen.dart";
import "package:de_scout/src/features/submit/presentation/submit_programme_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "app_router.g.dart";

const _authRequiredPaths = <String>{
  Routes.saved,
  Routes.settings,
  Routes.adminReview,
  Routes.submit,
};

bool _isAuthRoute(String path) =>
    path == Routes.login || path == Routes.register;

@riverpod
GoRouter router(RouterRef ref) {
  final refreshNotifier = ValueNotifier<int>(0);

  ref.listen(authStateProvider, (_, _) => refreshNotifier.value++);
  ref.listen(isAdminProvider, (_, _) => refreshNotifier.value++);

  return GoRouter(
    initialLocation: Routes.programmes,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final session = ref.read(authStateProvider).value?.session;
      final isLoggedIn = session != null;
      final isAdmin = ref.read(isAdminProvider).value ?? false;

      if (path == "/") {
        return Routes.programmes;
      }

      if (!isLoggedIn && _authRequiredPaths.contains(path)) {
        return Routes.login;
      }

      if (isLoggedIn && _isAuthRoute(path)) {
        return Routes.programmes;
      }

      if (isLoggedIn && path == Routes.adminReview && !isAdmin) {
        return Routes.programmes;
      }

      return null;
    },
    routes: [
      GoRoute(path: "/", redirect: (_, _) => Routes.programmes),
      GoRoute(
        path: Routes.programmes,
        name: "programmes",
        builder: (_, _) => const ProgrammesListScreen(),
        routes: [
          GoRoute(
            path: ":id",
            name: "programmeDetail",
            builder: (_, state) =>
                ProgrammeDetailScreen(id: state.pathParameters["id"]!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.login,
        name: "login",
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        name: "register",
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.saved,
        name: "saved",
        builder: (_, _) => const SavedScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        name: "settings",
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.submit,
        name: "submit",
        builder: (_, _) => const SubmitProgrammeScreen(),
      ),
      GoRoute(
        path: Routes.adminReview,
        name: "adminReview",
        builder: (_, _) => const ReviewQueueScreen(),
      ),
    ],
  );
}
