// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:flutter/material.dart";

/// Route path constants for go_router.
abstract final class Routes {
  static const programmes = "/programmes";
  static const programmeDetail = "/programmes/:id";
  static const login = "/auth/login";
  static const register = "/auth/register";
  static const saved = "/saved";
  static const settings = "/settings";
  static const adminReview = "/admin/review";
  static const submit = "/submit";
}

/// Root navigator for go_router — used for overlay-safe diagnostics UI.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
