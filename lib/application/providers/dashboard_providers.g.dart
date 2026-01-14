// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardSummaryHash() => r'8327fb279e4f5525413c4e424730148cf6319ac3';

/// Provides dashboard summary.
/// Watches stream providers to auto-refresh when data changes.
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
String _$landlordStreamHash() => r'7b20d250d031f30108867ec96f3bbcd0907735a7';

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
String _$isFirstLaunchHash() => r'6af86bc237555f753eb2df364dc3273420052b72';

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
String _$landlordHash() => r'5421deb575717001fd10e677d400fddf307b1c33';

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
