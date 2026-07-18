// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/utils/deadline_utils.dart";
import "package:de_scout/theme.dart";
import "package:flutter/material.dart";

/// Light [ThemeData] for DeScout using the Material Theme Builder palette.
// ignore: non_constant_identifier_names
ThemeData DeScoutLightTheme(TextTheme textTheme) {
  return MaterialTheme(textTheme).light();
}

/// Dark [ThemeData] for DeScout using the Material Theme Builder palette.
// ignore: non_constant_identifier_names
ThemeData DeScoutDarkTheme(TextTheme textTheme) {
  return MaterialTheme(textTheme).dark();
}

/// Foreground colour for deadline urgency badges.
Color deadlineColour(DateTime? closesAt, ColorScheme scheme) {
  return switch (classifyDeadline(closesAt)) {
    DeadlineState.closed || DeadlineState.unknown => scheme.onSurfaceVariant,
    DeadlineState.urgent => scheme.error,
    DeadlineState.soon => scheme.tertiary,
    DeadlineState.open => scheme.primary,
  };
}
