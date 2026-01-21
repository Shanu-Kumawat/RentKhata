// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_cycle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billingAttentionConfigHash() =>
    r'ce850554deb588b1dfe44291a38f84319b020ea5';

/// Configuration provider for billing attention thresholds.
/// Uses settings from database.
///
/// Copied from [billingAttentionConfig].
@ProviderFor(billingAttentionConfig)
final billingAttentionConfigProvider =
    AutoDisposeFutureProvider<BillingAttentionConfig>.internal(
      billingAttentionConfig,
      name: r'billingAttentionConfigProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$billingAttentionConfigHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillingAttentionConfigRef =
    AutoDisposeFutureProviderRef<BillingAttentionConfig>;
String _$currentBillingCycleHash() =>
    r'000af6230983654dad6384a44c552861a7ffd50a';

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

/// Get the current billing cycle for an occupancy.
///
/// Returns the cycle containing today's date, calculated from the
/// occupancy's move-in date using anniversary-based logic.
///
/// Copied from [currentBillingCycle].
@ProviderFor(currentBillingCycle)
const currentBillingCycleProvider = CurrentBillingCycleFamily();

/// Get the current billing cycle for an occupancy.
///
/// Returns the cycle containing today's date, calculated from the
/// occupancy's move-in date using anniversary-based logic.
///
/// Copied from [currentBillingCycle].
class CurrentBillingCycleFamily extends Family<BillingCycle> {
  /// Get the current billing cycle for an occupancy.
  ///
  /// Returns the cycle containing today's date, calculated from the
  /// occupancy's move-in date using anniversary-based logic.
  ///
  /// Copied from [currentBillingCycle].
  const CurrentBillingCycleFamily();

  /// Get the current billing cycle for an occupancy.
  ///
  /// Returns the cycle containing today's date, calculated from the
  /// occupancy's move-in date using anniversary-based logic.
  ///
  /// Copied from [currentBillingCycle].
  CurrentBillingCycleProvider call(Occupancy occupancy) {
    return CurrentBillingCycleProvider(occupancy);
  }

  @override
  CurrentBillingCycleProvider getProviderOverride(
    covariant CurrentBillingCycleProvider provider,
  ) {
    return call(provider.occupancy);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currentBillingCycleProvider';
}

/// Get the current billing cycle for an occupancy.
///
/// Returns the cycle containing today's date, calculated from the
/// occupancy's move-in date using anniversary-based logic.
///
/// Copied from [currentBillingCycle].
class CurrentBillingCycleProvider extends AutoDisposeProvider<BillingCycle> {
  /// Get the current billing cycle for an occupancy.
  ///
  /// Returns the cycle containing today's date, calculated from the
  /// occupancy's move-in date using anniversary-based logic.
  ///
  /// Copied from [currentBillingCycle].
  CurrentBillingCycleProvider(Occupancy occupancy)
    : this._internal(
        (ref) => currentBillingCycle(ref as CurrentBillingCycleRef, occupancy),
        from: currentBillingCycleProvider,
        name: r'currentBillingCycleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$currentBillingCycleHash,
        dependencies: CurrentBillingCycleFamily._dependencies,
        allTransitiveDependencies:
            CurrentBillingCycleFamily._allTransitiveDependencies,
        occupancy: occupancy,
      );

  CurrentBillingCycleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.occupancy,
  }) : super.internal();

  final Occupancy occupancy;

  @override
  Override overrideWith(
    BillingCycle Function(CurrentBillingCycleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentBillingCycleProvider._internal(
        (ref) => create(ref as CurrentBillingCycleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        occupancy: occupancy,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<BillingCycle> createElement() {
    return _CurrentBillingCycleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentBillingCycleProvider && other.occupancy == occupancy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, occupancy.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentBillingCycleRef on AutoDisposeProviderRef<BillingCycle> {
  /// The parameter `occupancy` of this provider.
  Occupancy get occupancy;
}

class _CurrentBillingCycleProviderElement
    extends AutoDisposeProviderElement<BillingCycle>
    with CurrentBillingCycleRef {
  _CurrentBillingCycleProviderElement(super.provider);

  @override
  Occupancy get occupancy => (origin as CurrentBillingCycleProvider).occupancy;
}

String _$nextBillingCycleForHash() =>
    r'6fa095445f9ccd4797a5b215fe02592a68b06d8e';

/// Get the next billing cycle that needs a bill.
///
/// Logic:
/// 1. Start from cycle 0 (first cycle from move-in date)
/// 2. For each cycle, check if a rent bill exists covering that period
/// 3. Return the first cycle that has no matching bill
///
/// Copied from [nextBillingCycleFor].
@ProviderFor(nextBillingCycleFor)
const nextBillingCycleForProvider = NextBillingCycleForFamily();

/// Get the next billing cycle that needs a bill.
///
/// Logic:
/// 1. Start from cycle 0 (first cycle from move-in date)
/// 2. For each cycle, check if a rent bill exists covering that period
/// 3. Return the first cycle that has no matching bill
///
/// Copied from [nextBillingCycleFor].
class NextBillingCycleForFamily extends Family<AsyncValue<BillingCycle>> {
  /// Get the next billing cycle that needs a bill.
  ///
  /// Logic:
  /// 1. Start from cycle 0 (first cycle from move-in date)
  /// 2. For each cycle, check if a rent bill exists covering that period
  /// 3. Return the first cycle that has no matching bill
  ///
  /// Copied from [nextBillingCycleFor].
  const NextBillingCycleForFamily();

  /// Get the next billing cycle that needs a bill.
  ///
  /// Logic:
  /// 1. Start from cycle 0 (first cycle from move-in date)
  /// 2. For each cycle, check if a rent bill exists covering that period
  /// 3. Return the first cycle that has no matching bill
  ///
  /// Copied from [nextBillingCycleFor].
  NextBillingCycleForProvider call(int occupancyId) {
    return NextBillingCycleForProvider(occupancyId);
  }

  @override
  NextBillingCycleForProvider getProviderOverride(
    covariant NextBillingCycleForProvider provider,
  ) {
    return call(provider.occupancyId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nextBillingCycleForProvider';
}

/// Get the next billing cycle that needs a bill.
///
/// Logic:
/// 1. Start from cycle 0 (first cycle from move-in date)
/// 2. For each cycle, check if a rent bill exists covering that period
/// 3. Return the first cycle that has no matching bill
///
/// Copied from [nextBillingCycleFor].
class NextBillingCycleForProvider
    extends AutoDisposeFutureProvider<BillingCycle> {
  /// Get the next billing cycle that needs a bill.
  ///
  /// Logic:
  /// 1. Start from cycle 0 (first cycle from move-in date)
  /// 2. For each cycle, check if a rent bill exists covering that period
  /// 3. Return the first cycle that has no matching bill
  ///
  /// Copied from [nextBillingCycleFor].
  NextBillingCycleForProvider(int occupancyId)
    : this._internal(
        (ref) =>
            nextBillingCycleFor(ref as NextBillingCycleForRef, occupancyId),
        from: nextBillingCycleForProvider,
        name: r'nextBillingCycleForProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$nextBillingCycleForHash,
        dependencies: NextBillingCycleForFamily._dependencies,
        allTransitiveDependencies:
            NextBillingCycleForFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  NextBillingCycleForProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.occupancyId,
  }) : super.internal();

  final int occupancyId;

  @override
  Override overrideWith(
    FutureOr<BillingCycle> Function(NextBillingCycleForRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NextBillingCycleForProvider._internal(
        (ref) => create(ref as NextBillingCycleForRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        occupancyId: occupancyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BillingCycle> createElement() {
    return _NextBillingCycleForProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NextBillingCycleForProvider &&
        other.occupancyId == occupancyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, occupancyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NextBillingCycleForRef on AutoDisposeFutureProviderRef<BillingCycle> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _NextBillingCycleForProviderElement
    extends AutoDisposeFutureProviderElement<BillingCycle>
    with NextBillingCycleForRef {
  _NextBillingCycleForProviderElement(super.provider);

  @override
  int get occupancyId => (origin as NextBillingCycleForProvider).occupancyId;
}

String _$billingStatusForHash() => r'795619c96efb1a713d081359a7e9bf85cb397a15';

/// Get billing attention status for a single occupancy.
///
/// Returns null if the occupancy is up-to-date (no attention needed).
///
/// Copied from [billingStatusFor].
@ProviderFor(billingStatusFor)
const billingStatusForProvider = BillingStatusForFamily();

/// Get billing attention status for a single occupancy.
///
/// Returns null if the occupancy is up-to-date (no attention needed).
///
/// Copied from [billingStatusFor].
class BillingStatusForFamily extends Family<AsyncValue<BillingAttentionItem?>> {
  /// Get billing attention status for a single occupancy.
  ///
  /// Returns null if the occupancy is up-to-date (no attention needed).
  ///
  /// Copied from [billingStatusFor].
  const BillingStatusForFamily();

  /// Get billing attention status for a single occupancy.
  ///
  /// Returns null if the occupancy is up-to-date (no attention needed).
  ///
  /// Copied from [billingStatusFor].
  BillingStatusForProvider call(int occupancyId) {
    return BillingStatusForProvider(occupancyId);
  }

  @override
  BillingStatusForProvider getProviderOverride(
    covariant BillingStatusForProvider provider,
  ) {
    return call(provider.occupancyId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'billingStatusForProvider';
}

/// Get billing attention status for a single occupancy.
///
/// Returns null if the occupancy is up-to-date (no attention needed).
///
/// Copied from [billingStatusFor].
class BillingStatusForProvider
    extends AutoDisposeFutureProvider<BillingAttentionItem?> {
  /// Get billing attention status for a single occupancy.
  ///
  /// Returns null if the occupancy is up-to-date (no attention needed).
  ///
  /// Copied from [billingStatusFor].
  BillingStatusForProvider(int occupancyId)
    : this._internal(
        (ref) => billingStatusFor(ref as BillingStatusForRef, occupancyId),
        from: billingStatusForProvider,
        name: r'billingStatusForProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billingStatusForHash,
        dependencies: BillingStatusForFamily._dependencies,
        allTransitiveDependencies:
            BillingStatusForFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  BillingStatusForProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.occupancyId,
  }) : super.internal();

  final int occupancyId;

  @override
  Override overrideWith(
    FutureOr<BillingAttentionItem?> Function(BillingStatusForRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BillingStatusForProvider._internal(
        (ref) => create(ref as BillingStatusForRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        occupancyId: occupancyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BillingAttentionItem?> createElement() {
    return _BillingStatusForProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillingStatusForProvider &&
        other.occupancyId == occupancyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, occupancyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BillingStatusForRef
    on AutoDisposeFutureProviderRef<BillingAttentionItem?> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _BillingStatusForProviderElement
    extends AutoDisposeFutureProviderElement<BillingAttentionItem?>
    with BillingStatusForRef {
  _BillingStatusForProviderElement(super.provider);

  @override
  int get occupancyId => (origin as BillingStatusForProvider).occupancyId;
}

String _$billingAttentionListHash() =>
    r'1ebc703e71bb429923c3ba74c1c2480913ba4869';

/// Get all occupancies that need billing attention.
///
/// Returns a list of occupancies where:
/// - Cycle is ending within the "due soon" threshold, OR
/// - Cycle has already ended (overdue)
///
/// Sorted by urgency (overdue first, then by days until due).
///
/// Copied from [billingAttentionList].
@ProviderFor(billingAttentionList)
final billingAttentionListProvider =
    AutoDisposeFutureProvider<List<BillingAttentionItem>>.internal(
      billingAttentionList,
      name: r'billingAttentionListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$billingAttentionListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillingAttentionListRef =
    AutoDisposeFutureProviderRef<List<BillingAttentionItem>>;
String _$billingAttentionCountHash() =>
    r'c61f2b81b073ffde50a1dafa48588ffaabfe23fe';

/// Count of occupancies needing billing attention.
///
/// Copied from [billingAttentionCount].
@ProviderFor(billingAttentionCount)
final billingAttentionCountProvider = AutoDisposeFutureProvider<int>.internal(
  billingAttentionCount,
  name: r'billingAttentionCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$billingAttentionCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillingAttentionCountRef = AutoDisposeFutureProviderRef<int>;
String _$overdueBillingCountHash() =>
    r'085bb7c4338e6ad8d2cddcdf98ae6f8f508a6755';

/// Count of overdue billing cycles.
///
/// Copied from [overdueBillingCount].
@ProviderFor(overdueBillingCount)
final overdueBillingCountProvider = AutoDisposeFutureProvider<int>.internal(
  overdueBillingCount,
  name: r'overdueBillingCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overdueBillingCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverdueBillingCountRef = AutoDisposeFutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
