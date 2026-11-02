// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Removable chips for active browse filters.
class ActiveFilterChips extends ConsumerWidget {
  const ActiveFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filterProvider);
    if (!filters.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    final chips = <Widget>[
      if (filters.type != null)
        _DismissChip(
          label: _typeLabel(filters.type!),
          onDismiss: () => ref.read(filterProvider.notifier).setType(null),
        ),
      if (filters.remoteOnly)
        _DismissChip(
          label: "Remote",
          onDismiss: () => ref.read(filterProvider.notifier).toggleRemoteOnly(),
        ),
      if (filters.nigeriaEligibleOnly)
        _DismissChip(
          label: "🇳🇬 Nigeria",
          onDismiss: () =>
              ref.read(filterProvider.notifier).toggleNigeriaEligibleOnly(),
        ),
      if (filters.paidOnly)
        _DismissChip(
          label: "Paid",
          onDismiss: () => ref.read(filterProvider.notifier).togglePaidOnly(),
        ),
      if (filters.status != null)
        _DismissChip(
          label: filters.status!.name,
          onDismiss: () => ref.read(filterProvider.notifier).setStatus(null),
        ),
      if (filters.tagSlug != null)
        _DismissChip(
          label: "#${filters.tagSlug}",
          onDismiss: () => ref.read(filterProvider.notifier).clearTag(),
        ),
      if (filters.searchQuery.isNotEmpty)
        _DismissChip(
          label: "\"${filters.searchQuery}\"",
          onDismiss: () => ref.read(filterProvider.notifier).setSearchQuery(""),
        ),
      if (filters.verifiedOnly)
        _DismissChip(
          label: "Verified only",
          onDismiss: () =>
              ref.read(filterProvider.notifier).toggleVerifiedOnly(),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: chips),
    );
  }

  String _typeLabel(ProgrammeType type) {
    return switch (type) {
      ProgrammeType.hackathon => "Hackathon",
      ProgrammeType.fellowship => "Fellowship",
      ProgrammeType.programme => "Programme",
    };
  }
}

class _DismissChip extends StatelessWidget {
  const _DismissChip({required this.label, required this.onDismiss});

  final String label;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InputChip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDismiss,
        backgroundColor: scheme.primaryContainer,
        labelStyle: TextStyle(color: scheme.onPrimaryContainer),
      ),
    );
  }
}
