// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/moderation_status.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";

/// How much trust to signal for a programme listing in the UI.
enum TrustLevel {
  verified,
  community,
  source,
}

/// Classifies [programme] for trust badge display.
TrustLevel classifyTrust(Programme programme) {
  if (programme.moderationStatus == ModerationStatus.adminVerified) {
    return TrustLevel.verified;
  }
  const communitySources = {"custom_search", "community"};
  if (communitySources.contains(programme.source)) {
    return TrustLevel.community;
  }
  return TrustLevel.source;
}
