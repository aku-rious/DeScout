// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/programme_type.dart";

/// User-provided fields for a community programme submission.
class SubmitProgrammeInput {
  const SubmitProgrammeInput({
    required this.name,
    required this.url,
    required this.type,
    this.stipendUsd,
    this.remote,
    this.nigeriaEligible,
    this.opensAt,
    this.closesAt,
    this.description,
  });

  final String name;
  final String url;
  final ProgrammeType type;
  final double? stipendUsd;
  final bool? remote;
  final bool? nigeriaEligible;
  final DateTime? opensAt;
  final DateTime? closesAt;
  final String? description;
}
