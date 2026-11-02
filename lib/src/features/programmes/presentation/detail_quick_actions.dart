// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:add_2_calendar/add_2_calendar.dart";
import "package:de_scout/src/core/utils/currency_utils.dart";
import "package:de_scout/src/features/programmes/data/exchange_rate_repository.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/presentation/providers/exchange_rate_provider.dart";
import "package:de_scout/src/features/saved/presentation/providers/saved_provider.dart";
import "package:de_scout/src/features/settings/presentation/providers/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:share_plus/share_plus.dart";

/// Calendar, share, remind, and checklist quick actions.
class DetailQuickActions extends ConsumerWidget {
  const DetailQuickActions({required this.programme, super.key});

  final Programme programme;

  static final _dateFormat = DateFormat("MMM d, yyyy");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: Icons.calendar_month_outlined,
          label: "Calendar",
          onTap: () => _addToCalendar(context),
        ),
        _ActionButton(
          icon: Icons.share_outlined,
          label: "Share",
          onTap: () => _share(context, ref),
        ),
        _ActionButton(
          icon: Icons.notifications_outlined,
          label: "Remind me",
          onTap: () => _remindMe(context, ref),
        ),
        _ActionButton(
          icon: Icons.checklist_outlined,
          label: "Checklist",
          onTap: null,
          tooltip: "Coming soon",
        ),
      ],
    );
  }

  void _addToCalendar(BuildContext context) {
    final closesAt = programme.closesAt;
    if (closesAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No deadline date available")),
      );
      return;
    }
    Add2Calendar.addEvent2Cal(
      Event(
        title: "Deadline: ${programme.name}",
        description: "Apply at: ${programme.url}",
        startDate: closesAt,
        endDate: closesAt.add(const Duration(hours: 1)),
        allDay: false,
      ),
    );
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final rate =
        ref.read(exchangeRateProvider).valueOrNull ??
        ExchangeRateRepository.fallbackRate;
    final stipendDisplay = programme.stipendUsd != null
        ? "\$${programme.stipendUsd!.toStringAsFixed(0)} (${formatNgn(programme.stipendUsd!, rate)})"
        : "Stipend TBA";
    final closesLabel = programme.closesAt != null
        ? _dateFormat.format(programme.closesAt!)
        : "TBA";
    final remoteLabel = programme.remote == true ? "Remote" : "Remote TBA";
    final ngLabel = programme.nigeriaEligible == true
        ? "Nigeria eligible"
        : "Eligibility TBA";

    await SharePlus.instance.share(
      ShareParams(
        text:
            "🚀 ${programme.name}\n"
            "${programme.type.name} · $stipendDisplay\n"
            "📅 Closes $closesLabel\n"
            "🌍 $remoteLabel · 🇳🇬 $ngLabel\n\n"
            "Apply: ${programme.url}\n\n"
            "Found on DeScout",
      ),
    );
  }

  Future<void> _remindMe(BuildContext context, WidgetRef ref) async {
    final isSaved = ref.read(isSavedProvider(programme.id));
    if (!isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Save this programme to set a reminder")),
      );
      return;
    }

    final saved = ref.read(savedProgrammeByIdProvider(programme.id));
    final defaultDays =
        ref.read(notificationDaysBeforeProvider).valueOrNull ?? 7;
    final initialDays = saved?.customReminderDays ?? defaultDays;
    final options = [3, 5, 7, 14, 21];
    var selected = options.contains(initialDays) ? initialDays : 7;

    if (!context.mounted) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Reminder"),
            content: DropdownButtonFormField<int>(
              initialValue: selected,
              decoration: const InputDecoration(
                labelText: "Days before deadline",
              ),
              items: [
                for (final days in options)
                  DropdownMenuItem(value: days, child: Text("$days days")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selected = value);
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await ref
          .read(savedControllerProvider.notifier)
          .updateCustomReminderDays(programme.id, selected);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reminder set to $selected days before")),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$error")));
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final enabled = onTap != null;

    final button = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: scheme.surfaceContainerHighest,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                icon,
                size: 20,
                color: enabled ? scheme.onSurfaceVariant : scheme.outline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: enabled ? scheme.onSurfaceVariant : scheme.outline,
          ),
        ),
      ],
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
