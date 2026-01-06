// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardSummaryHash() => r'4c979ad5ad79e502d8cbebd3d30952abff457f80';

/// Provides dashboard summary.
///
/// Copied from [dashboardSummary].
@ProviderFor(dashboardSummary)
final dashboardSummaryProvider =
    AutoDisposeFutureProvider<DashboardSummary>.internal(
      dashboardSummary,
      name: r'dashboardSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardSummaryRef = AutoDisposeFutureProviderRef<DashboardSummary>;
String _$landlordStreamHash() => r'2eecc0c5e82c6c3995aa436277ae6ce3d5d98e70';

/// Watch landlord profile.
///
/// Copied from [landlordStream].
@ProviderFor(landlordStream)
final landlordStreamProvider = AutoDisposeStreamProvider<Landlord?>.internal(
  landlordStream,
  name: r'landlordStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$landlordStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LandlordStreamRef = AutoDisposeStreamProviderRef<Landlord?>;
String _$isFirstLaunchHash() => r'ae2587fd86ae25aa73e5741462ed467ca99c35c9';

/// Check if is first launch (no landlord profile).
///
/// Copied from [isFirstLaunch].
@ProviderFor(isFirstLaunch)
final isFirstLaunchProvider = AutoDisposeFutureProvider<bool>.internal(
  isFirstLaunch,
  name: r'isFirstLaunchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isFirstLaunchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsFirstLaunchRef = AutoDisposeFutureProviderRef<bool>;
String _$landlordHash() => r'3efedf9fd79937645fe96dd05e026a77c1923183';

/// Get landlord profile.
///
/// Copied from [landlord].
@ProviderFor(landlord)
final landlordProvider = AutoDisposeFutureProvider<Landlord?>.internal(
  landlord,
  name: r'landlordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$landlordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LandlordRef = AutoDisposeFutureProviderRef<Landlord?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
