// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:de_scout/src/features/programmes/domain/programme_tip.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programme_tips_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// Community tips list and add-tip bottom sheet.
class CommunityTipsSection extends ConsumerWidget {
  const CommunityTipsSection({required this.programmeId, super.key});

  final String programmeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsAsync = ref.watch(programmeTipsProvider(programmeId));
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Community tips", style: textTheme.titleSmall),
            TextButton(
              onPressed: () => _showAddTipSheet(context, ref),
              child: const Text("Add tip"),
            ),
          ],
        ),
        tipsAsync.when(
          data: (tips) {
            if (tips.isEmpty) {
              return Text(
                "Be the first to share a tip for this programme",
                style: textTheme.bodySmall?.copyWith(color: scheme.outline),
              );
            }
            return Column(
              children: [
                for (var i = 0; i < tips.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TipCard(tip: tips[i], index: i),
                  ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          ),
          error: (error, _) => Text(
            ErrorMapper.userMessage(error),
            style: textTheme.bodySmall?.copyWith(color: scheme.error),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddTipSheet(BuildContext context, WidgetRef ref) async {
    final session = ref.read(authStateProvider).value?.session;
    if (session == null) {
      context.push(Routes.login);
      return;
    }

    final controller = TextEditingController();
    if (!context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                maxLength: 280,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                      "Share a tip for applicants — what worked for you?",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(programmeTipsProvider(programmeId).notifier)
                        .addTip(controller.text);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ErrorMapper.userMessage(error))),
                      );
                    }
                  }
                },
                child: const Text("Post tip"),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, required this.index});

  final ProgrammeTip tip;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final borderColor = index.isEven ? scheme.primary : scheme.secondary;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: borderColor, width: 3)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tip.tipText, style: textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              "— Member, ${tip.createdAt.year}",
              style: textTheme.labelSmall?.copyWith(color: scheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
