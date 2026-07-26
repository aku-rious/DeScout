// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:de_scout/src/features/programmes/presentation/programmes_list_screen.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programmes_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:supabase_flutter/supabase_flutter.dart";

void main() {
  testWidgets("empty list shows bookmark empty state and clears filters", (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => Stream<AuthState>.value(
            const AuthState(AuthChangeEvent.signedOut, null),
          ),
        ),
        programmesProvider.overrideWith((ref) async => []),
      ],
    );
    addTearDown(container.dispose);

    container.read(filterProvider.notifier).toggleRemoteOnly();
    expect(container.read(filterProvider).remoteOnly, isTrue);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProgrammesListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark_border_outlined), findsOneWidget);
    expect(find.text("No programmes found"), findsOneWidget);
    expect(find.text("Try adjusting your filters"), findsOneWidget);
    expect(find.text("Clear filters"), findsOneWidget);

    await tester.tap(find.text("Clear filters"));
    await tester.pumpAndSettle();

    expect(container.read(filterProvider).hasActiveFilters, isFalse);
  });
}
