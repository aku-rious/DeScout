// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:flutter/material.dart";

/// Card showing a programme summary on the browse list.
class ProgrammeCard extends StatelessWidget {
  const ProgrammeCard({
    required this.programme,
    required this.onTap,
    super.key,
  });

  final Programme programme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final stipend = programme.stipendUsd;

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
              const SizedBox(height: 8),
              Text(
                _subtitle(programme, stipend),
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(Programme programme, double? stipend) {
    final parts = <String>[
      programme.type.name,
      if (programme.remote == true) "Remote",
      if (programme.nigeriaEligible == true) "NG eligible",
      if (stipend != null) "\$${stipend.toStringAsFixed(0)} stipend",
    ];
    return parts.join(" · ");
  }
}
