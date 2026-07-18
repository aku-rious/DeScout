// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/presentation/programme_card.dart";
import "package:de_scout/src/features/programmes/presentation/programmes_filter_sheet.dart";
import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programmes_provider.dart";
import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/widgets/async_error_view.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// Browse screen listing reviewed programmes from Supabase.
class ProgrammesListScreen extends ConsumerWidget {
  const ProgrammesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programmesAsync = ref.watch(programmesProvider);
    final filters = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("DeScout"),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: filters.hasActiveFilters,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: () => _openFilters(context),
          ),
        ],
      ),
      body: programmesAsync.when(
        data: (programmes) {
          if (programmes.isEmpty) {
            return const Center(
              child: Text("No programmes match your filters."),
            );
          }
          return ListView.separated(
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          fallback: ErrorMapper.programmesMessage,
        ),
      ),
    );
  }

  void _openFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ProgrammesFilterSheet(),
    );
  }
}
