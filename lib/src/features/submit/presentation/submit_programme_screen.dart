// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/core/router/route_back_button.dart";
import "package:de_scout/src/core/router/routes.dart";
import "package:de_scout/src/features/auth/presentation/providers/auth_provider.dart";
import "package:de_scout/src/features/programmes/domain/programme_type.dart";
import "package:de_scout/src/features/submit/domain/submit_programme_input.dart";
import "package:de_scout/src/features/submit/presentation/providers/submit_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// Community programme submission form.
class SubmitProgrammeScreen extends ConsumerStatefulWidget {
  const SubmitProgrammeScreen({super.key});

  @override
  ConsumerState<SubmitProgrammeScreen> createState() =>
      _SubmitProgrammeScreenState();
}

class _SubmitProgrammeScreenState extends ConsumerState<SubmitProgrammeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _stipendController = TextEditingController();
  final _descriptionController = TextEditingController();
  ProgrammeType? _type;
  bool _remote = false;
  bool? _nigeriaEligible;
  DateTime? _opensAt;
  DateTime? _closesAt;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _stipendController.dispose();
    _descriptionController.dispose();
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
    if (!_formKey.currentState!.validate() || _type == null) {
      if (_type == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select a programme type")),
        );
      }
      return;
    }

    final stipendText = _stipendController.text.trim();
    final input = SubmitProgrammeInput(
      name: _nameController.text.trim(),
      url: _urlController.text.trim(),
      type: _type!,
      stipendUsd: stipendText.isEmpty ? null : double.tryParse(stipendText),
      remote: _remote,
      nigeriaEligible: _nigeriaEligible,
      opensAt: _opensAt,
      closesAt: _closesAt,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    await ref.read(submitControllerProvider.notifier).submit(input);
    if (!mounted) {
      return;
    }

    final submitState = ref.read(submitControllerProvider);
    submitState.whenOrNull(
      error: (error, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ErrorMapper.userMessage(error))));
      },
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Thanks — your submission will be reviewed shortly"),
          ),
        );
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authStateProvider).value?.session != null;
    final submitState = ref.watch(submitControllerProvider);
    final isSubmitting = submitState.isLoading;

    return Scaffold(
      appBar: const RoutedAppBar(title: "Submit a programme"),
      body: isLoggedIn
          ? _buildForm(context, isSubmitting)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sign in to submit a programme"),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.push(
                          "${Routes.login}?from=${Uri.encodeComponent(Routes.submit)}",
                        );
                      },
                      child: const Text("Sign in"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildForm(BuildContext context, bool isSubmitting) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name *"),
            validator: (value) =>
                value == null || value.trim().isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _urlController,
            decoration: const InputDecoration(labelText: "URL *"),
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
          Text("Type *", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<ProgrammeType>(
            emptySelectionAllowed: true,
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
            selected: _type == null ? {} : {_type!},
            onSelectionChanged: (selection) {
              setState(() {
                _type = selection.isEmpty ? null : selection.first;
              });
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _stipendController,
            decoration: const InputDecoration(labelText: "Stipend (USD)"),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                child: Text("Not sure"),
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
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
            maxLines: 4,
            maxLength: 500,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: isSubmitting ? null : _submit,
            child: isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
