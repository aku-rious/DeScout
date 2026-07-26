// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";

/// User's application pipeline stage for a saved programme.
enum ApplicationStatus {
  interested,
  applied,
  accepted,
  rejected;

  static ApplicationStatus fromDb(ApplicationStatusDb value) {
    return ApplicationStatus.values.byName(value.name);
  }

  ApplicationStatusDb toDb() => ApplicationStatusDb.values.byName(name);

  String get label => switch (this) {
    ApplicationStatus.interested => "Interested",
    ApplicationStatus.applied => "Applied",
    ApplicationStatus.accepted => "Accepted",
    ApplicationStatus.rejected => "Rejected",
  };
}

/// Pipeline display order for the Saved screen.
const applicationStatusPipelineOrder = ApplicationStatus.values;
