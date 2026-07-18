// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Supabase table name constants for query builders.
abstract final class Tables {
  static const programmes = "programmes";
  static const tags = "tags";
  static const programmeTags = "programme_tags";
  static const users = "users";
  static const savedProgrammes = "saved_programmes";
}

/// Supabase column name constants for query builders.
abstract final class Cols {
  static const id = "id";
  static const type = "type";
  static const reviewed = "reviewed";
  static const closesAt = "closes_at";
  static const nigeriaEligible = "nigeria_eligible";
  static const isAdmin = "is_admin";
  static const status = "status";
  static const userId = "user_id";
  static const programmeId = "programme_id";
}
