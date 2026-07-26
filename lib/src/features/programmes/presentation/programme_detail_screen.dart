// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "dart:async";

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/widgets/async_error_view.dart";
import "package:de_scout/src/features/programmes/presentation/deadline_badge.dart";
import "package:de_scout/src/features/programmes/presentation/providers/programmes_provider.dart";
import "package:de_scout/src/features/saved/domain/application_status.dart";
import "package:de_scout/src/features/saved/presentation/providers/saved_provider.dart";
import "package:de_scout/src/features/saved/presentation/widgets/bookmark_button.dart";
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
                actions: [BookmarkButton(programmeId: id)],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(programme.name),
                  background: ColoredBox(color: scheme.primaryContainer),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DeadlineBadge(
                      closesAt: programme.closesAt,
                      nullLabel: "Deadline TBA",
                    ),
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
                    _SavedProgrammeControls(programmeId: id),
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

class _SavedProgrammeControls extends ConsumerStatefulWidget {
  const _SavedProgrammeControls({required this.programmeId});

  final String programmeId;

  @override
  ConsumerState<_SavedProgrammeControls> createState() =>
      _SavedProgrammeControlsState();
}

class _SavedProgrammeControlsState
    extends ConsumerState<_SavedProgrammeControls> {
  final _notesController = TextEditingController();
  Timer? _debounce;
  String? _lastSavedNotes;

  @override
  void dispose() {
    _debounce?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSaved = ref.watch(isSavedProvider(widget.programmeId));
    if (!isSaved) {
      return const SizedBox.shrink();
    }

    final saved = ref.watch(savedProgrammeByIdProvider(widget.programmeId));
    final status = saved?.applicationStatus ?? ApplicationStatus.interested;
    _syncNotesController(saved?.notes);

    ref.listen(savedControllerProvider, (previous, next) {
      if (next.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMapper.userMessage(next.error))),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Application status",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SegmentedButton<ApplicationStatus>(
          segments: [
            for (final value in ApplicationStatus.values)
              ButtonSegment(value: value, label: Text(value.label)),
          ],
          selected: {status},
          onSelectionChanged: (selection) {
            ref
                .read(savedControllerProvider.notifier)
                .updateStatus(widget.programmeId, selection.first);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: "Notes",
            hintText: "Add personal notes",
            border: OutlineInputBorder(),
          ),
          minLines: 2,
          maxLines: 4,
          maxLength: 2000,
          onChanged: _onNotesChanged,
        ),
      ],
    );
  }

  void _syncNotesController(String? notes) {
    final value = notes ?? "";
    if (_notesController.text == value || _lastSavedNotes == value) {
      return;
    }
    _notesController.text = value;
    _lastSavedNotes = value;
  }

  void _onNotesChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) {
        return;
      }
      if (value == _lastSavedNotes) {
        return;
      }
      _lastSavedNotes = value;
      ref
          .read(savedControllerProvider.notifier)
          .updateNotes(widget.programmeId, value);
    });
  }
}
