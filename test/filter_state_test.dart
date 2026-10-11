// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/domain/filter_state.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("tagSlug counts as active filter", () {
    const filters = FilterState(tagSlug: "open-source");
    expect(filters.hasActiveFilters, isTrue);
  });

  test("clearTagSlug removes tag from copyWith", () {
    const filters = FilterState(tagSlug: "open-source");
    final cleared = filters.copyWith(clearTagSlug: true);
    expect(cleared.tagSlug, isNull);
    expect(cleared.hasActiveFilters, isFalse);
  });

  test("searchQuery counts as active filter", () {
    const filters = FilterState(searchQuery: "gsoc");
    expect(filters.hasActiveFilters, isTrue);
  });
}
