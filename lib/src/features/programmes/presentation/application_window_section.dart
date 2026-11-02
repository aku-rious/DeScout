// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/utils/deadline_utils.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

/// Application window progress between opens_at and closes_at.
class ApplicationWindowSection extends StatelessWidget {
  const ApplicationWindowSection({
    required this.opensAt,
    required this.closesAt,
    super.key,
  });

  final DateTime opensAt;
  final DateTime closesAt;

  static final _dateFormat = DateFormat("MMM d, yyyy");

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = classifyDeadline(closesAt);
    final colors = deadlineBadgeColors(state, scheme);
    final now = DateTime.now();
    final total = closesAt.difference(opensAt).inMilliseconds;
    final elapsed = now.difference(opensAt).inMilliseconds;
    final progress = total <= 0
        ? 1.0
        : (elapsed / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Application window", style: textTheme.titleSmall),
            DeadlineBadge(closesAt: closesAt),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: scheme.surfaceContainerHighest,
            color: colors.background,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Opens",
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.outline,
                  ),
                ),
                Text(_dateFormat.format(opensAt), style: textTheme.bodySmall),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Closes",
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.outline,
                  ),
                ),
                Text(_dateFormat.format(closesAt), style: textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Closes-only deadline row when opens_at is absent.
class ClosesOnlySection extends StatelessWidget {
  const ClosesOnlySection({required this.closesAt, super.key});

  final DateTime closesAt;

  static final _dateFormat = DateFormat("MMM d, yyyy");

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Closes ${_dateFormat.format(closesAt)}",
          style: textTheme.titleSmall,
        ),
        DeadlineBadge(closesAt: closesAt),
      ],
    );
  }
}
