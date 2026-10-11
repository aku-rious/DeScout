// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:flutter/material.dart";

/// Remote, Nigeria eligibility, and experience level chips.
class EligibilityBadgesRow extends StatelessWidget {
  const EligibilityBadgesRow({
    required this.remote,
    required this.nigeriaEligible,
    super.key,
  });

  final bool? remote;
  final bool? nigeriaEligible;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _remoteChip(context, scheme),
        _nigeriaChip(context, scheme),
        Chip(
          avatar: Icon(Icons.groups_outlined, size: 18, color: scheme.outline),
          label: const Text("All levels"),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ],
    );
  }

  Widget _remoteChip(BuildContext context, ColorScheme scheme) {
    if (remote == true) {
      return Chip(
        avatar: Icon(Icons.public, size: 18, color: scheme.primary),
        label: const Text("Remote"),
      );
    }
    return Chip(
      avatar: Icon(Icons.public, size: 18, color: scheme.outline),
      label: const Text("Remote TBA"),
      side: BorderSide(color: scheme.outlineVariant),
    );
  }

  Widget _nigeriaChip(BuildContext context, ColorScheme scheme) {
    return switch (nigeriaEligible) {
      true => Chip(
        avatar: Icon(Icons.check_circle, size: 18, color: scheme.primary),
        label: const Text("Nigeria eligible"),
        backgroundColor: scheme.primaryContainer,
      ),
      false => Chip(
        avatar: Icon(Icons.cancel, size: 18, color: scheme.error),
        label: const Text("Not Nigeria eligible"),
        backgroundColor: scheme.errorContainer,
      ),
      null => Chip(
        avatar: Icon(Icons.help_outline, size: 18, color: scheme.outline),
        label: const Text("Eligibility TBA"),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    };
  }
}
