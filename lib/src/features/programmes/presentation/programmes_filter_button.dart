// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/presentation/programmes_filter_sheet.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Shell AppBar action — opens the programmes filter bottom sheet.
class ProgrammesFilterButton extends ConsumerWidget {
  const ProgrammesFilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filterProvider);

    return IconButton(
      icon: Badge(
        isLabelVisible: filters.hasActiveFilters,
        child: const Icon(Icons.filter_list),
      ),
      tooltip: "Filter programmes",
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => const ProgrammesFilterSheet(),
        );
      },
    );
  }
}
