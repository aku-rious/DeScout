// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:de_scout/src/features/saved/presentation/providers/saved_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// Bookmark toggle for programme list and detail screens.
class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({required this.programmeId, super.key});

  final String programmeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(isSavedProvider(programmeId));
    final isLoggedIn = ref.watch(authStateProvider).value?.session != null;

    ref.listen(savedControllerProvider, (previous, next) {
      if (previous?.isLoading != true || next.isLoading) {
        return;
      }
      if (next.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMapper.userMessage(next.error))),
        );
      }
    });

    return IconButton(
      icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
      tooltip: isSaved ? "Remove bookmark" : "Save programme",
      onPressed: () => _onPressed(context, ref, isLoggedIn),
    );
  }

  void _onPressed(BuildContext context, WidgetRef ref, bool isLoggedIn) {
    if (!isLoggedIn) {
      final from = Uri.encodeComponent(
        GoRouterState.of(context).uri.toString(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Sign in to save programmes"),
          action: SnackBarAction(
            label: "Sign in",
            onPressed: () => context.push("${Routes.login}?from=$from"),
          ),
        ),
      );
      return;
    }

    ref.read(savedControllerProvider.notifier).toggleSave(programmeId);
  }
}
