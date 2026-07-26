// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/widgets/async_error_view.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";
import "package:de_scout/src/features/saved/domain/saved_programme.dart";
import "package:de_scout/src/features/saved/presentation/providers/saved_provider.dart";
import "package:de_scout/src/features/saved/presentation/widgets/saved_programme_card.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// Saved programmes grouped by application pipeline stage.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedProgrammesProvider);

    return Scaffold(
      body: savedAsync.when(
        data: (saved) {
          if (saved.isEmpty) {
            return const _EmptySavedState();
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final status in applicationStatusPipelineOrder) ...[
                _SavedSection(
                  status: status,
                  items: _itemsForStatus(saved, status),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            AsyncErrorView(error: error, fallback: ErrorMapper.savedMessage),
      ),
    );
  }

  List<SavedProgramme> _itemsForStatus(
    List<SavedProgramme> saved,
    ApplicationStatus status,
  ) {
    final items = saved.where((item) => item.applicationStatus == status);
    return items.toList()..sort((a, b) {
      final aCloses = a.programme?.closesAt;
      final bCloses = b.programme?.closesAt;
      if (aCloses == null && bCloses == null) {
        return b.createdAt.compareTo(a.createdAt);
      }
      if (aCloses == null) {
        return 1;
      }
      if (bCloses == null) {
        return -1;
      }
      return aCloses.compareTo(bCloses);
    });
  }
}

class _SavedSection extends ConsumerWidget {
  const _SavedSection({required this.status, required this.items});

  final ApplicationStatus status;
  final List<SavedProgramme> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(savedSectionTitle(status), style: textTheme.titleSmall),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Text(
            "None yet",
            style: textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                onDismissed: (_) => _unsaveWithUndo(context, ref, item),
                child: SavedProgrammeCard(
                  saved: item,
                  onTap: item.isAvailable
                      ? () => context.push("/programmes/${item.programmeId}")
                      : () => _showUnavailableMessage(context),
                ),
              ),
            ),
      ],
    );
  }

  void _showUnavailableMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This programme is temporarily unavailable."),
      ),
    );
  }

  Future<void> _unsaveWithUndo(
    BuildContext context,
    WidgetRef ref,
    SavedProgramme item,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(savedControllerProvider.notifier).unsave(item.programmeId);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: const Text("Programme removed"),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            ref
                .read(savedControllerProvider.notifier)
                .restoreSave(item.programmeId);
          },
        ),
      ),
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_outlined,
              size: 48,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              "No saved programmes yet",
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Bookmark programmes from the browse list to track them here.",
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
