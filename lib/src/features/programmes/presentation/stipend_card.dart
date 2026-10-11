// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/core/utils/currency_utils.dart";
import "package:de_scout/src/features/programmes/data/exchange_rate_repository.dart";
import "package:de_scout/src/features/programmes/presentation/providers/exchange_rate_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

/// Stipend card with USD and approximate NGN conversion.
class StipendCard extends ConsumerWidget {
  const StipendCard({required this.stipendUsd, super.key});

  final double stipendUsd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rateAsync = ref.watch(exchangeRateProvider);

    return Card(
      color: scheme.primaryContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${NumberFormat("#,###", "en_US").format(stipendUsd.round())} USD",
                    style: textTheme.titleLarge?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  rateAsync.when(
                    data: (rate) => Text(
                      formatNgn(stipendUsd, rate),
                      style: textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    loading: () => Text(
                      "…",
                      style: textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    error: (_, _) => Text(
                      formatNgn(
                        stipendUsd,
                        ExchangeRateRepository.fallbackRate,
                      ),
                      style: textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.payments_outlined,
              size: 40,
              color: scheme.onPrimaryContainer.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
