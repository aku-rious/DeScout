// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isSavedHash() => r'270d3b594a32393b9f6a446b23a86b6cd07c3d0f';

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

/// See also [isSaved].
@ProviderFor(isSaved)
const isSavedProvider = IsSavedFamily();

/// See also [isSaved].
class IsSavedFamily extends Family<bool> {
  /// See also [isSaved].
  const IsSavedFamily();

  /// See also [isSaved].
  IsSavedProvider call(String programmeId) {
    return IsSavedProvider(programmeId);
  }

  @override
  IsSavedProvider getProviderOverride(covariant IsSavedProvider provider) {
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
  String? get name => r'isSavedProvider';
}

/// See also [isSaved].
class IsSavedProvider extends AutoDisposeProvider<bool> {
  /// See also [isSaved].
  IsSavedProvider(String programmeId)
    : this._internal(
        (ref) => isSaved(ref as IsSavedRef, programmeId),
        from: isSavedProvider,
        name: r'isSavedProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isSavedHash,
        dependencies: IsSavedFamily._dependencies,
        allTransitiveDependencies: IsSavedFamily._allTransitiveDependencies,
        programmeId: programmeId,
      );

  IsSavedProvider._internal(
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
  Override overrideWith(bool Function(IsSavedRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: IsSavedProvider._internal(
        (ref) => create(ref as IsSavedRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _IsSavedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsSavedProvider && other.programmeId == programmeId;
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
mixin IsSavedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `programmeId` of this provider.
  String get programmeId;
}

class _IsSavedProviderElement extends AutoDisposeProviderElement<bool>
    with IsSavedRef {
  _IsSavedProviderElement(super.provider);

  @override
  String get programmeId => (origin as IsSavedProvider).programmeId;
}

String _$savedProgrammeByIdHash() =>
    r'53a968c8d0c4abfe0a6cf3aeec5f2d93149366cb';

/// See also [savedProgrammeById].
@ProviderFor(savedProgrammeById)
const savedProgrammeByIdProvider = SavedProgrammeByIdFamily();

/// See also [savedProgrammeById].
class SavedProgrammeByIdFamily extends Family<SavedProgramme?> {
  /// See also [savedProgrammeById].
  const SavedProgrammeByIdFamily();

  /// See also [savedProgrammeById].
  SavedProgrammeByIdProvider call(String programmeId) {
    return SavedProgrammeByIdProvider(programmeId);
  }

  @override
  SavedProgrammeByIdProvider getProviderOverride(
    covariant SavedProgrammeByIdProvider provider,
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
  String? get name => r'savedProgrammeByIdProvider';
}

/// See also [savedProgrammeById].
class SavedProgrammeByIdProvider extends AutoDisposeProvider<SavedProgramme?> {
  /// See also [savedProgrammeById].
  SavedProgrammeByIdProvider(String programmeId)
    : this._internal(
        (ref) => savedProgrammeById(ref as SavedProgrammeByIdRef, programmeId),
        from: savedProgrammeByIdProvider,
        name: r'savedProgrammeByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$savedProgrammeByIdHash,
        dependencies: SavedProgrammeByIdFamily._dependencies,
        allTransitiveDependencies:
            SavedProgrammeByIdFamily._allTransitiveDependencies,
        programmeId: programmeId,
      );

  SavedProgrammeByIdProvider._internal(
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
    SavedProgramme? Function(SavedProgrammeByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SavedProgrammeByIdProvider._internal(
        (ref) => create(ref as SavedProgrammeByIdRef),
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
  AutoDisposeProviderElement<SavedProgramme?> createElement() {
    return _SavedProgrammeByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedProgrammeByIdProvider &&
        other.programmeId == programmeId;
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
mixin SavedProgrammeByIdRef on AutoDisposeProviderRef<SavedProgramme?> {
  /// The parameter `programmeId` of this provider.
  String get programmeId;
}

class _SavedProgrammeByIdProviderElement
    extends AutoDisposeProviderElement<SavedProgramme?>
    with SavedProgrammeByIdRef {
  _SavedProgrammeByIdProviderElement(super.provider);

  @override
  String get programmeId => (origin as SavedProgrammeByIdProvider).programmeId;
}

String _$savedProgrammesHash() => r'316e9d824ac8b8d024a9732552429cf495a257a8';

/// See also [SavedProgrammes].
@ProviderFor(SavedProgrammes)
final savedProgrammesProvider =
    AutoDisposeStreamNotifierProvider<
      SavedProgrammes,
      List<SavedProgramme>
    >.internal(
      SavedProgrammes.new,
      name: r'savedProgrammesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedProgrammesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SavedProgrammes = AutoDisposeStreamNotifier<List<SavedProgramme>>;
String _$savedControllerHash() => r'6c35409cfe45763a4ff47e65d922506a33f3c765';

/// See also [SavedController].
@ProviderFor(SavedController)
final savedControllerProvider =
    AutoDisposeAsyncNotifierProvider<SavedController, void>.internal(
      SavedController.new,
      name: r'savedControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SavedController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
