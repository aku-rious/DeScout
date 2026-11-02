// Copyright (C) 2026 Polymath
// SPDX-License-Identifier: AGPL-3.0-or-later

import "package:de_scout/src/features/programmes/presentation/providers/filter_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Search bar for filtering programmes by name.
class ProgrammesSearchBar extends ConsumerStatefulWidget {
  const ProgrammesSearchBar({super.key});

  @override
  ConsumerState<ProgrammesSearchBar> createState() =>
      _ProgrammesSearchBarState();
}

class _ProgrammesSearchBarState extends ConsumerState<ProgrammesSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SearchBar(
        controller: _controller,
        hintText: "Search programmes",
        leading: const Icon(Icons.search),
        trailing: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(filterProvider.notifier).setSearchQuery("");
              },
            ),
        ],
        onChanged: (value) {
          ref.read(filterProvider.notifier).setSearchQuery(value);
          setState(() {});
        },
      ),
    );
  }
}
