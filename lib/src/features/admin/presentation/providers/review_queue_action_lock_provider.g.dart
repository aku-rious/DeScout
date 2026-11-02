// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_queue_action_lock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewQueueActionLockHash() =>
    r'bbb81481ee66d61d4d493a67feb6be2e57fc20aa';

/// Global lock while a curation action runs (prevents wrong-card approve).
///
/// Copied from [ReviewQueueActionLock].
@ProviderFor(ReviewQueueActionLock)
final reviewQueueActionLockProvider =
    AutoDisposeNotifierProvider<ReviewQueueActionLock, String?>.internal(
      ReviewQueueActionLock.new,
      name: r'reviewQueueActionLockProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reviewQueueActionLockHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReviewQueueActionLock = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
