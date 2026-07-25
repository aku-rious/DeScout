// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:de_scout/src/features/programmes/presentation/programme_detail_screen.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programmes_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("detail screen shows Deadline TBA when closes_at is null", (
    tester,
  ) async {
    const programme = Programme(
      id: "test-id",
      name: "Test Programme",
      url: "https://example.com",
      type: ProgrammeType.fellowship,
      status: ProgrammeStatus.open,
      source: "manual",
      closesAt: null,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          programmeDetailProvider(
            "test-id",
          ).overrideWith((ref) async => programme),
        ],
        child: const MaterialApp(home: ProgrammeDetailScreen(id: "test-id")),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Deadline TBA"), findsOneWidget);
    expect(find.text("No deadline"), findsNothing);
    expect(find.byType(DeadlineBadge), findsOneWidget);
  });
}
