// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/router/route_back_button.dart";
import "package:de_scout/src/core/widgets/async_error_view.dart";
import "package:de_scout/src/features/admin/domain/curation_queue_status.dart";
import "package:de_scout/src/features/admin/presentation/providers/review_queue_action_lock_provider.dart";
import "package:de_scout/src/features/admin/presentation/providers/review_queue_provider.dart";
import "package:de_scout/src/features/admin/presentation/widgets/exchange_rate_admin_section.dart";
import "package:de_scout/src/features/admin/presentation/widgets/programme_edit_sheet.dart";
import "package:de_scout/src/features/admin/presentation/widgets/source_badge.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:url_launcher/url_launcher.dart";

/// Admin curation: pending/rejected programmes and exchange rate.
class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const RoutedAppBar(
          title: "Curation",
          bottom: TabBar(
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Rejected"),
              Tab(text: "Exchange rate"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CurationTab(status: CurationQueueStatus.pending),
            _CurationTab(status: CurationQueueStatus.rejected),
            ExchangeRateAdminSection(),
          ],
        ),
      ),
    );
  }
}

class _CurationTab extends ConsumerWidget {
  const _CurationTab({required this.status});

  final CurationQueueStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(curationQueueProvider(status));

    return RefreshIndicator(
      onRefresh: () => ref.read(curationQueueProvider(status).notifier).refresh(),
      child: queueAsync.when(
        data: (programmes) {
          if (programmes.isEmpty) {
            return _scrollableBody(
              context,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    status == CurationQueueStatus.pending
                        ? "No pending programmes"
                        : "No rejected programmes",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final helper = status == CurationQueueStatus.pending
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    "Pending listings are already visible in the app until you verify or reject them.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : null;

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: programmes.length + (helper == null ? 0 : 1),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (helper != null && index == 0) {
                return helper;
              }
              final programmeIndex = helper == null ? index : index - 1;
              final programme = programmes[programmeIndex];
              return _CurationCard(
                key: ValueKey(programme.id),
                programme: programme,
                status: status,
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
            fallback: ErrorMapper.adminMessage,
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

class _CurationCard extends ConsumerWidget {
  const _CurationCard({
    required this.programme,
    required this.status,
    super.key,
  });

  final Programme programme;
  final CurationQueueStatus status;

  Future<void> _openUrl() async {
    final uri = Uri.tryParse(programme.url);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final activeId = ref.watch(reviewQueueActionLockProvider);
    final locked = activeId != null;
    final isThisCard = activeId == programme.id;
    final notifier = ref.read(curationQueueProvider(status).notifier);

    Future<void> runAction(Future<void> Function() action) async {
      if (locked) {
        return;
      }
      try {
        await action();
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ErrorMapper.userMessage(error))),
          );
        }
      }
    }

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(programme.name, style: textTheme.titleMedium),
                ),
                SourceBadge(source: programme.source),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: locked ? null : _openUrl,
              child: Text(
                programme.url,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _NigeriaEligibleIcon(value: programme.nigeriaEligible),
                const SizedBox(width: 8),
                DeadlineBadge(closesAt: programme.closesAt),
              ],
            ),
            const SizedBox(height: 16),
            if (status == CurationQueueStatus.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: locked
                          ? null
                          : () => runAction(
                              () => notifier.verify(programme.id),
                            ),
                      child: isThisCard
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Verify"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: locked
                          ? null
                          : () async {
                              await ProgrammeEditSheet.show(
                                context: context,
                                programme: programme,
                                onSubmit: (fields, tagSlugs) => runAction(
                                  () => notifier.editAndVerify(
                                    programme.id,
                                    fields,
                                    tagSlugs: tagSlugs,
                                  ),
                                ),
                              );
                            },
                      child: const Text("Edit then Verify"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: locked
                      ? null
                      : () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Reject submission?"),
                              content: Text(
                                "\"${programme.name}\" will be hidden from the public list but kept as a URL tombstone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Reject"),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true && context.mounted) {
                            await runAction(
                              () => notifier.reject(programme.id),
                            );
                          }
                        },
                  style: TextButton.styleFrom(foregroundColor: scheme.error),
                  child: const Text("Reject"),
                ),
              ),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: locked
                      ? null
                      : () => runAction(() => notifier.restore(programme.id)),
                  child: isThisCard
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Restore"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NigeriaEligibleIcon extends StatelessWidget {
  const _NigeriaEligibleIcon({required this.value});

  final bool? value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = switch (value) {
      true => Icon(Icons.check_circle_outline, color: scheme.primary, size: 20),
      false => Icon(Icons.cancel_outlined, color: scheme.error, size: 20),
      null => Icon(Icons.help_outline, color: scheme.outline, size: 20),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 4),
        Text(
          "Nigeria eligible",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
