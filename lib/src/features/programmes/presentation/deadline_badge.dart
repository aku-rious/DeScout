// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/utils/deadline_utils.dart";
import "package:flutter/material.dart";

/// Countdown chip coloured by deadline urgency.
class DeadlineBadge extends StatelessWidget {
  const DeadlineBadge({
    required this.closesAt,
    this.nullLabel = "No deadline",
    super.key,
  });

  final DateTime? closesAt;
  final String nullLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = classifyDeadline(closesAt);
    final colors = deadlineBadgeColors(state, scheme);

    return Chip(
      label: Text(
        closesAt == null ? nullLabel : formatDeadlineLabel(closesAt),
        style: textTheme.labelLarge?.copyWith(color: colors.foreground),
      ),
      backgroundColor: colors.background,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
