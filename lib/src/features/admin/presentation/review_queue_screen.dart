// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/router/route_back_button.dart";
import "package:de_scout/src/core/widgets/async_error_view.dart";
import "package:de_scout/src/features/admin/presentation/providers/review_queue_provider.dart";
import "package:de_scout/src/features/admin/presentation/widgets/exchange_rate_admin_section.dart";
import "package:de_scout/src/features/admin/presentation/widgets/programme_edit_sheet.dart";
import "package:de_scout/src/features/admin/presentation/widgets/source_badge.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:url_launcher/url_launcher.dart";

/// Admin screen listing unreviewed programmes and exchange rate settings.
class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const RoutedAppBar(
          title: "Admin",
          bottom: TabBar(
            tabs: [
              Tab(text: "Review queue"),
              Tab(text: "Exchange rate"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ReviewQueueTab(),
            ExchangeRateAdminSection(),
          ],
        ),
      ),
    );
  }
}

class _ReviewQueueTab extends ConsumerWidget {
  const _ReviewQueueTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(reviewQueueProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(reviewQueueProvider.notifier).refresh(),
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
                    "Review queue is clear",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: programmes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _ReviewQueueCard(programme: programmes[index]);
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

class _ReviewQueueCard extends ConsumerStatefulWidget {
  const _ReviewQueueCard({required this.programme});

  final Programme programme;

  @override
  ConsumerState<_ReviewQueueCard> createState() => _ReviewQueueCardState();
}

class _ReviewQueueCardState extends ConsumerState<_ReviewQueueCard> {
  bool _isPending = false;

  Programme get programme => widget.programme;

  Future<void> _runAction(Future<void> Function() action) async {
    if (_isPending) {
      return;
    }
    setState(() => _isPending = true);
    try {
      await action();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMapper.userMessage(error))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPending = false);
      }
    }
  }

  Future<void> _openUrl() async {
    final uri = Uri.tryParse(programme.url);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _confirmReject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reject submission?"),
        content: Text("This will permanently delete \"${programme.name}\"."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Reject"),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await _runAction(
      () => ref.read(reviewQueueProvider.notifier).reject(programme.id),
    );
  }

  Future<void> _approve() async {
    await _runAction(
      () => ref.read(reviewQueueProvider.notifier).approve(programme.id),
    );
  }

  Future<void> _editAndApprove() async {
    if (_isPending) {
      return;
    }
    await ProgrammeEditSheet.show(
      context: context,
      programme: programme,
      onSubmit: (fields) => _runAction(
        () => ref
            .read(reviewQueueProvider.notifier)
            .editAndApprove(programme.id, fields),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              onTap: _openUrl,
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
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _isPending ? null : _approve,
                    child: _isPending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Approve"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isPending ? null : _editAndApprove,
                    child: const Text("Edit then Approve"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isPending ? null : _confirmReject,
                style: TextButton.styleFrom(foregroundColor: scheme.error),
                child: const Text("Reject"),
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
