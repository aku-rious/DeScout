// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userSettingsRepositoryHash() =>
    r'a4a925d6d2942297e777d60d5a14341f1941b2b7';

/// See also [userSettingsRepository].
@ProviderFor(userSettingsRepository)
final userSettingsRepositoryProvider =
    AutoDisposeProvider<UserSettingsRepository>.internal(
      userSettingsRepository,
      name: r'userSettingsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSettingsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSettingsRepositoryRef =
    AutoDisposeProviderRef<UserSettingsRepository>;
String _$notificationPermissionGrantedHash() =>
    r'7cbe1b342b2890827a9debae79447d41c8a26274';

/// See also [notificationPermissionGranted].
@ProviderFor(notificationPermissionGranted)
final notificationPermissionGrantedProvider =
    AutoDisposeFutureProvider<bool>.internal(
      notificationPermissionGranted,
      name: r'notificationPermissionGrantedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationPermissionGrantedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationPermissionGrantedRef = AutoDisposeFutureProviderRef<bool>;
String _$notificationDaysBeforeHash() =>
    r'34d89dfa86e603e8f7778cc75f2cb868cb6e77a2';

/// See also [NotificationDaysBefore].
@ProviderFor(NotificationDaysBefore)
final notificationDaysBeforeProvider =
    AutoDisposeAsyncNotifierProvider<NotificationDaysBefore, int>.internal(
      NotificationDaysBefore.new,
      name: r'notificationDaysBeforeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationDaysBeforeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationDaysBefore = AutoDisposeAsyncNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
