// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/widgets/async_error_view.dart";
import "package:de_scout/src/features/programmes/presentation/programme_card.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programmes_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// Browse screen listing reviewed programmes from Supabase.
class ProgrammesListScreen extends ConsumerWidget {
  const ProgrammesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programmesAsync = ref.watch(programmesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(programmesProvider);
          await ref.read(programmesProvider.future);
        },
        child: programmesAsync.when(
          data: (programmes) {
            if (programmes.isEmpty) {
              return _scrollableBody(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No programmes found",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try adjusting your filters",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () =>
                            ref.read(filterProvider.notifier).clearAll(),
                        child: const Text("Clear filters"),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: programmes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final programme = programmes[index];
                return ProgrammeCard(
                  programme: programme,
                  onTap: () => context.push("/programmes/${programme.id}"),
                );
              },
            );
          },
          loading: () => _scrollableBody(
            context,
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => _scrollableBody(
            context,
            child: AsyncErrorView(
              error: error,
              fallback: ErrorMapper.programmesMessage,
            ),
          ),
        ),
      ),
    );
  }

  Widget _scrollableBody(BuildContext context, {required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [SizedBox(height: constraints.maxHeight, child: child)],
        );
      },
    );
  }
}
