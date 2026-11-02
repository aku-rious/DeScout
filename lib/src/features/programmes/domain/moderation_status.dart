// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Programme moderation state (`programmes.moderation_status`).
enum ModerationStatus {
  pending("pending"),
  adminVerified("admin_verified"),
  rejected("rejected");

  const ModerationStatus(this.dbValue);

  final String dbValue;

  static ModerationStatus fromDb(String value) {
    return values.firstWhere((e) => e.dbValue == value);
  }
}
