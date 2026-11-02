// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/errors/error_mapper.dart";
import "package:de_scout/src/features/admin/presentation/providers/exchange_rate_admin_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

/// Admin tab for viewing and updating the USD→NGN exchange rate.
class ExchangeRateAdminSection extends ConsumerStatefulWidget {
  const ExchangeRateAdminSection({super.key});

  @override
  ConsumerState<ExchangeRateAdminSection> createState() =>
      _ExchangeRateAdminSectionState();
}

class _ExchangeRateAdminSectionState
    extends ConsumerState<ExchangeRateAdminSection> {
  final _rateController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rateAsync = ref.watch(exchangeRateAdminProvider);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    ref.listen(exchangeRateAdminProvider, (previous, next) {
      if (next.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMapper.userMessage(next.error))),
        );
      }
    });

    return rateAsync.when(
      data: (details) {
        if (!_initialized) {
          _rateController.text = details.rate.toStringAsFixed(2);
          _initialized = true;
        }
        final updated = DateFormat.yMMMd().add_jm().format(details.updatedAt);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("Exchange Rate", style: textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(
              "Current rate: ₦${details.rate.toStringAsFixed(2)} per \$1 USD",
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Last updated: $updated · Source: ${details.source}",
              style: textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "NGN per USD",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: rateAsync.isLoading ? null : _submit,
              child: rateAsync.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Update rate"),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(ErrorMapper.userMessage(error)),
      ),
    );
  }

  Future<void> _submit() async {
    final value = double.tryParse(_rateController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid rate greater than zero")),
      );
      return;
    }

    await ref.read(exchangeRateAdminProvider.notifier).updateRate(value);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Rate updated to ₦${value.toStringAsFixed(2)}",
          ),
        ),
      );
    }
  }
}
