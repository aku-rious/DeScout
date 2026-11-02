// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/database_types.dart";
import "package:de_scout/src/core/supabase/supabase_client.dart";
import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/programmes/domain/tag.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "tags_provider.g.dart";

@riverpod
Future<List<Tag>> allTags(AllTagsRef ref) async {
  final client = ref.watch(supabaseClientProvider);
  final response = await client.from(Tables.tags).select().order(Cols.name);
  return (response as List)
      .cast<Map<String, dynamic>>()
      .map((row) => Tag.fromRow(TagsRow.fromJson(row)))
      .toList();
}
