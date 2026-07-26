// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";

/// A user's bookmarked programme with personal tracking fields.
class SavedProgramme {
  const SavedProgramme({
    required this.id,
    required this.userId,
    required this.programmeId,
    this.programme,
    required this.applicationStatus,
    this.notes,
    required this.createdAt,
  });

  factory SavedProgramme.fromRow(SavedProgrammesRow row) {
    return SavedProgramme(
      id: row.id,
      userId: row.userId,
      programmeId: row.programmeId,
      programme: row.programme == null
          ? null
          : Programme.fromRow(row.programme!),
      applicationStatus: ApplicationStatus.fromDb(row.applicationStatus),
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }

  final String id;
  final String userId;
  final String programmeId;
  final Programme? programme;
  final ApplicationStatus applicationStatus;
  final String? notes;
  final DateTime createdAt;

  bool get isAvailable => programme != null;
}
