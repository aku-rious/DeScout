// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/utils/trust_utils.dart";
import "package:de_scout/src/features/programmes/domain/moderation_status.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:flutter_test/flutter_test.dart";

Programme _programme({
  required ModerationStatus moderationStatus,
  required String source,
}) {
  return Programme(
    id: "p1",
    name: "Test",
    url: "https://example.com",
    type: ProgrammeType.hackathon,
    status: ProgrammeStatus.open,
    source: source,
    moderationStatus: moderationStatus,
  );
}

void main() {
  test("admin verified maps to verified trust", () {
    final level = classifyTrust(
      _programme(
        moderationStatus: ModerationStatus.adminVerified,
        source: "devpost_rss",
      ),
    );
    expect(level, TrustLevel.verified);
  });

  test("community source pending maps to community trust", () {
    final level = classifyTrust(
      _programme(
        moderationStatus: ModerationStatus.pending,
        source: "community",
      ),
    );
    expect(level, TrustLevel.community);
  });

  test("ingestion source pending maps to source trust", () {
    final level = classifyTrust(
      _programme(
        moderationStatus: ModerationStatus.pending,
        source: "devpost_rss",
      ),
    );
    expect(level, TrustLevel.source);
  });
}
