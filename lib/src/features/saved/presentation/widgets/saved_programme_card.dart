// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";
import "package:de_scout/src/features/saved/domain/saved_programme.dart";
import "package:flutter/material.dart";

/// Card for a saved programme in the Saved tab.
class SavedProgrammeCard extends StatelessWidget {
  const SavedProgrammeCard({
    required this.saved,
    required this.onTap,
    super.key,
  });

  final SavedProgramme saved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!saved.isAvailable) {
      return UnavailableSavedCard(saved: saved);
    }

    final programme = saved.programme!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(programme.name, style: textTheme.titleMedium),
                  ),
                  DeadlineBadge(closesAt: programme.closesAt),
                ],
              ),
              if (saved.notes != null && saved.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  saved.notes!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder when the joined programme is unavailable (unreviewed or removed).
class UnavailableSavedCard extends StatelessWidget {
  const UnavailableSavedCard({required this.saved, super.key});

  final SavedProgramme saved;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Programme unavailable",
              style: textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              saved.applicationStatus.label,
              style: textTheme.labelMedium?.copyWith(color: scheme.primary),
            ),
            if (saved.notes != null && saved.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                saved.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String savedSectionTitle(ApplicationStatus status) => status.label;
