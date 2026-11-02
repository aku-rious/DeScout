// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/utils/trust_utils.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:flutter/material.dart";

/// Trust indicator for list cards and programme detail.
class TrustBadge extends StatelessWidget {
  const TrustBadge({required this.programme, super.key});

  final Programme programme;

  @override
  Widget build(BuildContext context) {
    final level = classifyTrust(programme);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    switch (level) {
      case TrustLevel.source:
        return const SizedBox.shrink();
      case TrustLevel.verified:
        return Chip(
          avatar: Icon(
            Icons.verified_outlined,
            size: 18,
            color: scheme.onPrimaryContainer,
          ),
          label: Text("Verified", style: textTheme.labelSmall),
          backgroundColor: scheme.primaryContainer,
          side: BorderSide.none,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      case TrustLevel.community:
        return Chip(
          avatar: Icon(
            Icons.groups_outlined,
            size: 18,
            color: scheme.onSurfaceVariant,
          ),
          label: Text(
            "Community-sourced · unverified",
            style: textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          backgroundColor: scheme.surfaceContainerHighest,
          side: BorderSide(color: scheme.outline),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
    }
  }
}
