// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/logging/talker_provider.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:talker_flutter/talker_flutter.dart";

/// AppBar action that opens [TalkerScreen] in debug builds and for admins.
class TalkerDiagnosticsIconButton extends ConsumerWidget {
  const TalkerDiagnosticsIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider).valueOrNull ?? false;
    if (!talkerUiEnabled(isAdmin: isAdmin)) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.bug_report_outlined),
      tooltip: "Diagnostics",
      onPressed: () {
        rootNavigatorKey.currentState?.push(
          MaterialPageRoute<void>(
            builder: (_) => TalkerScreen(talker: ref.read(talkerProvider)),
          ),
        );
      },
    );
  }
}
