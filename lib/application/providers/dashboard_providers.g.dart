// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardSummaryHash() => r'a80b517b9226568b829b6bb47057131d68299c49';

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
String _$isFirstLaunchHash() => r'2c48befbb3e58277d3e7b6db3952058d5345e417';

/// Check if is first launch (onboarding not completed).
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
String _$landlordHash() => r'afad6822db8ae00a4ddde075fcd590d61dce5802';

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
String _$filteredFinancialsHash() =>
    r'767adb6cfad1d5d70853b451d9762d198101929e';

/// Provides financial summary filtered by month.
///
/// Copied from [filteredFinancials].
@ProviderFor(filteredFinancials)
final filteredFinancialsProvider =
    AutoDisposeFutureProvider<FilteredFinancialSummary>.internal(
      filteredFinancials,
      name: r'filteredFinancialsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredFinancialsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredFinancialsRef =
    AutoDisposeFutureProviderRef<FilteredFinancialSummary>;
String _$roomStatusListHash() => r'0ff67f44e637f4d50fd426faec8bcfb5c5b8dcf5';

/// Provides list of rooms with their status.
///
/// Copied from [roomStatusList].
@ProviderFor(roomStatusList)
final roomStatusListProvider =
    AutoDisposeFutureProvider<List<RoomStatusItem>>.internal(
      roomStatusList,
      name: r'roomStatusListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomStatusListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomStatusListRef = AutoDisposeFutureProviderRef<List<RoomStatusItem>>;
String _$dashboardMonthHash() => r'6612d9fae09ac81b7a4a7bef1046e19052f80e72';

/// Selected dashboard month.
///
/// Copied from [DashboardMonth].
@ProviderFor(DashboardMonth)
final dashboardMonthProvider =
    AutoDisposeNotifierProvider<DashboardMonth, DateTime>.internal(
      DashboardMonth.new,
      name: r'dashboardMonthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardMonthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DashboardMonth = AutoDisposeNotifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
