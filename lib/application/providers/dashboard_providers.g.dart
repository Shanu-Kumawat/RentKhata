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
String _$filteredFinancialsHash() =>
    r'a1732ab3d1a5dc5336c76d84981a8ece321f18c9';

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
String _$roomStatusListHash() => r'8692e56ac0362c254b76b30c2c265b62dd0ca843';

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
