// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billsStreamHash() => r'1be27f6281a0a5703bacc454d806409a58e9f922';

/// Watch all bills (auto-updates).
///
/// Copied from [billsStream].
@ProviderFor(billsStream)
final billsStreamProvider = AutoDisposeStreamProvider<List<Bill>>.internal(
  billsStream,
  name: r'billsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$billsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillsStreamRef = AutoDisposeStreamProviderRef<List<Bill>>;
String _$billsHash() => r'10b00ecfa32c830218199a29fa5d5aaa97b7faa5';

/// Get all bills.
/// Auto-refreshes when the stream emits.
///
/// Copied from [bills].
@ProviderFor(bills)
final billsProvider = AutoDisposeFutureProvider<List<Bill>>.internal(
  bills,
  name: r'billsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$billsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillsRef = AutoDisposeFutureProviderRef<List<Bill>>;
String _$billsForOccupancyHash() => r'2f81eebe1ad36b615a590fb6e0f1db5738d78ab1';

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

/// Get bills for an occupancy.
/// Auto-refreshes by watching the stream.
///
/// Copied from [billsForOccupancy].
@ProviderFor(billsForOccupancy)
const billsForOccupancyProvider = BillsForOccupancyFamily();

/// Get bills for an occupancy.
/// Auto-refreshes by watching the stream.
///
/// Copied from [billsForOccupancy].
class BillsForOccupancyFamily extends Family<AsyncValue<List<Bill>>> {
  /// Get bills for an occupancy.
  /// Auto-refreshes by watching the stream.
  ///
  /// Copied from [billsForOccupancy].
  const BillsForOccupancyFamily();

  /// Get bills for an occupancy.
  /// Auto-refreshes by watching the stream.
  ///
  /// Copied from [billsForOccupancy].
  BillsForOccupancyProvider call(int occupancyId) {
    return BillsForOccupancyProvider(occupancyId);
  }

  @override
  BillsForOccupancyProvider getProviderOverride(
    covariant BillsForOccupancyProvider provider,
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
  String? get name => r'billsForOccupancyProvider';
}

/// Get bills for an occupancy.
/// Auto-refreshes by watching the stream.
///
/// Copied from [billsForOccupancy].
class BillsForOccupancyProvider extends AutoDisposeFutureProvider<List<Bill>> {
  /// Get bills for an occupancy.
  /// Auto-refreshes by watching the stream.
  ///
  /// Copied from [billsForOccupancy].
  BillsForOccupancyProvider(int occupancyId)
    : this._internal(
        (ref) => billsForOccupancy(ref as BillsForOccupancyRef, occupancyId),
        from: billsForOccupancyProvider,
        name: r'billsForOccupancyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billsForOccupancyHash,
        dependencies: BillsForOccupancyFamily._dependencies,
        allTransitiveDependencies:
            BillsForOccupancyFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  BillsForOccupancyProvider._internal(
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
    FutureOr<List<Bill>> Function(BillsForOccupancyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BillsForOccupancyProvider._internal(
        (ref) => create(ref as BillsForOccupancyRef),
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
  AutoDisposeFutureProviderElement<List<Bill>> createElement() {
    return _BillsForOccupancyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillsForOccupancyProvider &&
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
mixin BillsForOccupancyRef on AutoDisposeFutureProviderRef<List<Bill>> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _BillsForOccupancyProviderElement
    extends AutoDisposeFutureProviderElement<List<Bill>>
    with BillsForOccupancyRef {
  _BillsForOccupancyProviderElement(super.provider);

  @override
  int get occupancyId => (origin as BillsForOccupancyProvider).occupancyId;
}

String _$billsForOccupancyStreamHash() =>
    r'6109c2f5a474858cc4bf1948fd8939d1ead6105b';

/// Watch bills for an occupancy (auto-updates).
///
/// Copied from [billsForOccupancyStream].
@ProviderFor(billsForOccupancyStream)
const billsForOccupancyStreamProvider = BillsForOccupancyStreamFamily();

/// Watch bills for an occupancy (auto-updates).
///
/// Copied from [billsForOccupancyStream].
class BillsForOccupancyStreamFamily extends Family<AsyncValue<List<Bill>>> {
  /// Watch bills for an occupancy (auto-updates).
  ///
  /// Copied from [billsForOccupancyStream].
  const BillsForOccupancyStreamFamily();

  /// Watch bills for an occupancy (auto-updates).
  ///
  /// Copied from [billsForOccupancyStream].
  BillsForOccupancyStreamProvider call(int occupancyId) {
    return BillsForOccupancyStreamProvider(occupancyId);
  }

  @override
  BillsForOccupancyStreamProvider getProviderOverride(
    covariant BillsForOccupancyStreamProvider provider,
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
  String? get name => r'billsForOccupancyStreamProvider';
}

/// Watch bills for an occupancy (auto-updates).
///
/// Copied from [billsForOccupancyStream].
class BillsForOccupancyStreamProvider
    extends AutoDisposeStreamProvider<List<Bill>> {
  /// Watch bills for an occupancy (auto-updates).
  ///
  /// Copied from [billsForOccupancyStream].
  BillsForOccupancyStreamProvider(int occupancyId)
    : this._internal(
        (ref) => billsForOccupancyStream(
          ref as BillsForOccupancyStreamRef,
          occupancyId,
        ),
        from: billsForOccupancyStreamProvider,
        name: r'billsForOccupancyStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billsForOccupancyStreamHash,
        dependencies: BillsForOccupancyStreamFamily._dependencies,
        allTransitiveDependencies:
            BillsForOccupancyStreamFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  BillsForOccupancyStreamProvider._internal(
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
    Stream<List<Bill>> Function(BillsForOccupancyStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BillsForOccupancyStreamProvider._internal(
        (ref) => create(ref as BillsForOccupancyStreamRef),
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
  AutoDisposeStreamProviderElement<List<Bill>> createElement() {
    return _BillsForOccupancyStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillsForOccupancyStreamProvider &&
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
mixin BillsForOccupancyStreamRef on AutoDisposeStreamProviderRef<List<Bill>> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _BillsForOccupancyStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Bill>>
    with BillsForOccupancyStreamRef {
  _BillsForOccupancyStreamProviderElement(super.provider);

  @override
  int get occupancyId =>
      (origin as BillsForOccupancyStreamProvider).occupancyId;
}

String _$billHash() => r'8ae456dfd51632354ddf35c05ca7107bc833865d';

/// Get a single bill by ID.
///
/// Copied from [bill].
@ProviderFor(bill)
const billProvider = BillFamily();

/// Get a single bill by ID.
///
/// Copied from [bill].
class BillFamily extends Family<AsyncValue<Bill?>> {
  /// Get a single bill by ID.
  ///
  /// Copied from [bill].
  const BillFamily();

  /// Get a single bill by ID.
  ///
  /// Copied from [bill].
  BillProvider call(int id) {
    return BillProvider(id);
  }

  @override
  BillProvider getProviderOverride(covariant BillProvider provider) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'billProvider';
}

/// Get a single bill by ID.
///
/// Copied from [bill].
class BillProvider extends AutoDisposeFutureProvider<Bill?> {
  /// Get a single bill by ID.
  ///
  /// Copied from [bill].
  BillProvider(int id)
    : this._internal(
        (ref) => bill(ref as BillRef, id),
        from: billProvider,
        name: r'billProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billHash,
        dependencies: BillFamily._dependencies,
        allTransitiveDependencies: BillFamily._allTransitiveDependencies,
        id: id,
      );

  BillProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(FutureOr<Bill?> Function(BillRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: BillProvider._internal(
        (ref) => create(ref as BillRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Bill?> createElement() {
    return _BillProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BillRef on AutoDisposeFutureProviderRef<Bill?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _BillProviderElement extends AutoDisposeFutureProviderElement<Bill?>
    with BillRef {
  _BillProviderElement(super.provider);

  @override
  int get id => (origin as BillProvider).id;
}

String _$lastElectricityBillHash() =>
    r'0ac034121c904e40309bde904f4f3b173ff71008';

/// Get last electricity bill for auto-fill.
///
/// Copied from [lastElectricityBill].
@ProviderFor(lastElectricityBill)
const lastElectricityBillProvider = LastElectricityBillFamily();

/// Get last electricity bill for auto-fill.
///
/// Copied from [lastElectricityBill].
class LastElectricityBillFamily extends Family<AsyncValue<Bill?>> {
  /// Get last electricity bill for auto-fill.
  ///
  /// Copied from [lastElectricityBill].
  const LastElectricityBillFamily();

  /// Get last electricity bill for auto-fill.
  ///
  /// Copied from [lastElectricityBill].
  LastElectricityBillProvider call(int occupancyId) {
    return LastElectricityBillProvider(occupancyId);
  }

  @override
  LastElectricityBillProvider getProviderOverride(
    covariant LastElectricityBillProvider provider,
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
  String? get name => r'lastElectricityBillProvider';
}

/// Get last electricity bill for auto-fill.
///
/// Copied from [lastElectricityBill].
class LastElectricityBillProvider extends AutoDisposeFutureProvider<Bill?> {
  /// Get last electricity bill for auto-fill.
  ///
  /// Copied from [lastElectricityBill].
  LastElectricityBillProvider(int occupancyId)
    : this._internal(
        (ref) =>
            lastElectricityBill(ref as LastElectricityBillRef, occupancyId),
        from: lastElectricityBillProvider,
        name: r'lastElectricityBillProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$lastElectricityBillHash,
        dependencies: LastElectricityBillFamily._dependencies,
        allTransitiveDependencies:
            LastElectricityBillFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  LastElectricityBillProvider._internal(
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
    FutureOr<Bill?> Function(LastElectricityBillRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LastElectricityBillProvider._internal(
        (ref) => create(ref as LastElectricityBillRef),
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
  AutoDisposeFutureProviderElement<Bill?> createElement() {
    return _LastElectricityBillProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LastElectricityBillProvider &&
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
mixin LastElectricityBillRef on AutoDisposeFutureProviderRef<Bill?> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _LastElectricityBillProviderElement
    extends AutoDisposeFutureProviderElement<Bill?>
    with LastElectricityBillRef {
  _LastElectricityBillProviderElement(super.provider);

  @override
  int get occupancyId => (origin as LastElectricityBillProvider).occupancyId;
}

String _$paymentsForBillHash() => r'c6e4fbc40b47f657ab0f2706f58405988ae07c02';

/// Get payments for a bill.
/// Auto-refreshes by watching the stream.
///
/// Copied from [paymentsForBill].
@ProviderFor(paymentsForBill)
const paymentsForBillProvider = PaymentsForBillFamily();

/// Get payments for a bill.
/// Auto-refreshes by watching the stream.
///
/// Copied from [paymentsForBill].
class PaymentsForBillFamily extends Family<AsyncValue<List<Payment>>> {
  /// Get payments for a bill.
  /// Auto-refreshes by watching the stream.
  ///
  /// Copied from [paymentsForBill].
  const PaymentsForBillFamily();

  /// Get payments for a bill.
  /// Auto-refreshes by watching the stream.
  ///
  /// Copied from [paymentsForBill].
  PaymentsForBillProvider call(int billId) {
    return PaymentsForBillProvider(billId);
  }

  @override
  PaymentsForBillProvider getProviderOverride(
    covariant PaymentsForBillProvider provider,
  ) {
    return call(provider.billId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paymentsForBillProvider';
}

/// Get payments for a bill.
/// Auto-refreshes by watching the stream.
///
/// Copied from [paymentsForBill].
class PaymentsForBillProvider extends AutoDisposeFutureProvider<List<Payment>> {
  /// Get payments for a bill.
  /// Auto-refreshes by watching the stream.
  ///
  /// Copied from [paymentsForBill].
  PaymentsForBillProvider(int billId)
    : this._internal(
        (ref) => paymentsForBill(ref as PaymentsForBillRef, billId),
        from: paymentsForBillProvider,
        name: r'paymentsForBillProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$paymentsForBillHash,
        dependencies: PaymentsForBillFamily._dependencies,
        allTransitiveDependencies:
            PaymentsForBillFamily._allTransitiveDependencies,
        billId: billId,
      );

  PaymentsForBillProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.billId,
  }) : super.internal();

  final int billId;

  @override
  Override overrideWith(
    FutureOr<List<Payment>> Function(PaymentsForBillRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentsForBillProvider._internal(
        (ref) => create(ref as PaymentsForBillRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        billId: billId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Payment>> createElement() {
    return _PaymentsForBillProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentsForBillProvider && other.billId == billId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, billId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaymentsForBillRef on AutoDisposeFutureProviderRef<List<Payment>> {
  /// The parameter `billId` of this provider.
  int get billId;
}

class _PaymentsForBillProviderElement
    extends AutoDisposeFutureProviderElement<List<Payment>>
    with PaymentsForBillRef {
  _PaymentsForBillProviderElement(super.provider);

  @override
  int get billId => (origin as PaymentsForBillProvider).billId;
}

String _$paymentsForBillStreamHash() =>
    r'35a9d0959d5c12dd00f0a0e28192ee9a94b99ae0';

/// Watch payments for a bill (auto-updates).
///
/// Copied from [paymentsForBillStream].
@ProviderFor(paymentsForBillStream)
const paymentsForBillStreamProvider = PaymentsForBillStreamFamily();

/// Watch payments for a bill (auto-updates).
///
/// Copied from [paymentsForBillStream].
class PaymentsForBillStreamFamily extends Family<AsyncValue<List<Payment>>> {
  /// Watch payments for a bill (auto-updates).
  ///
  /// Copied from [paymentsForBillStream].
  const PaymentsForBillStreamFamily();

  /// Watch payments for a bill (auto-updates).
  ///
  /// Copied from [paymentsForBillStream].
  PaymentsForBillStreamProvider call(int billId) {
    return PaymentsForBillStreamProvider(billId);
  }

  @override
  PaymentsForBillStreamProvider getProviderOverride(
    covariant PaymentsForBillStreamProvider provider,
  ) {
    return call(provider.billId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paymentsForBillStreamProvider';
}

/// Watch payments for a bill (auto-updates).
///
/// Copied from [paymentsForBillStream].
class PaymentsForBillStreamProvider
    extends AutoDisposeStreamProvider<List<Payment>> {
  /// Watch payments for a bill (auto-updates).
  ///
  /// Copied from [paymentsForBillStream].
  PaymentsForBillStreamProvider(int billId)
    : this._internal(
        (ref) => paymentsForBillStream(ref as PaymentsForBillStreamRef, billId),
        from: paymentsForBillStreamProvider,
        name: r'paymentsForBillStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$paymentsForBillStreamHash,
        dependencies: PaymentsForBillStreamFamily._dependencies,
        allTransitiveDependencies:
            PaymentsForBillStreamFamily._allTransitiveDependencies,
        billId: billId,
      );

  PaymentsForBillStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.billId,
  }) : super.internal();

  final int billId;

  @override
  Override overrideWith(
    Stream<List<Payment>> Function(PaymentsForBillStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentsForBillStreamProvider._internal(
        (ref) => create(ref as PaymentsForBillStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        billId: billId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Payment>> createElement() {
    return _PaymentsForBillStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentsForBillStreamProvider && other.billId == billId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, billId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaymentsForBillStreamRef on AutoDisposeStreamProviderRef<List<Payment>> {
  /// The parameter `billId` of this provider.
  int get billId;
}

class _PaymentsForBillStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Payment>>
    with PaymentsForBillStreamRef {
  _PaymentsForBillStreamProviderElement(super.provider);

  @override
  int get billId => (origin as PaymentsForBillStreamProvider).billId;
}

String _$unpaidBillsHash() => r'55b62459f26e48b1553254e5e9b649ef983b11d8';

/// Get unpaid bills.
/// Auto-refreshes via periodic check.
///
/// Copied from [unpaidBills].
@ProviderFor(unpaidBills)
final unpaidBillsProvider = AutoDisposeFutureProvider<List<Bill>>.internal(
  unpaidBills,
  name: r'unpaidBillsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unpaidBillsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnpaidBillsRef = AutoDisposeFutureProviderRef<List<Bill>>;
String _$currentElectricityRateHash() =>
    r'6dff93d283469f7712f205091374139047ef441a';

/// Get current electricity rate.
///
/// Copied from [currentElectricityRate].
@ProviderFor(currentElectricityRate)
final currentElectricityRateProvider =
    AutoDisposeFutureProvider<double>.internal(
      currentElectricityRate,
      name: r'currentElectricityRateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentElectricityRateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentElectricityRateRef = AutoDisposeFutureProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
