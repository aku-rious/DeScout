// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/logging/talker_diagnostics_button.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/programmes/presentation/programmes_filter_button.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

final _programmeDetailPath = RegExp(r"^/programmes/[^/]+$");

/// Bottom navigation shell with a single shared AppBar.
class MainShellScaffold extends ConsumerWidget {
  const MainShellScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    final isProgrammeDetail = _programmeDetailPath.hasMatch(path);
    final tabIndex = navigationShell.currentIndex;

    final title = switch (tabIndex) {
      1 => "Saved",
      2 => "Settings",
      _ => "DeScout",
    };

    return Scaffold(
      appBar: isProgrammeDetail
          ? null
          : AppBar(
              title: Text(title),
              actions: [
                const TalkerDiagnosticsIconButton(),
                if (tabIndex == 0) const ProgrammesFilterButton(),
              ],
            ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: "Programmes",
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_outlined),
            selectedIcon: Icon(Icons.bookmark),
            label: "Saved",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

int shellBranchIndexForPath(String path) {
  if (path.startsWith(Routes.saved)) {
    return 1;
  }
  if (path.startsWith(Routes.settings)) {
    return 2;
  }
  return 0;
}
