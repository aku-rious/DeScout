// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Admin curation queue tab (maps to `moderation_status` filter).
enum CurationQueueStatus {
  pending("pending"),
  rejected("rejected");

  const CurationQueueStatus(this.apiValue);

  final String apiValue;
}
