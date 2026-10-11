// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/programmes/domain/tag.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// Skills and topics tags; tap navigates to filtered browse.
class ProgrammeTagsSection extends ConsumerWidget {
  const ProgrammeTagsSection({required this.tags, super.key});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Skills & topics", style: textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final tag in tags)
              FilterChip(
                label: Text(tag.name),
                selected: false,
                onSelected: (_) {
                  ref.read(filterProvider.notifier).setTagSlug(tag.slug);
                  context.go(Routes.programmes);
                },
              ),
          ],
        ),
      ],
    );
  }
}
