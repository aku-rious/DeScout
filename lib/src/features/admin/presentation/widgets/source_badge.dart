// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:flutter/material.dart";

/// Colour-coded badge for programme [source] values.
class SourceBadge extends StatelessWidget {
  const SourceBadge({required this.source, super.key});

  final String source;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = _colorsForSource(source, scheme);

    return Chip(
      label: Text(
        _labelForSource(source),
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: colors.foreground),
      ),
      backgroundColor: colors.background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
  }

  static String _labelForSource(String source) {
    return switch (source) {
      "community" => "Community",
      "manual" => "Manual",
      "devpost_rss" => "Devpost",
      "dorahacks_api" => "DoraHacks",
      "custom_search" => "Discovery",
      _ => source.replaceAll("_", " "),
    };
  }

  static ({Color background, Color foreground}) _colorsForSource(
    String source,
    ColorScheme scheme,
  ) {
    return switch (source) {
      "community" => (
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
      ),
      "manual" => (
        background: scheme.surfaceContainerHighest,
        foreground: scheme.outline,
      ),
      "devpost_rss" => (
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
      ),
      "dorahacks_api" => (
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
      ),
      "custom_search" => (
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
      ),
      _ => (
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
      ),
    };
  }
}
