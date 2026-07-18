// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/programme_status.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Bottom sheet for toggling programme list filters.
class ProgrammesFilterSheet extends ConsumerWidget {
  const ProgrammesFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Filters", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text("Type", style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ProgrammeType.values.map((type) {
              return FilterChip(
                label: Text(type.name),
                selected: filters.type == type,
                onSelected: (_) =>
                    notifier.setType(filters.type == type ? null : type),
                side: BorderSide.none,
                selectedColor: scheme.primaryContainer,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          FilterChip(
            label: const Text("Remote only"),
            selected: filters.remoteOnly,
            onSelected: (_) => notifier.toggleRemoteOnly(),
            side: BorderSide.none,
            selectedColor: scheme.primaryContainer,
          ),
          FilterChip(
            label: const Text("Nigeria eligible"),
            selected: filters.nigeriaEligibleOnly,
            onSelected: (_) => notifier.toggleNigeriaEligibleOnly(),
            side: BorderSide.none,
            selectedColor: scheme.primaryContainer,
          ),
          FilterChip(
            label: const Text("Paid (stipend known)"),
            selected: filters.paidOnly,
            onSelected: (_) => notifier.togglePaidOnly(),
            side: BorderSide.none,
            selectedColor: scheme.primaryContainer,
          ),
          const SizedBox(height: 8),
          Text("Status", style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ProgrammeStatus.values.map((status) {
              return FilterChip(
                label: Text(status.name),
                selected: filters.status == status,
                onSelected: (_) => notifier.setStatus(
                  filters.status == status ? null : status,
                ),
                side: BorderSide.none,
                selectedColor: scheme.primaryContainer,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: filters.hasActiveFilters ? notifier.clearAll : null,
                child: const Text("Clear all"),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
