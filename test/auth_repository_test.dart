// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/table_names.dart";
import "package:flutter_test/flutter_test.dart";

bool isAdminFromUsersRow(Map<String, dynamic>? row) {
  if (row == null) {
    return false;
  }
  return row[Cols.isAdmin] as bool? ?? false;
}

void main() {
  group("isAdminFromUsersRow", () {
    test("returns true when is_admin is true", () {
      expect(isAdminFromUsersRow({Cols.isAdmin: true}), isTrue);
    });

    test("returns false when row is null", () {
      expect(isAdminFromUsersRow(null), isFalse);
    });

    test("returns false when is_admin is missing", () {
      expect(isAdminFromUsersRow({}), isFalse);
    });
  });
}
