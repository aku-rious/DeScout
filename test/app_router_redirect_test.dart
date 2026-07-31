// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/router/app_router.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:supabase_flutter/supabase_flutter.dart";

void main() {
  testWidgets("unauthenticated /saved redirects to login with from param", (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => Stream<AuthState>.value(
            const AuthState(AuthChangeEvent.signedOut, null),
          ),
        ),
        isAdminProvider.overrideWith((ref) async => false),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go(Routes.saved);
    await tester.pumpAndSettle();

    final location = router.routerDelegate.currentConfiguration.uri.toString();
    expect(location, startsWith(Routes.login));
    expect(location, contains("from="));
    expect(Uri.decodeComponent(location), contains(Routes.saved));
    expect(find.widgetWithText(AppBar, "Sign in"), findsOneWidget);
  });

  testWidgets("shell renders three bottom navigation tabs", (tester) async {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => Stream<AuthState>.value(
            const AuthState(AuthChangeEvent.signedOut, null),
          ),
        ),
        isAdminProvider.overrideWith((ref) async => false),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Programmes"), findsOneWidget);
    expect(find.text("Saved"), findsOneWidget);
    expect(find.text("Settings"), findsOneWidget);
  });

  testWidgets("unauthenticated /settings redirects to login with from param", (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => Stream<AuthState>.value(
            const AuthState(AuthChangeEvent.signedOut, null),
          ),
        ),
        isAdminProvider.overrideWith((ref) async => false),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go(Routes.settings);
    await tester.pumpAndSettle();

    final location = router.routerDelegate.currentConfiguration.uri.toString();
    expect(location, startsWith(Routes.login));
    expect(Uri.decodeComponent(location), contains(Routes.settings));
  });

  testWidgets("non-admin authenticated /admin/review redirects to programmes", (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => Stream<AuthState>.value(
            AuthState(
              AuthChangeEvent.signedIn,
              Session(
                accessToken: "token",
                tokenType: "bearer",
                user: const User(
                  id: "user-1",
                  appMetadata: {},
                  userMetadata: {},
                  aud: "authenticated",
                  createdAt: "2026-01-01T00:00:00.000Z",
                ),
              ),
            ),
          ),
        ),
        isAdminProvider.overrideWith((ref) async => false),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go(Routes.adminReview);
    await tester.pumpAndSettle();

    final location = router.routerDelegate.currentConfiguration.uri.path;
    expect(location, Routes.programmes);
  });

  testWidgets("unauthenticated /submit stays on submit with sign-in prompt", (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => Stream<AuthState>.value(
            const AuthState(AuthChangeEvent.signedOut, null),
          ),
        ),
        isAdminProvider.overrideWith((ref) async => false),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go(Routes.submit);
    await tester.pumpAndSettle();

    final location = router.routerDelegate.currentConfiguration.uri.path;
    expect(location, Routes.submit);
    expect(find.text("Sign in to submit a programme"), findsOneWidget);
  });
}
