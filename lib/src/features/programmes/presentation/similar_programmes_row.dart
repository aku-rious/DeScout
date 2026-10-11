// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// Compact programme card for horizontal similar-programmes row.
class SimilarProgrammeCard extends StatelessWidget {
  const SimilarProgrammeCard({required this.programme, super.key});

  final Programme programme;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 130,
      child: Card(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        child: InkWell(
          onTap: () => context.push("/programmes/${programme.id}"),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  programme.name,
                  style: textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                DeadlineBadge(closesAt: programme.closesAt),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal list of similar programmes sharing tags.
class SimilarProgrammesRow extends StatelessWidget {
  const SimilarProgrammesRow({required this.programmes, super.key});

  final List<Programme> programmes;

  @override
  Widget build(BuildContext context) {
    if (programmes.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Similar programmes", style: textTheme.titleSmall),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: programmes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return SimilarProgrammeCard(programme: programmes[index]);
            },
          ),
        ),
      ],
    );
  }
}
