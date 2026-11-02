// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$curationQueueHash() => r'475acce28df4dba8cb873b5ecc5acad4ee0bdcfc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CurationQueue
    extends BuildlessAutoDisposeAsyncNotifier<List<Programme>> {
  late final CurationQueueStatus status;

  FutureOr<List<Programme>> build(CurationQueueStatus status);
}

/// See also [CurationQueue].
@ProviderFor(CurationQueue)
const curationQueueProvider = CurationQueueFamily();

/// See also [CurationQueue].
class CurationQueueFamily extends Family<AsyncValue<List<Programme>>> {
  /// See also [CurationQueue].
  const CurationQueueFamily();

  /// See also [CurationQueue].
  CurationQueueProvider call(CurationQueueStatus status) {
    return CurationQueueProvider(status);
  }

  @override
  CurationQueueProvider getProviderOverride(
    covariant CurationQueueProvider provider,
  ) {
    return call(provider.status);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'curationQueueProvider';
}

/// See also [CurationQueue].
class CurationQueueProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<CurationQueue, List<Programme>> {
  /// See also [CurationQueue].
  CurationQueueProvider(CurationQueueStatus status)
    : this._internal(
        () => CurationQueue()..status = status,
        from: curationQueueProvider,
        name: r'curationQueueProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$curationQueueHash,
        dependencies: CurationQueueFamily._dependencies,
        allTransitiveDependencies:
            CurationQueueFamily._allTransitiveDependencies,
        status: status,
      );

  CurationQueueProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final CurationQueueStatus status;

  @override
  FutureOr<List<Programme>> runNotifierBuild(covariant CurationQueue notifier) {
    return notifier.build(status);
  }

  @override
  Override overrideWith(CurationQueue Function() create) {
    return ProviderOverride(
      origin: this,
      override: CurationQueueProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CurationQueue, List<Programme>>
  createElement() {
    return _CurationQueueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurationQueueProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurationQueueRef on AutoDisposeAsyncNotifierProviderRef<List<Programme>> {
  /// The parameter `status` of this provider.
  CurationQueueStatus get status;
}

class _CurationQueueProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<CurationQueue, List<Programme>>
    with CurationQueueRef {
  _CurationQueueProviderElement(super.provider);

  @override
  CurationQueueStatus get status => (origin as CurationQueueProvider).status;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
