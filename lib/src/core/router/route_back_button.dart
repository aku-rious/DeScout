// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/router/routes.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// Back control for root-level routes pushed outside the shell (submit, admin).
class RouteBackButton extends StatelessWidget {
  const RouteBackButton({this.fallback = Routes.programmes, super.key});

  final String fallback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(fallback);
        }
      },
    );
  }
}

/// AppBar with [RouteBackButton] for pushed routes outside the shell.
class RoutedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RoutedAppBar({required this.title, this.bottom, super.key});

  final String title;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const RouteBackButton(),
      title: Text(title),
      bottom: bottom,
    );
  }
}
