// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$biometricServiceHash() => r'd13b3194e57bb984c452857712b3300be3bc3346';

/// Provider for biometric service instance.
///
/// Copied from [biometricService].
@ProviderFor(biometricService)
final biometricServiceProvider = AutoDisposeProvider<BiometricService>.internal(
  biometricService,
  name: r'biometricServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$biometricServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BiometricServiceRef = AutoDisposeProviderRef<BiometricService>;
String _$biometricSupportHash() => r'c0edc99afcdf40e6118a45527e562e8bbd0c1abd';

/// Provider to check device biometric support.
///
/// Copied from [biometricSupport].
@ProviderFor(biometricSupport)
final biometricSupportProvider =
    AutoDisposeFutureProvider<BiometricSupport>.internal(
      biometricSupport,
      name: r'biometricSupportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$biometricSupportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BiometricSupportRef = AutoDisposeFutureProviderRef<BiometricSupport>;
String _$biometricSettingsHash() => r'dc465cd640142b4ed42c7ba3670e12fffe93ec13';

/// Provider for biometric settings from database.
///
/// Copied from [biometricSettings].
@ProviderFor(biometricSettings)
final biometricSettingsProvider =
    AutoDisposeStreamProvider<BiometricSetting?>.internal(
      biometricSettings,
      name: r'biometricSettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$biometricSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BiometricSettingsRef = AutoDisposeStreamProviderRef<BiometricSetting?>;
String _$appLockStateHash() => r'607e94a4fac93f3df3bb9f00f516ec735f1ab932';

/// Notifier for managing app lock state.
///
/// Copied from [AppLockState].
@ProviderFor(AppLockState)
final appLockStateProvider =
    AutoDisposeNotifierProvider<AppLockState, bool>.internal(
      AppLockState.new,
      name: r'appLockStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appLockStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppLockState = AutoDisposeNotifier<bool>;
String _$biometricSettingsNotifierHash() =>
    r'f1adff6fae0274d682abae83a769a31277996906';

/// Notifier for managing biometric settings.
///
/// Copied from [BiometricSettingsNotifier].
@ProviderFor(BiometricSettingsNotifier)
final biometricSettingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      BiometricSettingsNotifier,
      BiometricSetting?
    >.internal(
      BiometricSettingsNotifier.new,
      name: r'biometricSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$biometricSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BiometricSettingsNotifier =
    AutoDisposeAsyncNotifier<BiometricSetting?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
