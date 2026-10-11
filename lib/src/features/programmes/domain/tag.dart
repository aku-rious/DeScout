// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";

/// A controlled vocabulary tag for categorising programmes.
class Tag {
  const Tag({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Tag.fromRow(TagsRow row) {
    return Tag(id: row.id, name: row.name, slug: row.slug);
  }

  final String id;
  final String name;
  final String slug;
}
