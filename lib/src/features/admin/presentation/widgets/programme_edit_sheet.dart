// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/supabase/table_names.dart";
import "package:de_scout/src/features/programmes/domain/programme.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:flutter/material.dart";

/// Bottom sheet form for editing a programme before approval.
class ProgrammeEditSheet extends StatefulWidget {
  const ProgrammeEditSheet({
    required this.programme,
    required this.onSubmit,
    super.key,
  });

  final Programme programme;
  final Future<void> Function(Map<String, dynamic> fields) onSubmit;

  static Future<void> show({
    required BuildContext context,
    required Programme programme,
    required Future<void> Function(Map<String, dynamic> fields) onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          ProgrammeEditSheet(programme: programme, onSubmit: onSubmit),
    );
  }

  @override
  State<ProgrammeEditSheet> createState() => _ProgrammeEditSheetState();
}

class _ProgrammeEditSheetState extends State<ProgrammeEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late final TextEditingController _stipendController;
  late ProgrammeType _type;
  late bool? _nigeriaEligible;
  late bool _remote;
  DateTime? _opensAt;
  DateTime? _closesAt;
  var _submitting = false;

  @override
  void initState() {
    super.initState();
    final programme = widget.programme;
    _nameController = TextEditingController(text: programme.name);
    _urlController = TextEditingController(text: programme.url);
    _stipendController = TextEditingController(
      text: programme.stipendUsd?.toString() ?? "",
    );
    _type = programme.type;
    _nigeriaEligible = programme.nigeriaEligible;
    _remote = programme.remote ?? false;
    _opensAt = programme.opensAt;
    _closesAt = programme.closesAt;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _stipendController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isOpensAt}) async {
    final initial = isOpensAt ? _opensAt : _closesAt;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      if (isOpensAt) {
        _opensAt = picked;
      } else {
        _closesAt = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _submitting = true);
    try {
      final stipendText = _stipendController.text.trim();
      final fields = <String, dynamic>{
        Cols.name: _nameController.text.trim(),
        Cols.url: _urlController.text.trim(),
        Cols.type: _type.name,
        Cols.remote: _remote,
        Cols.nigeriaEligible: _nigeriaEligible,
        Cols.opensAt: _opensAt?.toUtc().toIso8601String(),
        Cols.closesAt: _closesAt?.toUtc().toIso8601String(),
        Cols.stipendUsd: stipendText.isEmpty ? null : double.parse(stipendText),
      };
      await widget.onSubmit(fields);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit programme",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: "URL"),
                validator: (value) {
                  final trimmed = value?.trim() ?? "";
                  if (trimmed.isEmpty) {
                    return "Required";
                  }
                  if (!trimmed.startsWith("https://")) {
                    return "URL must start with https://";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SegmentedButton<ProgrammeType>(
                segments: const [
                  ButtonSegment(
                    value: ProgrammeType.hackathon,
                    label: Text("Hackathon"),
                  ),
                  ButtonSegment(
                    value: ProgrammeType.fellowship,
                    label: Text("Fellowship"),
                  ),
                  ButtonSegment(
                    value: ProgrammeType.programme,
                    label: Text("Programme"),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (selection) {
                  setState(() => _type = selection.first);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stipendController,
                decoration: const InputDecoration(labelText: "Stipend (USD)"),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Remote"),
                value: _remote,
                onChanged: (value) => setState(() => _remote = value),
              ),
              const Text("Nigeria eligible"),
              ToggleButtons(
                isSelected: [
                  _nigeriaEligible == true,
                  _nigeriaEligible == false,
                  _nigeriaEligible == null,
                ],
                onPressed: (index) {
                  setState(() {
                    _nigeriaEligible = switch (index) {
                      0 => true,
                      1 => false,
                      _ => null,
                    };
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Yes"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("No"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Unknown"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Opens at"),
                subtitle: Text(
                  _opensAt?.toLocal().toString().split(" ").first ?? "Not set",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () => _pickDate(isOpensAt: true),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Closes at"),
                subtitle: Text(
                  _closesAt?.toLocal().toString().split(" ").first ?? "Not set",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () => _pickDate(isOpensAt: false),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save and approve"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
