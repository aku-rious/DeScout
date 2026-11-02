// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'programmes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$programmesHash() => r'6df7d9f42f71c44196a54618b9366f93e6c1e870';

/// See also [programmes].
@ProviderFor(programmes)
final programmesProvider = AutoDisposeFutureProvider<List<Programme>>.internal(
  programmes,
  name: r'programmesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$programmesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProgrammesRef = AutoDisposeFutureProviderRef<List<Programme>>;
String _$programmeDetailHash() => r'd72de77e11bbe5d3bc88ab793ff867af286aadf8';

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

/// See also [programmeDetail].
@ProviderFor(programmeDetail)
const programmeDetailProvider = ProgrammeDetailFamily();

/// See also [programmeDetail].
class ProgrammeDetailFamily extends Family<AsyncValue<Programme?>> {
  /// See also [programmeDetail].
  const ProgrammeDetailFamily();

  /// See also [programmeDetail].
  ProgrammeDetailProvider call(String id) {
    return ProgrammeDetailProvider(id);
  }

  @override
  ProgrammeDetailProvider getProviderOverride(
    covariant ProgrammeDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'programmeDetailProvider';
}

/// See also [programmeDetail].
class ProgrammeDetailProvider extends AutoDisposeFutureProvider<Programme?> {
  /// See also [programmeDetail].
  ProgrammeDetailProvider(String id)
    : this._internal(
        (ref) => programmeDetail(ref as ProgrammeDetailRef, id),
        from: programmeDetailProvider,
        name: r'programmeDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$programmeDetailHash,
        dependencies: ProgrammeDetailFamily._dependencies,
        allTransitiveDependencies:
            ProgrammeDetailFamily._allTransitiveDependencies,
        id: id,
      );

  ProgrammeDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Programme?> Function(ProgrammeDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProgrammeDetailProvider._internal(
        (ref) => create(ref as ProgrammeDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Programme?> createElement() {
    return _ProgrammeDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgrammeDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgrammeDetailRef on AutoDisposeFutureProviderRef<Programme?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ProgrammeDetailProviderElement
    extends AutoDisposeFutureProviderElement<Programme?>
    with ProgrammeDetailRef {
  _ProgrammeDetailProviderElement(super.provider);

  @override
  String get id => (origin as ProgrammeDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
