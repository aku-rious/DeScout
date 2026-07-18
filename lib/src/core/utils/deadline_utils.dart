// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:flutter/material.dart";

/// Deadline urgency bucket for programme closes_at proximity.
enum DeadlineState { closed, urgent, soon, open, unknown }

/// Classifies [closesAt] into a [DeadlineState] relative to now.
DeadlineState classifyDeadline(DateTime? closesAt) {
  if (closesAt == null) {
    return DeadlineState.unknown;
  }
  final days = closesAt.difference(DateTime.now()).inDays;
  if (days < 0) {
    return DeadlineState.closed;
  }
  if (days <= 3) {
    return DeadlineState.urgent;
  }
  if (days <= 7) {
    return DeadlineState.soon;
  }
  return DeadlineState.open;
}

/// M3 container/foreground pair for deadline urgency badges.
({Color background, Color foreground}) deadlineBadgeColors(
  DeadlineState state,
  ColorScheme scheme,
) {
  return switch (state) {
    DeadlineState.urgent => (
      background: scheme.errorContainer,
      foreground: scheme.onErrorContainer,
    ),
    DeadlineState.soon => (
      background: scheme.tertiaryContainer,
      foreground: scheme.onTertiaryContainer,
    ),
    DeadlineState.open => (
      background: scheme.primaryContainer,
      foreground: scheme.onPrimaryContainer,
    ),
    DeadlineState.closed => (
      background: scheme.surfaceContainerHighest,
      foreground: scheme.outline,
    ),
    DeadlineState.unknown => (
      background: scheme.surfaceContainerHighest,
      foreground: scheme.outline,
    ),
  };
}

/// Human-readable countdown label for [closesAt].
String formatDeadlineLabel(DateTime? closesAt) {
  if (closesAt == null) {
    return "No deadline";
  }
  final days = closesAt.difference(DateTime.now()).inDays;
  if (days < 0) {
    return "Closed";
  }
  if (days == 0) {
    return "Closes today";
  }
  if (days == 1) {
    return "1 day left";
  }
  return "$days days left";
}
