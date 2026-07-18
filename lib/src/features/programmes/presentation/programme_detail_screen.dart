// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/widgets/async_error_view.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programmes_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:url_launcher/url_launcher.dart";

/// Detail view for a single programme.
class ProgrammeDetailScreen extends ConsumerWidget {
  const ProgrammeDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programmeAsync = ref.watch(programmeDetailProvider(id));
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: programmeAsync.when(
        data: (programme) {
          if (programme == null) {
            return const Center(child: Text("Programme not found."));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 180,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(programme.name),
                  background: ColoredBox(color: scheme.primaryContainer),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DeadlineBadge(closesAt: programme.closesAt),
                    const SizedBox(height: 16),
                    if (programme.description != null)
                      Text(programme.description!, style: textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Text(
                      [
                        programme.type.name,
                        if (programme.remote == true) "Remote",
                        if (programme.nigeriaEligible == true) "NG eligible",
                        if (programme.stipendUsd != null)
                          "\$${programme.stipendUsd!.toStringAsFixed(0)} stipend",
                      ].join(" · "),
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _openUrl(programme.url),
                      child: const Text("Visit programme"),
                    ),
                  ]),
                ),
              ),
            ],
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

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
