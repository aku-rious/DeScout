// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/programmes/domain/filter_state.dart";
import "package:de_scout/src/features/programmes/domain/moderation_status.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Applies public moderation visibility to a programmes PostgREST query.
PostgrestFilterBuilder<PostgrestList> applyModerationFilter(
  PostgrestFilterBuilder<PostgrestList> query,
  FilterState filters,
) {
  if (filters.verifiedOnly) {
    return query.eq(
      Cols.moderationStatus,
      ModerationStatus.adminVerified.dbValue,
    );
  }
  return query.neq(Cols.moderationStatus, ModerationStatus.rejected.dbValue);
}
