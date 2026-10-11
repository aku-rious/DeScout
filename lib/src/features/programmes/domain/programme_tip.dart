// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";

/// Community-submitted applicant tip for a programme.
class ProgrammeTip {
  const ProgrammeTip({
    required this.id,
    required this.programmeId,
    required this.userId,
    required this.tipText,
    required this.createdAt,
  });

  factory ProgrammeTip.fromRow(ProgrammeTipsRow row) {
    return ProgrammeTip(
      id: row.id,
      programmeId: row.programmeId,
      userId: row.userId,
      tipText: row.tipText,
      createdAt: row.createdAt,
    );
  }

  final String id;
  final String programmeId;
  final String userId;
  final String tipText;
  final DateTime createdAt;
}
