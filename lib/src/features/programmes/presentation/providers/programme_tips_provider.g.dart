// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'programme_tips_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$programmeTagsHash() => r'db7b6d3084cdae19e2edc8a94ec492d7ffe574a9';

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

/// See also [programmeTags].
@ProviderFor(programmeTags)
const programmeTagsProvider = ProgrammeTagsFamily();

/// See also [programmeTags].
class ProgrammeTagsFamily extends Family<AsyncValue<List<Tag>>> {
  /// See also [programmeTags].
  const ProgrammeTagsFamily();

  /// See also [programmeTags].
  ProgrammeTagsProvider call(String programmeId) {
    return ProgrammeTagsProvider(programmeId);
  }

  @override
  ProgrammeTagsProvider getProviderOverride(
    covariant ProgrammeTagsProvider provider,
  ) {
    return call(provider.programmeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'programmeTagsProvider';
}

/// See also [programmeTags].
class ProgrammeTagsProvider extends AutoDisposeFutureProvider<List<Tag>> {
  /// See also [programmeTags].
  ProgrammeTagsProvider(String programmeId)
    : this._internal(
        (ref) => programmeTags(ref as ProgrammeTagsRef, programmeId),
        from: programmeTagsProvider,
        name: r'programmeTagsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$programmeTagsHash,
        dependencies: ProgrammeTagsFamily._dependencies,
        allTransitiveDependencies:
            ProgrammeTagsFamily._allTransitiveDependencies,
        programmeId: programmeId,
      );

  ProgrammeTagsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programmeId,
  }) : super.internal();

  final String programmeId;

  @override
  Override overrideWith(
    FutureOr<List<Tag>> Function(ProgrammeTagsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProgrammeTagsProvider._internal(
        (ref) => create(ref as ProgrammeTagsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programmeId: programmeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Tag>> createElement() {
    return _ProgrammeTagsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgrammeTagsProvider && other.programmeId == programmeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programmeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgrammeTagsRef on AutoDisposeFutureProviderRef<List<Tag>> {
  /// The parameter `programmeId` of this provider.
  String get programmeId;
}

class _ProgrammeTagsProviderElement
    extends AutoDisposeFutureProviderElement<List<Tag>>
    with ProgrammeTagsRef {
  _ProgrammeTagsProviderElement(super.provider);

  @override
  String get programmeId => (origin as ProgrammeTagsProvider).programmeId;
}

String _$similarProgrammesHash() => r'fbcea3bdbe9a06579aae0349b2fe8746fb675114';

/// See also [similarProgrammes].
@ProviderFor(similarProgrammes)
const similarProgrammesProvider = SimilarProgrammesFamily();

/// See also [similarProgrammes].
class SimilarProgrammesFamily extends Family<AsyncValue<List<Programme>>> {
  /// See also [similarProgrammes].
  const SimilarProgrammesFamily();

  /// See also [similarProgrammes].
  SimilarProgrammesProvider call(String programmeId, List<String> tagIds) {
    return SimilarProgrammesProvider(programmeId, tagIds);
  }

  @override
  SimilarProgrammesProvider getProviderOverride(
    covariant SimilarProgrammesProvider provider,
  ) {
    return call(provider.programmeId, provider.tagIds);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'similarProgrammesProvider';
}

/// See also [similarProgrammes].
class SimilarProgrammesProvider
    extends AutoDisposeFutureProvider<List<Programme>> {
  /// See also [similarProgrammes].
  SimilarProgrammesProvider(String programmeId, List<String> tagIds)
    : this._internal(
        (ref) =>
            similarProgrammes(ref as SimilarProgrammesRef, programmeId, tagIds),
        from: similarProgrammesProvider,
        name: r'similarProgrammesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$similarProgrammesHash,
        dependencies: SimilarProgrammesFamily._dependencies,
        allTransitiveDependencies:
            SimilarProgrammesFamily._allTransitiveDependencies,
        programmeId: programmeId,
        tagIds: tagIds,
      );

  SimilarProgrammesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programmeId,
    required this.tagIds,
  }) : super.internal();

  final String programmeId;
  final List<String> tagIds;

  @override
  Override overrideWith(
    FutureOr<List<Programme>> Function(SimilarProgrammesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SimilarProgrammesProvider._internal(
        (ref) => create(ref as SimilarProgrammesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programmeId: programmeId,
        tagIds: tagIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Programme>> createElement() {
    return _SimilarProgrammesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarProgrammesProvider &&
        other.programmeId == programmeId &&
        other.tagIds == tagIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programmeId.hashCode);
    hash = _SystemHash.combine(hash, tagIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SimilarProgrammesRef on AutoDisposeFutureProviderRef<List<Programme>> {
  /// The parameter `programmeId` of this provider.
  String get programmeId;

  /// The parameter `tagIds` of this provider.
  List<String> get tagIds;
}

class _SimilarProgrammesProviderElement
    extends AutoDisposeFutureProviderElement<List<Programme>>
    with SimilarProgrammesRef {
  _SimilarProgrammesProviderElement(super.provider);

  @override
  String get programmeId => (origin as SimilarProgrammesProvider).programmeId;
  @override
  List<String> get tagIds => (origin as SimilarProgrammesProvider).tagIds;
}

String _$programmeTipsHash() => r'2401cdf9b477e9ddadc176f5bbf96eced81fb32d';

abstract class _$ProgrammeTips
    extends BuildlessAutoDisposeAsyncNotifier<List<ProgrammeTip>> {
  late final String programmeId;

  FutureOr<List<ProgrammeTip>> build(String programmeId);
}

/// See also [ProgrammeTips].
@ProviderFor(ProgrammeTips)
const programmeTipsProvider = ProgrammeTipsFamily();

/// See also [ProgrammeTips].
class ProgrammeTipsFamily extends Family<AsyncValue<List<ProgrammeTip>>> {
  /// See also [ProgrammeTips].
  const ProgrammeTipsFamily();

  /// See also [ProgrammeTips].
  ProgrammeTipsProvider call(String programmeId) {
    return ProgrammeTipsProvider(programmeId);
  }

  @override
  ProgrammeTipsProvider getProviderOverride(
    covariant ProgrammeTipsProvider provider,
  ) {
    return call(provider.programmeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'programmeTipsProvider';
}

/// See also [ProgrammeTips].
class ProgrammeTipsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProgrammeTips,
          List<ProgrammeTip>
        > {
  /// See also [ProgrammeTips].
  ProgrammeTipsProvider(String programmeId)
    : this._internal(
        () => ProgrammeTips()..programmeId = programmeId,
        from: programmeTipsProvider,
        name: r'programmeTipsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$programmeTipsHash,
        dependencies: ProgrammeTipsFamily._dependencies,
        allTransitiveDependencies:
            ProgrammeTipsFamily._allTransitiveDependencies,
        programmeId: programmeId,
      );

  ProgrammeTipsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.programmeId,
  }) : super.internal();

  final String programmeId;

  @override
  FutureOr<List<ProgrammeTip>> runNotifierBuild(
    covariant ProgrammeTips notifier,
  ) {
    return notifier.build(programmeId);
  }

  @override
  Override overrideWith(ProgrammeTips Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProgrammeTipsProvider._internal(
        () => create()..programmeId = programmeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        programmeId: programmeId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProgrammeTips, List<ProgrammeTip>>
  createElement() {
    return _ProgrammeTipsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgrammeTipsProvider && other.programmeId == programmeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, programmeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgrammeTipsRef
    on AutoDisposeAsyncNotifierProviderRef<List<ProgrammeTip>> {
  /// The parameter `programmeId` of this provider.
  String get programmeId;
}

class _ProgrammeTipsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProgrammeTips,
          List<ProgrammeTip>
        >
    with ProgrammeTipsRef {
  _ProgrammeTipsProviderElement(super.provider);

  @override
  String get programmeId => (origin as ProgrammeTipsProvider).programmeId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
