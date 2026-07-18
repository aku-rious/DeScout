// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";

/// A reviewed hackathon, fellowship, or programme listing.
class Programme {
  const Programme({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    this.description,
    this.stipendUsd,
    this.stipendNgnApprox,
    this.remote,
    this.nigeriaEligible,
    this.opensAt,
    this.closesAt,
    required this.status,
    required this.source,
  });

  factory Programme.fromRow(ProgrammesRow row) {
    return Programme(
      id: row.id,
      name: row.name,
      url: row.url,
      type: ProgrammeType.values.byName(row.type.name),
      description: row.description,
      stipendUsd: row.stipendUsd,
      stipendNgnApprox: row.stipendNgnApprox,
      remote: row.remote,
      nigeriaEligible: row.nigeriaEligible,
      opensAt: row.opensAt,
      closesAt: row.closesAt,
      status: ProgrammeStatus.values.byName(row.status.name),
      source: row.source,
    );
  }

  final String id;
  final String name;
  final String url;
  final ProgrammeType type;
  final String? description;
  final double? stipendUsd;
  final double? stipendNgnApprox;
  final bool? remote;
  final bool? nigeriaEligible;
  final DateTime? opensAt;
  final DateTime? closesAt;
  final ProgrammeStatus status;
  final String source;
}
