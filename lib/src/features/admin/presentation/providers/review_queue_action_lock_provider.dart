// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:riverpod_annotation/riverpod_annotation.dart";

part "review_queue_action_lock_provider.g.dart";

/// Global lock while a curation action runs (prevents wrong-card approve).
@riverpod
class ReviewQueueActionLock extends _$ReviewQueueActionLock {
  @override
  String? build() => null;

  void setActive(String? programmeId) {
    state = programmeId;
  }
}
