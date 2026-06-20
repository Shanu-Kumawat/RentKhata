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
    r'36642dfe04c7594629dec705f7485792e5a66560';

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
/// occupancy's move-in date using date-to-date based logic.
///
/// Copied from [currentBillingCycle].
@ProviderFor(currentBillingCycle)
const currentBillingCycleProvider = CurrentBillingCycleFamily();

/// Get the current billing cycle for an occupancy.
///
/// Returns the cycle containing today's date, calculated from the
/// occupancy's move-in date using date-to-date based logic.
///
/// Copied from [currentBillingCycle].
class CurrentBillingCycleFamily extends Family<BillingCycle> {
  /// Get the current billing cycle for an occupancy.
  ///
  /// Returns the cycle containing today's date, calculated from the
  /// occupancy's move-in date using date-to-date based logic.
  ///
  /// Copied from [currentBillingCycle].
  const CurrentBillingCycleFamily();

  /// Get the current billing cycle for an occupancy.
  ///
  /// Returns the cycle containing today's date, calculated from the
  /// occupancy's move-in date using date-to-date based logic.
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
/// occupancy's move-in date using date-to-date based logic.
///
/// Copied from [currentBillingCycle].
class CurrentBillingCycleProvider extends AutoDisposeProvider<BillingCycle> {
  /// Get the current billing cycle for an occupancy.
  ///
  /// Returns the cycle containing today's date, calculated from the
  /// occupancy's move-in date using date-to-date based logic.
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
    r'87440c55ae337b163e1cf9f1446244d0612e247a';

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

String _$nextBillingCycleForBillTypeHash() =>
    r'2a6139b346793a5ae4beb6bae51483ceda0526fd';

/// Get the next billing cycle for a specific bill type.
///
/// Each bill type has its own cycle progression. For example:
/// - Rent might be on cycle 5 (advance payment)
/// - Electricity might be on cycle 2 (behind on bills)
///
/// This allows independent tracking per bill type.
///
/// Copied from [nextBillingCycleForBillType].
@ProviderFor(nextBillingCycleForBillType)
const nextBillingCycleForBillTypeProvider = NextBillingCycleForBillTypeFamily();

/// Get the next billing cycle for a specific bill type.
///
/// Each bill type has its own cycle progression. For example:
/// - Rent might be on cycle 5 (advance payment)
/// - Electricity might be on cycle 2 (behind on bills)
///
/// This allows independent tracking per bill type.
///
/// Copied from [nextBillingCycleForBillType].
class NextBillingCycleForBillTypeFamily
    extends Family<AsyncValue<BillingCycle>> {
  /// Get the next billing cycle for a specific bill type.
  ///
  /// Each bill type has its own cycle progression. For example:
  /// - Rent might be on cycle 5 (advance payment)
  /// - Electricity might be on cycle 2 (behind on bills)
  ///
  /// This allows independent tracking per bill type.
  ///
  /// Copied from [nextBillingCycleForBillType].
  const NextBillingCycleForBillTypeFamily();

  /// Get the next billing cycle for a specific bill type.
  ///
  /// Each bill type has its own cycle progression. For example:
  /// - Rent might be on cycle 5 (advance payment)
  /// - Electricity might be on cycle 2 (behind on bills)
  ///
  /// This allows independent tracking per bill type.
  ///
  /// Copied from [nextBillingCycleForBillType].
  NextBillingCycleForBillTypeProvider call(int occupancyId, BillType billType) {
    return NextBillingCycleForBillTypeProvider(occupancyId, billType);
  }

  @override
  NextBillingCycleForBillTypeProvider getProviderOverride(
    covariant NextBillingCycleForBillTypeProvider provider,
  ) {
    return call(provider.occupancyId, provider.billType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nextBillingCycleForBillTypeProvider';
}

/// Get the next billing cycle for a specific bill type.
///
/// Each bill type has its own cycle progression. For example:
/// - Rent might be on cycle 5 (advance payment)
/// - Electricity might be on cycle 2 (behind on bills)
///
/// This allows independent tracking per bill type.
///
/// Copied from [nextBillingCycleForBillType].
class NextBillingCycleForBillTypeProvider
    extends AutoDisposeFutureProvider<BillingCycle> {
  /// Get the next billing cycle for a specific bill type.
  ///
  /// Each bill type has its own cycle progression. For example:
  /// - Rent might be on cycle 5 (advance payment)
  /// - Electricity might be on cycle 2 (behind on bills)
  ///
  /// This allows independent tracking per bill type.
  ///
  /// Copied from [nextBillingCycleForBillType].
  NextBillingCycleForBillTypeProvider(int occupancyId, BillType billType)
    : this._internal(
        (ref) => nextBillingCycleForBillType(
          ref as NextBillingCycleForBillTypeRef,
          occupancyId,
          billType,
        ),
        from: nextBillingCycleForBillTypeProvider,
        name: r'nextBillingCycleForBillTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$nextBillingCycleForBillTypeHash,
        dependencies: NextBillingCycleForBillTypeFamily._dependencies,
        allTransitiveDependencies:
            NextBillingCycleForBillTypeFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
        billType: billType,
      );

  NextBillingCycleForBillTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.occupancyId,
    required this.billType,
  }) : super.internal();

  final int occupancyId;
  final BillType billType;

  @override
  Override overrideWith(
    FutureOr<BillingCycle> Function(NextBillingCycleForBillTypeRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NextBillingCycleForBillTypeProvider._internal(
        (ref) => create(ref as NextBillingCycleForBillTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        occupancyId: occupancyId,
        billType: billType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BillingCycle> createElement() {
    return _NextBillingCycleForBillTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NextBillingCycleForBillTypeProvider &&
        other.occupancyId == occupancyId &&
        other.billType == billType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, occupancyId.hashCode);
    hash = _SystemHash.combine(hash, billType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NextBillingCycleForBillTypeRef
    on AutoDisposeFutureProviderRef<BillingCycle> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;

  /// The parameter `billType` of this provider.
  BillType get billType;
}

class _NextBillingCycleForBillTypeProviderElement
    extends AutoDisposeFutureProviderElement<BillingCycle>
    with NextBillingCycleForBillTypeRef {
  _NextBillingCycleForBillTypeProviderElement(super.provider);

  @override
  int get occupancyId =>
      (origin as NextBillingCycleForBillTypeProvider).occupancyId;
  @override
  BillType get billType =>
      (origin as NextBillingCycleForBillTypeProvider).billType;
}

String _$allUnbilledCyclesForBillTypeHash() =>
    r'd4ea8488d759ffeb3a0e982fc77cc7f2183b9e3a';

/// Get ALL unbilled cycles for a specific bill type up to current date.
///
/// Returns a list of ALL cycles that are missing bills, allowing the
/// attention list to show multiple overdue cycles per bill type.
///
/// Copied from [allUnbilledCyclesForBillType].
@ProviderFor(allUnbilledCyclesForBillType)
const allUnbilledCyclesForBillTypeProvider =
    AllUnbilledCyclesForBillTypeFamily();

/// Get ALL unbilled cycles for a specific bill type up to current date.
///
/// Returns a list of ALL cycles that are missing bills, allowing the
/// attention list to show multiple overdue cycles per bill type.
///
/// Copied from [allUnbilledCyclesForBillType].
class AllUnbilledCyclesForBillTypeFamily
    extends Family<AsyncValue<List<BillingCycle>>> {
  /// Get ALL unbilled cycles for a specific bill type up to current date.
  ///
  /// Returns a list of ALL cycles that are missing bills, allowing the
  /// attention list to show multiple overdue cycles per bill type.
  ///
  /// Copied from [allUnbilledCyclesForBillType].
  const AllUnbilledCyclesForBillTypeFamily();

  /// Get ALL unbilled cycles for a specific bill type up to current date.
  ///
  /// Returns a list of ALL cycles that are missing bills, allowing the
  /// attention list to show multiple overdue cycles per bill type.
  ///
  /// Copied from [allUnbilledCyclesForBillType].
  AllUnbilledCyclesForBillTypeProvider call(
    int occupancyId,
    BillType billType,
  ) {
    return AllUnbilledCyclesForBillTypeProvider(occupancyId, billType);
  }

  @override
  AllUnbilledCyclesForBillTypeProvider getProviderOverride(
    covariant AllUnbilledCyclesForBillTypeProvider provider,
  ) {
    return call(provider.occupancyId, provider.billType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allUnbilledCyclesForBillTypeProvider';
}

/// Get ALL unbilled cycles for a specific bill type up to current date.
///
/// Returns a list of ALL cycles that are missing bills, allowing the
/// attention list to show multiple overdue cycles per bill type.
///
/// Copied from [allUnbilledCyclesForBillType].
class AllUnbilledCyclesForBillTypeProvider
    extends AutoDisposeFutureProvider<List<BillingCycle>> {
  /// Get ALL unbilled cycles for a specific bill type up to current date.
  ///
  /// Returns a list of ALL cycles that are missing bills, allowing the
  /// attention list to show multiple overdue cycles per bill type.
  ///
  /// Copied from [allUnbilledCyclesForBillType].
  AllUnbilledCyclesForBillTypeProvider(int occupancyId, BillType billType)
    : this._internal(
        (ref) => allUnbilledCyclesForBillType(
          ref as AllUnbilledCyclesForBillTypeRef,
          occupancyId,
          billType,
        ),
        from: allUnbilledCyclesForBillTypeProvider,
        name: r'allUnbilledCyclesForBillTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$allUnbilledCyclesForBillTypeHash,
        dependencies: AllUnbilledCyclesForBillTypeFamily._dependencies,
        allTransitiveDependencies:
            AllUnbilledCyclesForBillTypeFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
        billType: billType,
      );

  AllUnbilledCyclesForBillTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.occupancyId,
    required this.billType,
  }) : super.internal();

  final int occupancyId;
  final BillType billType;

  @override
  Override overrideWith(
    FutureOr<List<BillingCycle>> Function(
      AllUnbilledCyclesForBillTypeRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllUnbilledCyclesForBillTypeProvider._internal(
        (ref) => create(ref as AllUnbilledCyclesForBillTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        occupancyId: occupancyId,
        billType: billType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BillingCycle>> createElement() {
    return _AllUnbilledCyclesForBillTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllUnbilledCyclesForBillTypeProvider &&
        other.occupancyId == occupancyId &&
        other.billType == billType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, occupancyId.hashCode);
    hash = _SystemHash.combine(hash, billType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllUnbilledCyclesForBillTypeRef
    on AutoDisposeFutureProviderRef<List<BillingCycle>> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;

  /// The parameter `billType` of this provider.
  BillType get billType;
}

class _AllUnbilledCyclesForBillTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<BillingCycle>>
    with AllUnbilledCyclesForBillTypeRef {
  _AllUnbilledCyclesForBillTypeProviderElement(super.provider);

  @override
  int get occupancyId =>
      (origin as AllUnbilledCyclesForBillTypeProvider).occupancyId;
  @override
  BillType get billType =>
      (origin as AllUnbilledCyclesForBillTypeProvider).billType;
}

String _$billingStatusForHash() => r'0d87d2fdc65a58bf6a37f2840d2adf9e4ef999fa';

/// Get billing attention items for a single occupancy.
///
/// Returns a list of attention items - one for EACH unbilled cycle that:
/// - Has date-to-date billing enabled in settings
/// - Has a cycle needing attention (due soon or overdue)
///
/// Copied from [billingStatusFor].
@ProviderFor(billingStatusFor)
const billingStatusForProvider = BillingStatusForFamily();

/// Get billing attention items for a single occupancy.
///
/// Returns a list of attention items - one for EACH unbilled cycle that:
/// - Has date-to-date billing enabled in settings
/// - Has a cycle needing attention (due soon or overdue)
///
/// Copied from [billingStatusFor].
class BillingStatusForFamily
    extends Family<AsyncValue<List<BillingAttentionItem>>> {
  /// Get billing attention items for a single occupancy.
  ///
  /// Returns a list of attention items - one for EACH unbilled cycle that:
  /// - Has date-to-date billing enabled in settings
  /// - Has a cycle needing attention (due soon or overdue)
  ///
  /// Copied from [billingStatusFor].
  const BillingStatusForFamily();

  /// Get billing attention items for a single occupancy.
  ///
  /// Returns a list of attention items - one for EACH unbilled cycle that:
  /// - Has date-to-date billing enabled in settings
  /// - Has a cycle needing attention (due soon or overdue)
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

/// Get billing attention items for a single occupancy.
///
/// Returns a list of attention items - one for EACH unbilled cycle that:
/// - Has date-to-date billing enabled in settings
/// - Has a cycle needing attention (due soon or overdue)
///
/// Copied from [billingStatusFor].
class BillingStatusForProvider
    extends AutoDisposeFutureProvider<List<BillingAttentionItem>> {
  /// Get billing attention items for a single occupancy.
  ///
  /// Returns a list of attention items - one for EACH unbilled cycle that:
  /// - Has date-to-date billing enabled in settings
  /// - Has a cycle needing attention (due soon or overdue)
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
    FutureOr<List<BillingAttentionItem>> Function(BillingStatusForRef provider)
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
  AutoDisposeFutureProviderElement<List<BillingAttentionItem>> createElement() {
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
    on AutoDisposeFutureProviderRef<List<BillingAttentionItem>> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _BillingStatusForProviderElement
    extends AutoDisposeFutureProviderElement<List<BillingAttentionItem>>
    with BillingStatusForRef {
  _BillingStatusForProviderElement(super.provider);

  @override
  int get occupancyId => (origin as BillingStatusForProvider).occupancyId;
}

String _$billingAttentionListHash() =>
    r'6400ce35fd90b2449388dc856f3052a364d22987';

/// Get all occupancies that need billing attention.
///
/// Returns a list of attention items across all occupancies and bill types.
/// Each item represents a specific bill type for an occupancy that needs attention.
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
