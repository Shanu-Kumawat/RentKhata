// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tenantsStreamHash() => r'8909a6ffc0554c19e1916d1a45c021c31de742e1';

/// Watch all tenants.
///
/// Copied from [tenantsStream].
@ProviderFor(tenantsStream)
final tenantsStreamProvider = AutoDisposeStreamProvider<List<Tenant>>.internal(
  tenantsStream,
  name: r'tenantsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tenantsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TenantsStreamRef = AutoDisposeStreamProviderRef<List<Tenant>>;
String _$tenantsHash() => r'd50d1f7b33c0a6cb3aabc8826a2625982742f921';

/// Get all tenants (future).
///
/// Copied from [tenants].
@ProviderFor(tenants)
final tenantsProvider = AutoDisposeFutureProvider<List<Tenant>>.internal(
  tenants,
  name: r'tenantsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tenantsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TenantsRef = AutoDisposeFutureProviderRef<List<Tenant>>;
String _$tenantHash() => r'd3270c318fddc76811bb7c30903087ef7af4abd5';

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

/// Get a single tenant by ID.
///
/// Copied from [tenant].
@ProviderFor(tenant)
const tenantProvider = TenantFamily();

/// Get a single tenant by ID.
///
/// Copied from [tenant].
class TenantFamily extends Family<AsyncValue<Tenant?>> {
  /// Get a single tenant by ID.
  ///
  /// Copied from [tenant].
  const TenantFamily();

  /// Get a single tenant by ID.
  ///
  /// Copied from [tenant].
  TenantProvider call(int id) {
    return TenantProvider(id);
  }

  @override
  TenantProvider getProviderOverride(covariant TenantProvider provider) {
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
  String? get name => r'tenantProvider';
}

/// Get a single tenant by ID.
///
/// Copied from [tenant].
class TenantProvider extends AutoDisposeFutureProvider<Tenant?> {
  /// Get a single tenant by ID.
  ///
  /// Copied from [tenant].
  TenantProvider(int id)
    : this._internal(
        (ref) => tenant(ref as TenantRef, id),
        from: tenantProvider,
        name: r'tenantProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tenantHash,
        dependencies: TenantFamily._dependencies,
        allTransitiveDependencies: TenantFamily._allTransitiveDependencies,
        id: id,
      );

  TenantProvider._internal(
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
  Override overrideWith(FutureOr<Tenant?> Function(TenantRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: TenantProvider._internal(
        (ref) => create(ref as TenantRef),
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
  AutoDisposeFutureProviderElement<Tenant?> createElement() {
    return _TenantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantProvider && other.id == id;
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
mixin TenantRef on AutoDisposeFutureProviderRef<Tenant?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TenantProviderElement extends AutoDisposeFutureProviderElement<Tenant?>
    with TenantRef {
  _TenantProviderElement(super.provider);

  @override
  int get id => (origin as TenantProvider).id;
}

String _$searchTenantsHash() => r'fbeb7fdd18a473aa72e1ca6c7e3fd3282f96df57';

/// Search tenants.
///
/// Copied from [searchTenants].
@ProviderFor(searchTenants)
const searchTenantsProvider = SearchTenantsFamily();

/// Search tenants.
///
/// Copied from [searchTenants].
class SearchTenantsFamily extends Family<AsyncValue<List<Tenant>>> {
  /// Search tenants.
  ///
  /// Copied from [searchTenants].
  const SearchTenantsFamily();

  /// Search tenants.
  ///
  /// Copied from [searchTenants].
  SearchTenantsProvider call(String query) {
    return SearchTenantsProvider(query);
  }

  @override
  SearchTenantsProvider getProviderOverride(
    covariant SearchTenantsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchTenantsProvider';
}

/// Search tenants.
///
/// Copied from [searchTenants].
class SearchTenantsProvider extends AutoDisposeFutureProvider<List<Tenant>> {
  /// Search tenants.
  ///
  /// Copied from [searchTenants].
  SearchTenantsProvider(String query)
    : this._internal(
        (ref) => searchTenants(ref as SearchTenantsRef, query),
        from: searchTenantsProvider,
        name: r'searchTenantsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchTenantsHash,
        dependencies: SearchTenantsFamily._dependencies,
        allTransitiveDependencies:
            SearchTenantsFamily._allTransitiveDependencies,
        query: query,
      );

  SearchTenantsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Tenant>> Function(SearchTenantsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchTenantsProvider._internal(
        (ref) => create(ref as SearchTenantsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Tenant>> createElement() {
    return _SearchTenantsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchTenantsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchTenantsRef on AutoDisposeFutureProviderRef<List<Tenant>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchTenantsProviderElement
    extends AutoDisposeFutureProviderElement<List<Tenant>>
    with SearchTenantsRef {
  _SearchTenantsProviderElement(super.provider);

  @override
  String get query => (origin as SearchTenantsProvider).query;
}

String _$customFieldsForTenantHash() =>
    r'ef024bd2aa476cc849526f3fc01c759b8b43e639';

/// Get custom fields for a tenant.
///
/// Copied from [customFieldsForTenant].
@ProviderFor(customFieldsForTenant)
const customFieldsForTenantProvider = CustomFieldsForTenantFamily();

/// Get custom fields for a tenant.
///
/// Copied from [customFieldsForTenant].
class CustomFieldsForTenantFamily
    extends Family<AsyncValue<List<CustomField>>> {
  /// Get custom fields for a tenant.
  ///
  /// Copied from [customFieldsForTenant].
  const CustomFieldsForTenantFamily();

  /// Get custom fields for a tenant.
  ///
  /// Copied from [customFieldsForTenant].
  CustomFieldsForTenantProvider call(int tenantId) {
    return CustomFieldsForTenantProvider(tenantId);
  }

  @override
  CustomFieldsForTenantProvider getProviderOverride(
    covariant CustomFieldsForTenantProvider provider,
  ) {
    return call(provider.tenantId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customFieldsForTenantProvider';
}

/// Get custom fields for a tenant.
///
/// Copied from [customFieldsForTenant].
class CustomFieldsForTenantProvider
    extends AutoDisposeFutureProvider<List<CustomField>> {
  /// Get custom fields for a tenant.
  ///
  /// Copied from [customFieldsForTenant].
  CustomFieldsForTenantProvider(int tenantId)
    : this._internal(
        (ref) =>
            customFieldsForTenant(ref as CustomFieldsForTenantRef, tenantId),
        from: customFieldsForTenantProvider,
        name: r'customFieldsForTenantProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$customFieldsForTenantHash,
        dependencies: CustomFieldsForTenantFamily._dependencies,
        allTransitiveDependencies:
            CustomFieldsForTenantFamily._allTransitiveDependencies,
        tenantId: tenantId,
      );

  CustomFieldsForTenantProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tenantId,
  }) : super.internal();

  final int tenantId;

  @override
  Override overrideWith(
    FutureOr<List<CustomField>> Function(CustomFieldsForTenantRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomFieldsForTenantProvider._internal(
        (ref) => create(ref as CustomFieldsForTenantRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tenantId: tenantId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CustomField>> createElement() {
    return _CustomFieldsForTenantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomFieldsForTenantProvider && other.tenantId == tenantId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tenantId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomFieldsForTenantRef
    on AutoDisposeFutureProviderRef<List<CustomField>> {
  /// The parameter `tenantId` of this provider.
  int get tenantId;
}

class _CustomFieldsForTenantProviderElement
    extends AutoDisposeFutureProviderElement<List<CustomField>>
    with CustomFieldsForTenantRef {
  _CustomFieldsForTenantProviderElement(super.provider);

  @override
  int get tenantId => (origin as CustomFieldsForTenantProvider).tenantId;
}

String _$activeOccupanciesStreamHash() =>
    r'c9d10a3bdd9d1e024de1da337739db48d7f6a7f4';

/// Watch active occupancies.
///
/// Copied from [activeOccupanciesStream].
@ProviderFor(activeOccupanciesStream)
final activeOccupanciesStreamProvider =
    AutoDisposeStreamProvider<List<Occupancy>>.internal(
      activeOccupanciesStream,
      name: r'activeOccupanciesStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeOccupanciesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveOccupanciesStreamRef =
    AutoDisposeStreamProviderRef<List<Occupancy>>;
String _$activeOccupanciesHash() => r'59248b69da430ac024a3baa9278bd64013ac50a2';

/// Get active occupancies.
///
/// Copied from [activeOccupancies].
@ProviderFor(activeOccupancies)
final activeOccupanciesProvider =
    AutoDisposeFutureProvider<List<Occupancy>>.internal(
      activeOccupancies,
      name: r'activeOccupanciesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeOccupanciesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveOccupanciesRef = AutoDisposeFutureProviderRef<List<Occupancy>>;
String _$occupancyForRoomHash() => r'e964f2f2a385f45e569b6de281731d9448f05787';

/// Get active occupancy for a room.
///
/// Copied from [occupancyForRoom].
@ProviderFor(occupancyForRoom)
const occupancyForRoomProvider = OccupancyForRoomFamily();

/// Get active occupancy for a room.
///
/// Copied from [occupancyForRoom].
class OccupancyForRoomFamily extends Family<AsyncValue<Occupancy?>> {
  /// Get active occupancy for a room.
  ///
  /// Copied from [occupancyForRoom].
  const OccupancyForRoomFamily();

  /// Get active occupancy for a room.
  ///
  /// Copied from [occupancyForRoom].
  OccupancyForRoomProvider call(int roomId) {
    return OccupancyForRoomProvider(roomId);
  }

  @override
  OccupancyForRoomProvider getProviderOverride(
    covariant OccupancyForRoomProvider provider,
  ) {
    return call(provider.roomId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'occupancyForRoomProvider';
}

/// Get active occupancy for a room.
///
/// Copied from [occupancyForRoom].
class OccupancyForRoomProvider extends AutoDisposeFutureProvider<Occupancy?> {
  /// Get active occupancy for a room.
  ///
  /// Copied from [occupancyForRoom].
  OccupancyForRoomProvider(int roomId)
    : this._internal(
        (ref) => occupancyForRoom(ref as OccupancyForRoomRef, roomId),
        from: occupancyForRoomProvider,
        name: r'occupancyForRoomProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$occupancyForRoomHash,
        dependencies: OccupancyForRoomFamily._dependencies,
        allTransitiveDependencies:
            OccupancyForRoomFamily._allTransitiveDependencies,
        roomId: roomId,
      );

  OccupancyForRoomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final int roomId;

  @override
  Override overrideWith(
    FutureOr<Occupancy?> Function(OccupancyForRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OccupancyForRoomProvider._internal(
        (ref) => create(ref as OccupancyForRoomRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Occupancy?> createElement() {
    return _OccupancyForRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OccupancyForRoomProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OccupancyForRoomRef on AutoDisposeFutureProviderRef<Occupancy?> {
  /// The parameter `roomId` of this provider.
  int get roomId;
}

class _OccupancyForRoomProviderElement
    extends AutoDisposeFutureProviderElement<Occupancy?>
    with OccupancyForRoomRef {
  _OccupancyForRoomProviderElement(super.provider);

  @override
  int get roomId => (origin as OccupancyForRoomProvider).roomId;
}

String _$tenantForRoomHash() => r'c0f46828529b3c5eea3b8b2359b9690e3c29a63d';

/// Get tenant for a room.
///
/// Copied from [tenantForRoom].
@ProviderFor(tenantForRoom)
const tenantForRoomProvider = TenantForRoomFamily();

/// Get tenant for a room.
///
/// Copied from [tenantForRoom].
class TenantForRoomFamily extends Family<AsyncValue<Tenant?>> {
  /// Get tenant for a room.
  ///
  /// Copied from [tenantForRoom].
  const TenantForRoomFamily();

  /// Get tenant for a room.
  ///
  /// Copied from [tenantForRoom].
  TenantForRoomProvider call(int roomId) {
    return TenantForRoomProvider(roomId);
  }

  @override
  TenantForRoomProvider getProviderOverride(
    covariant TenantForRoomProvider provider,
  ) {
    return call(provider.roomId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tenantForRoomProvider';
}

/// Get tenant for a room.
///
/// Copied from [tenantForRoom].
class TenantForRoomProvider extends AutoDisposeFutureProvider<Tenant?> {
  /// Get tenant for a room.
  ///
  /// Copied from [tenantForRoom].
  TenantForRoomProvider(int roomId)
    : this._internal(
        (ref) => tenantForRoom(ref as TenantForRoomRef, roomId),
        from: tenantForRoomProvider,
        name: r'tenantForRoomProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tenantForRoomHash,
        dependencies: TenantForRoomFamily._dependencies,
        allTransitiveDependencies:
            TenantForRoomFamily._allTransitiveDependencies,
        roomId: roomId,
      );

  TenantForRoomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final int roomId;

  @override
  Override overrideWith(
    FutureOr<Tenant?> Function(TenantForRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TenantForRoomProvider._internal(
        (ref) => create(ref as TenantForRoomRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Tenant?> createElement() {
    return _TenantForRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantForRoomProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TenantForRoomRef on AutoDisposeFutureProviderRef<Tenant?> {
  /// The parameter `roomId` of this provider.
  int get roomId;
}

class _TenantForRoomProviderElement
    extends AutoDisposeFutureProviderElement<Tenant?>
    with TenantForRoomRef {
  _TenantForRoomProviderElement(super.provider);

  @override
  int get roomId => (origin as TenantForRoomProvider).roomId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
