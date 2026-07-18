// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:flutter/material.dart";
import "package:talker_flutter/talker_flutter.dart";

/// Optional FAB that opens [TalkerScreen] for dev builds and admins.
class TalkerDiagnosticsHost extends StatelessWidget {
  const TalkerDiagnosticsHost({
    required this.talker,
    required this.enabled,
    required this.child,
    super.key,
  });

  final Talker talker;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.small(
            heroTag: "talker_diagnostics",
            tooltip: "Diagnostics",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TalkerScreen(talker: talker),
                ),
              );
            },
            child: const Icon(Icons.bug_report_outlined),
          ),
        ),
      ],
    );
  }
}
