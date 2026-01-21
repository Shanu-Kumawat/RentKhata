// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billSettingsHash() => r'f00830007dc951d3d9fe879a44042eba5589a713';

/// Get bill settings from database.
/// Returns cached settings, auto-refreshes from stream.
///
/// Copied from [billSettings].
@ProviderFor(billSettings)
final billSettingsProvider =
    AutoDisposeFutureProvider<BillSettingsEntity>.internal(
      billSettings,
      name: r'billSettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$billSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillSettingsRef = AutoDisposeFutureProviderRef<BillSettingsEntity>;
String _$billSettingsStreamHash() =>
    r'1ac773edb02561a62b2fa6d7330b640b1ace84ae';

/// Stream bill settings for auto-refresh.
///
/// Copied from [billSettingsStream].
@ProviderFor(billSettingsStream)
final billSettingsStreamProvider =
    AutoDisposeStreamProvider<BillSettingsEntity?>.internal(
      billSettingsStream,
      name: r'billSettingsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$billSettingsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillSettingsStreamRef =
    AutoDisposeStreamProviderRef<BillSettingsEntity?>;
String _$shouldUseAnniversaryHash() =>
    r'ebb6c0649f7e17904605d8607875ff1ecb3c6f14';

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

/// Check if a bill type should use anniversary-based cycles.
///
/// Copied from [shouldUseAnniversary].
@ProviderFor(shouldUseAnniversary)
const shouldUseAnniversaryProvider = ShouldUseAnniversaryFamily();

/// Check if a bill type should use anniversary-based cycles.
///
/// Copied from [shouldUseAnniversary].
class ShouldUseAnniversaryFamily extends Family<AsyncValue<bool>> {
  /// Check if a bill type should use anniversary-based cycles.
  ///
  /// Copied from [shouldUseAnniversary].
  const ShouldUseAnniversaryFamily();

  /// Check if a bill type should use anniversary-based cycles.
  ///
  /// Copied from [shouldUseAnniversary].
  ShouldUseAnniversaryProvider call(BillType billType) {
    return ShouldUseAnniversaryProvider(billType);
  }

  @override
  ShouldUseAnniversaryProvider getProviderOverride(
    covariant ShouldUseAnniversaryProvider provider,
  ) {
    return call(provider.billType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shouldUseAnniversaryProvider';
}

/// Check if a bill type should use anniversary-based cycles.
///
/// Copied from [shouldUseAnniversary].
class ShouldUseAnniversaryProvider extends AutoDisposeFutureProvider<bool> {
  /// Check if a bill type should use anniversary-based cycles.
  ///
  /// Copied from [shouldUseAnniversary].
  ShouldUseAnniversaryProvider(BillType billType)
    : this._internal(
        (ref) => shouldUseAnniversary(ref as ShouldUseAnniversaryRef, billType),
        from: shouldUseAnniversaryProvider,
        name: r'shouldUseAnniversaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shouldUseAnniversaryHash,
        dependencies: ShouldUseAnniversaryFamily._dependencies,
        allTransitiveDependencies:
            ShouldUseAnniversaryFamily._allTransitiveDependencies,
        billType: billType,
      );

  ShouldUseAnniversaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.billType,
  }) : super.internal();

  final BillType billType;

  @override
  Override overrideWith(
    FutureOr<bool> Function(ShouldUseAnniversaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShouldUseAnniversaryProvider._internal(
        (ref) => create(ref as ShouldUseAnniversaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        billType: billType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _ShouldUseAnniversaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShouldUseAnniversaryProvider && other.billType == billType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, billType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShouldUseAnniversaryRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `billType` of this provider.
  BillType get billType;
}

class _ShouldUseAnniversaryProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with ShouldUseAnniversaryRef {
  _ShouldUseAnniversaryProviderElement(super.provider);

  @override
  BillType get billType => (origin as ShouldUseAnniversaryProvider).billType;
}

String _$billsStreamHash() => r'ff0b76a409f8781ea546384d9cda27bac2e1528a';

/// See also [billsStream].
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
String _$billsHash() => r'5d30177a5827db81d9fb2da8f8f6c0908cb253fb';

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
String _$billsForOccupancyHash() => r'bebfef601f937e7cb63a09d64ae58278b675f4cd';

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
    r'0a332992635714e05b5ab38ac93159786d97e979';

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

String _$billHash() => r'caf09a637268c302013bff4644d257bef3900532';

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

String _$billByIdHash() => r'7e268cdfa9f749d52361c0e317416414204868e5';

/// Get a bill by ID with auto-refresh (watches occupancy stream for updates).
///
/// Copied from [billById].
@ProviderFor(billById)
const billByIdProvider = BillByIdFamily();

/// Get a bill by ID with auto-refresh (watches occupancy stream for updates).
///
/// Copied from [billById].
class BillByIdFamily extends Family<AsyncValue<Bill?>> {
  /// Get a bill by ID with auto-refresh (watches occupancy stream for updates).
  ///
  /// Copied from [billById].
  const BillByIdFamily();

  /// Get a bill by ID with auto-refresh (watches occupancy stream for updates).
  ///
  /// Copied from [billById].
  BillByIdProvider call(int id) {
    return BillByIdProvider(id);
  }

  @override
  BillByIdProvider getProviderOverride(covariant BillByIdProvider provider) {
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
  String? get name => r'billByIdProvider';
}

/// Get a bill by ID with auto-refresh (watches occupancy stream for updates).
///
/// Copied from [billById].
class BillByIdProvider extends AutoDisposeFutureProvider<Bill?> {
  /// Get a bill by ID with auto-refresh (watches occupancy stream for updates).
  ///
  /// Copied from [billById].
  BillByIdProvider(int id)
    : this._internal(
        (ref) => billById(ref as BillByIdRef, id),
        from: billByIdProvider,
        name: r'billByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billByIdHash,
        dependencies: BillByIdFamily._dependencies,
        allTransitiveDependencies: BillByIdFamily._allTransitiveDependencies,
        id: id,
      );

  BillByIdProvider._internal(
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
  Override overrideWith(FutureOr<Bill?> Function(BillByIdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: BillByIdProvider._internal(
        (ref) => create(ref as BillByIdRef),
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
    return _BillByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillByIdProvider && other.id == id;
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
mixin BillByIdRef on AutoDisposeFutureProviderRef<Bill?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _BillByIdProviderElement extends AutoDisposeFutureProviderElement<Bill?>
    with BillByIdRef {
  _BillByIdProviderElement(super.provider);

  @override
  int get id => (origin as BillByIdProvider).id;
}

String _$lastElectricityBillHash() =>
    r'81a83d5b42a33e02548d0ba95f9a8fc38fb5a574';

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

String _$paymentsForBillHash() => r'3dcbfa79842c9146e70de3c02acd05b753bfd716';

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
    r'3ff0d790f488571eafff1f5b3d6527197220445a';

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

String _$unpaidBillsHash() => r'f4f09294bfc8c7e275a7deb918838a883069e465';

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
    r'bcd8591826e7088a003ccda1e9b36a0819ca6b05';

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
String _$messageTemplatesHash() => r'e933e4f476b52842aab87e83fbb0cb4c3d94edd2';

/// Get all message templates.
///
/// Copied from [messageTemplates].
@ProviderFor(messageTemplates)
final messageTemplatesProvider =
    AutoDisposeFutureProvider<List<MessageTemplate>>.internal(
      messageTemplates,
      name: r'messageTemplatesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$messageTemplatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MessageTemplatesRef =
    AutoDisposeFutureProviderRef<List<MessageTemplate>>;
String _$messageTemplatesByTypeHash() =>
    r'79b0d219c550f9ade5c64456085366209137ecf2';

/// Get message templates by type.
///
/// Copied from [messageTemplatesByType].
@ProviderFor(messageTemplatesByType)
const messageTemplatesByTypeProvider = MessageTemplatesByTypeFamily();

/// Get message templates by type.
///
/// Copied from [messageTemplatesByType].
class MessageTemplatesByTypeFamily
    extends Family<AsyncValue<List<MessageTemplate>>> {
  /// Get message templates by type.
  ///
  /// Copied from [messageTemplatesByType].
  const MessageTemplatesByTypeFamily();

  /// Get message templates by type.
  ///
  /// Copied from [messageTemplatesByType].
  MessageTemplatesByTypeProvider call(TemplateType type) {
    return MessageTemplatesByTypeProvider(type);
  }

  @override
  MessageTemplatesByTypeProvider getProviderOverride(
    covariant MessageTemplatesByTypeProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'messageTemplatesByTypeProvider';
}

/// Get message templates by type.
///
/// Copied from [messageTemplatesByType].
class MessageTemplatesByTypeProvider
    extends AutoDisposeFutureProvider<List<MessageTemplate>> {
  /// Get message templates by type.
  ///
  /// Copied from [messageTemplatesByType].
  MessageTemplatesByTypeProvider(TemplateType type)
    : this._internal(
        (ref) => messageTemplatesByType(ref as MessageTemplatesByTypeRef, type),
        from: messageTemplatesByTypeProvider,
        name: r'messageTemplatesByTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$messageTemplatesByTypeHash,
        dependencies: MessageTemplatesByTypeFamily._dependencies,
        allTransitiveDependencies:
            MessageTemplatesByTypeFamily._allTransitiveDependencies,
        type: type,
      );

  MessageTemplatesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final TemplateType type;

  @override
  Override overrideWith(
    FutureOr<List<MessageTemplate>> Function(MessageTemplatesByTypeRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessageTemplatesByTypeProvider._internal(
        (ref) => create(ref as MessageTemplatesByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MessageTemplate>> createElement() {
    return _MessageTemplatesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageTemplatesByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessageTemplatesByTypeRef
    on AutoDisposeFutureProviderRef<List<MessageTemplate>> {
  /// The parameter `type` of this provider.
  TemplateType get type;
}

class _MessageTemplatesByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<MessageTemplate>>
    with MessageTemplatesByTypeRef {
  _MessageTemplatesByTypeProviderElement(super.provider);

  @override
  TemplateType get type => (origin as MessageTemplatesByTypeProvider).type;
}

String _$auditLogsForBillHash() => r'cdc82884884abe7699981bf6ea1f3c913b9c1ae0';

/// Get audit logs for a bill.
///
/// Copied from [auditLogsForBill].
@ProviderFor(auditLogsForBill)
const auditLogsForBillProvider = AuditLogsForBillFamily();

/// Get audit logs for a bill.
///
/// Copied from [auditLogsForBill].
class AuditLogsForBillFamily extends Family<AsyncValue<List<AuditLog>>> {
  /// Get audit logs for a bill.
  ///
  /// Copied from [auditLogsForBill].
  const AuditLogsForBillFamily();

  /// Get audit logs for a bill.
  ///
  /// Copied from [auditLogsForBill].
  AuditLogsForBillProvider call(int billId) {
    return AuditLogsForBillProvider(billId);
  }

  @override
  AuditLogsForBillProvider getProviderOverride(
    covariant AuditLogsForBillProvider provider,
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
  String? get name => r'auditLogsForBillProvider';
}

/// Get audit logs for a bill.
///
/// Copied from [auditLogsForBill].
class AuditLogsForBillProvider
    extends AutoDisposeFutureProvider<List<AuditLog>> {
  /// Get audit logs for a bill.
  ///
  /// Copied from [auditLogsForBill].
  AuditLogsForBillProvider(int billId)
    : this._internal(
        (ref) => auditLogsForBill(ref as AuditLogsForBillRef, billId),
        from: auditLogsForBillProvider,
        name: r'auditLogsForBillProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$auditLogsForBillHash,
        dependencies: AuditLogsForBillFamily._dependencies,
        allTransitiveDependencies:
            AuditLogsForBillFamily._allTransitiveDependencies,
        billId: billId,
      );

  AuditLogsForBillProvider._internal(
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
    FutureOr<List<AuditLog>> Function(AuditLogsForBillRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuditLogsForBillProvider._internal(
        (ref) => create(ref as AuditLogsForBillRef),
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
  AutoDisposeFutureProviderElement<List<AuditLog>> createElement() {
    return _AuditLogsForBillProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsForBillProvider && other.billId == billId;
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
mixin AuditLogsForBillRef on AutoDisposeFutureProviderRef<List<AuditLog>> {
  /// The parameter `billId` of this provider.
  int get billId;
}

class _AuditLogsForBillProviderElement
    extends AutoDisposeFutureProviderElement<List<AuditLog>>
    with AuditLogsForBillRef {
  _AuditLogsForBillProviderElement(super.provider);

  @override
  int get billId => (origin as AuditLogsForBillProvider).billId;
}

String _$defaultTemplateHash() => r'8d592664788b2bc46106a4a88e31c89ebd458bb8';

/// Get default message template for a type.
///
/// Copied from [defaultTemplate].
@ProviderFor(defaultTemplate)
const defaultTemplateProvider = DefaultTemplateFamily();

/// Get default message template for a type.
///
/// Copied from [defaultTemplate].
class DefaultTemplateFamily extends Family<AsyncValue<MessageTemplate?>> {
  /// Get default message template for a type.
  ///
  /// Copied from [defaultTemplate].
  const DefaultTemplateFamily();

  /// Get default message template for a type.
  ///
  /// Copied from [defaultTemplate].
  DefaultTemplateProvider call(TemplateType type) {
    return DefaultTemplateProvider(type);
  }

  @override
  DefaultTemplateProvider getProviderOverride(
    covariant DefaultTemplateProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'defaultTemplateProvider';
}

/// Get default message template for a type.
///
/// Copied from [defaultTemplate].
class DefaultTemplateProvider
    extends AutoDisposeFutureProvider<MessageTemplate?> {
  /// Get default message template for a type.
  ///
  /// Copied from [defaultTemplate].
  DefaultTemplateProvider(TemplateType type)
    : this._internal(
        (ref) => defaultTemplate(ref as DefaultTemplateRef, type),
        from: defaultTemplateProvider,
        name: r'defaultTemplateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$defaultTemplateHash,
        dependencies: DefaultTemplateFamily._dependencies,
        allTransitiveDependencies:
            DefaultTemplateFamily._allTransitiveDependencies,
        type: type,
      );

  DefaultTemplateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final TemplateType type;

  @override
  Override overrideWith(
    FutureOr<MessageTemplate?> Function(DefaultTemplateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DefaultTemplateProvider._internal(
        (ref) => create(ref as DefaultTemplateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MessageTemplate?> createElement() {
    return _DefaultTemplateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultTemplateProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DefaultTemplateRef on AutoDisposeFutureProviderRef<MessageTemplate?> {
  /// The parameter `type` of this provider.
  TemplateType get type;
}

class _DefaultTemplateProviderElement
    extends AutoDisposeFutureProviderElement<MessageTemplate?>
    with DefaultTemplateRef {
  _DefaultTemplateProviderElement(super.provider);

  @override
  TemplateType get type => (origin as DefaultTemplateProvider).type;
}

String _$templateServiceHash() => r'6e667e81a46f403232acd5b8956373cd4f5f414d';

/// Provider for TemplateService.
///
/// Copied from [templateService].
@ProviderFor(templateService)
final templateServiceProvider = AutoDisposeProvider<TemplateService>.internal(
  templateService,
  name: r'templateServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TemplateServiceRef = AutoDisposeProviderRef<TemplateService>;
String _$ensureDefaultTemplatesHash() =>
    r'f3d35b837cadf965db80a18792dc3740d829dab8';

/// Ensures default templates exist. Call this during app initialization.
/// Returns true when complete.
///
/// Copied from [ensureDefaultTemplates].
@ProviderFor(ensureDefaultTemplates)
final ensureDefaultTemplatesProvider = AutoDisposeFutureProvider<bool>.internal(
  ensureDefaultTemplates,
  name: r'ensureDefaultTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ensureDefaultTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnsureDefaultTemplatesRef = AutoDisposeFutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
