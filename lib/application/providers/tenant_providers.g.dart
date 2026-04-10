// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tenantsStreamHash() => r'18a4fb419c8bc4984f9b3856bb77f2b53a474283';

/// Watch all tenants (auto-updates when data changes).
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
String _$tenantsHash() => r'f996f116e03f8649e5617715f76dfb6a0136541b';

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
String _$tenantHash() => r'f9720b1f62257995bdd0633fee46cef003acac52';

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
/// This provider auto-refreshes when tenantsStream emits new data.
///
/// Copied from [tenant].
@ProviderFor(tenant)
const tenantProvider = TenantFamily();

/// Get a single tenant by ID.
/// This provider auto-refreshes when tenantsStream emits new data.
///
/// Copied from [tenant].
class TenantFamily extends Family<AsyncValue<Tenant?>> {
  /// Get a single tenant by ID.
  /// This provider auto-refreshes when tenantsStream emits new data.
  ///
  /// Copied from [tenant].
  const TenantFamily();

  /// Get a single tenant by ID.
  /// This provider auto-refreshes when tenantsStream emits new data.
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
/// This provider auto-refreshes when tenantsStream emits new data.
///
/// Copied from [tenant].
class TenantProvider extends AutoDisposeFutureProvider<Tenant?> {
  /// Get a single tenant by ID.
  /// This provider auto-refreshes when tenantsStream emits new data.
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

String _$searchTenantsHash() => r'e97fd7d47f44992282b1e11be0a047cde08eb307';

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
    r'e5b07e3da553b91742556c860c0bdbb001e6191c';

/// Get custom fields for a tenant.
/// This auto-refreshes when tenants change.
///
/// Copied from [customFieldsForTenant].
@ProviderFor(customFieldsForTenant)
const customFieldsForTenantProvider = CustomFieldsForTenantFamily();

/// Get custom fields for a tenant.
/// This auto-refreshes when tenants change.
///
/// Copied from [customFieldsForTenant].
class CustomFieldsForTenantFamily
    extends Family<AsyncValue<List<CustomField>>> {
  /// Get custom fields for a tenant.
  /// This auto-refreshes when tenants change.
  ///
  /// Copied from [customFieldsForTenant].
  const CustomFieldsForTenantFamily();

  /// Get custom fields for a tenant.
  /// This auto-refreshes when tenants change.
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
/// This auto-refreshes when tenants change.
///
/// Copied from [customFieldsForTenant].
class CustomFieldsForTenantProvider
    extends AutoDisposeFutureProvider<List<CustomField>> {
  /// Get custom fields for a tenant.
  /// This auto-refreshes when tenants change.
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
    r'fef19a0f82cc6dc455463c3a9e93266603fa4b82';

/// Watch active occupancies (auto-updates when data changes).
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
String _$activeOccupanciesHash() => r'3b207c06e9645f041894acd667422224984a86da';

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
String _$tenantOccupancyHistoryHash() =>
    r'337d703520f192eb55b7ef39058f8d269595db5b';

/// See also [tenantOccupancyHistory].
@ProviderFor(tenantOccupancyHistory)
const tenantOccupancyHistoryProvider = TenantOccupancyHistoryFamily();

/// See also [tenantOccupancyHistory].
class TenantOccupancyHistoryFamily extends Family<AsyncValue<List<Occupancy>>> {
  /// See also [tenantOccupancyHistory].
  const TenantOccupancyHistoryFamily();

  /// See also [tenantOccupancyHistory].
  TenantOccupancyHistoryProvider call(int tenantId) {
    return TenantOccupancyHistoryProvider(tenantId);
  }

  @override
  TenantOccupancyHistoryProvider getProviderOverride(
    covariant TenantOccupancyHistoryProvider provider,
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
  String? get name => r'tenantOccupancyHistoryProvider';
}

/// See also [tenantOccupancyHistory].
class TenantOccupancyHistoryProvider
    extends AutoDisposeFutureProvider<List<Occupancy>> {
  /// See also [tenantOccupancyHistory].
  TenantOccupancyHistoryProvider(int tenantId)
    : this._internal(
        (ref) =>
            tenantOccupancyHistory(ref as TenantOccupancyHistoryRef, tenantId),
        from: tenantOccupancyHistoryProvider,
        name: r'tenantOccupancyHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tenantOccupancyHistoryHash,
        dependencies: TenantOccupancyHistoryFamily._dependencies,
        allTransitiveDependencies:
            TenantOccupancyHistoryFamily._allTransitiveDependencies,
        tenantId: tenantId,
      );

  TenantOccupancyHistoryProvider._internal(
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
    FutureOr<List<Occupancy>> Function(TenantOccupancyHistoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TenantOccupancyHistoryProvider._internal(
        (ref) => create(ref as TenantOccupancyHistoryRef),
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
  AutoDisposeFutureProviderElement<List<Occupancy>> createElement() {
    return _TenantOccupancyHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantOccupancyHistoryProvider &&
        other.tenantId == tenantId;
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
mixin TenantOccupancyHistoryRef
    on AutoDisposeFutureProviderRef<List<Occupancy>> {
  /// The parameter `tenantId` of this provider.
  int get tenantId;
}

class _TenantOccupancyHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Occupancy>>
    with TenantOccupancyHistoryRef {
  _TenantOccupancyHistoryProviderElement(super.provider);

  @override
  int get tenantId => (origin as TenantOccupancyHistoryProvider).tenantId;
}

String _$tenantDocumentsHash() => r'92d4841f8b76a6e83c7c11bfe84bb874116dce7d';

/// See also [tenantDocuments].
@ProviderFor(tenantDocuments)
const tenantDocumentsProvider = TenantDocumentsFamily();

/// See also [tenantDocuments].
class TenantDocumentsFamily extends Family<AsyncValue<List<Document>>> {
  /// See also [tenantDocuments].
  const TenantDocumentsFamily();

  /// See also [tenantDocuments].
  TenantDocumentsProvider call(int tenantId) {
    return TenantDocumentsProvider(tenantId);
  }

  @override
  TenantDocumentsProvider getProviderOverride(
    covariant TenantDocumentsProvider provider,
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
  String? get name => r'tenantDocumentsProvider';
}

/// See also [tenantDocuments].
class TenantDocumentsProvider
    extends AutoDisposeFutureProvider<List<Document>> {
  /// See also [tenantDocuments].
  TenantDocumentsProvider(int tenantId)
    : this._internal(
        (ref) => tenantDocuments(ref as TenantDocumentsRef, tenantId),
        from: tenantDocumentsProvider,
        name: r'tenantDocumentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tenantDocumentsHash,
        dependencies: TenantDocumentsFamily._dependencies,
        allTransitiveDependencies:
            TenantDocumentsFamily._allTransitiveDependencies,
        tenantId: tenantId,
      );

  TenantDocumentsProvider._internal(
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
    FutureOr<List<Document>> Function(TenantDocumentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TenantDocumentsProvider._internal(
        (ref) => create(ref as TenantDocumentsRef),
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
  AutoDisposeFutureProviderElement<List<Document>> createElement() {
    return _TenantDocumentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantDocumentsProvider && other.tenantId == tenantId;
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
mixin TenantDocumentsRef on AutoDisposeFutureProviderRef<List<Document>> {
  /// The parameter `tenantId` of this provider.
  int get tenantId;
}

class _TenantDocumentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Document>>
    with TenantDocumentsRef {
  _TenantDocumentsProviderElement(super.provider);

  @override
  int get tenantId => (origin as TenantDocumentsProvider).tenantId;
}

String _$occupancyForRoomHash() => r'a1f004987a9967048321fc7a173f7310a4d62ea8';

/// Get active occupancy for a room.
/// This provider auto-refreshes when occupancy data changes.
///
/// Copied from [occupancyForRoom].
@ProviderFor(occupancyForRoom)
const occupancyForRoomProvider = OccupancyForRoomFamily();

/// Get active occupancy for a room.
/// This provider auto-refreshes when occupancy data changes.
///
/// Copied from [occupancyForRoom].
class OccupancyForRoomFamily extends Family<AsyncValue<Occupancy?>> {
  /// Get active occupancy for a room.
  /// This provider auto-refreshes when occupancy data changes.
  ///
  /// Copied from [occupancyForRoom].
  const OccupancyForRoomFamily();

  /// Get active occupancy for a room.
  /// This provider auto-refreshes when occupancy data changes.
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
/// This provider auto-refreshes when occupancy data changes.
///
/// Copied from [occupancyForRoom].
class OccupancyForRoomProvider extends AutoDisposeFutureProvider<Occupancy?> {
  /// Get active occupancy for a room.
  /// This provider auto-refreshes when occupancy data changes.
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

String _$tenantForRoomHash() => r'b778d52bae27778a34748146eb19073eb001ef4d';

/// Get tenant for a room.
/// This provider auto-refreshes when tenant data changes.
///
/// Copied from [tenantForRoom].
@ProviderFor(tenantForRoom)
const tenantForRoomProvider = TenantForRoomFamily();

/// Get tenant for a room.
/// This provider auto-refreshes when tenant data changes.
///
/// Copied from [tenantForRoom].
class TenantForRoomFamily extends Family<AsyncValue<Tenant?>> {
  /// Get tenant for a room.
  /// This provider auto-refreshes when tenant data changes.
  ///
  /// Copied from [tenantForRoom].
  const TenantForRoomFamily();

  /// Get tenant for a room.
  /// This provider auto-refreshes when tenant data changes.
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
/// This provider auto-refreshes when tenant data changes.
///
/// Copied from [tenantForRoom].
class TenantForRoomProvider extends AutoDisposeFutureProvider<Tenant?> {
  /// Get tenant for a room.
  /// This provider auto-refreshes when tenant data changes.
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

String _$familyMembersForTenantHash() =>
    r'6bbff3cfcfccbef793adafd3faa575b0da0404e1';

/// Stream of family members for a tenant's current active occupancy.
///
/// Copied from [familyMembersForTenant].
@ProviderFor(familyMembersForTenant)
const familyMembersForTenantProvider = FamilyMembersForTenantFamily();

/// Stream of family members for a tenant's current active occupancy.
///
/// Copied from [familyMembersForTenant].
class FamilyMembersForTenantFamily
    extends Family<AsyncValue<List<FamilyMemberEntity>>> {
  /// Stream of family members for a tenant's current active occupancy.
  ///
  /// Copied from [familyMembersForTenant].
  const FamilyMembersForTenantFamily();

  /// Stream of family members for a tenant's current active occupancy.
  ///
  /// Copied from [familyMembersForTenant].
  FamilyMembersForTenantProvider call(int tenantId) {
    return FamilyMembersForTenantProvider(tenantId);
  }

  @override
  FamilyMembersForTenantProvider getProviderOverride(
    covariant FamilyMembersForTenantProvider provider,
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
  String? get name => r'familyMembersForTenantProvider';
}

/// Stream of family members for a tenant's current active occupancy.
///
/// Copied from [familyMembersForTenant].
class FamilyMembersForTenantProvider
    extends AutoDisposeStreamProvider<List<FamilyMemberEntity>> {
  /// Stream of family members for a tenant's current active occupancy.
  ///
  /// Copied from [familyMembersForTenant].
  FamilyMembersForTenantProvider(int tenantId)
    : this._internal(
        (ref) =>
            familyMembersForTenant(ref as FamilyMembersForTenantRef, tenantId),
        from: familyMembersForTenantProvider,
        name: r'familyMembersForTenantProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$familyMembersForTenantHash,
        dependencies: FamilyMembersForTenantFamily._dependencies,
        allTransitiveDependencies:
            FamilyMembersForTenantFamily._allTransitiveDependencies,
        tenantId: tenantId,
      );

  FamilyMembersForTenantProvider._internal(
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
    Stream<List<FamilyMemberEntity>> Function(
      FamilyMembersForTenantRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FamilyMembersForTenantProvider._internal(
        (ref) => create(ref as FamilyMembersForTenantRef),
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
  AutoDisposeStreamProviderElement<List<FamilyMemberEntity>> createElement() {
    return _FamilyMembersForTenantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyMembersForTenantProvider &&
        other.tenantId == tenantId;
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
mixin FamilyMembersForTenantRef
    on AutoDisposeStreamProviderRef<List<FamilyMemberEntity>> {
  /// The parameter `tenantId` of this provider.
  int get tenantId;
}

class _FamilyMembersForTenantProviderElement
    extends AutoDisposeStreamProviderElement<List<FamilyMemberEntity>>
    with FamilyMembersForTenantRef {
  _FamilyMembersForTenantProviderElement(super.provider);

  @override
  int get tenantId => (origin as FamilyMembersForTenantProvider).tenantId;
}

String _$familyMembersForOccupancyHash() =>
    r'486067aee9087e0b819512e1f732324f5608de49';

/// Stream of family members for a specific occupancy.
/// This is the primary way to get family members in the occupancy-centric architecture.
///
/// Copied from [familyMembersForOccupancy].
@ProviderFor(familyMembersForOccupancy)
const familyMembersForOccupancyProvider = FamilyMembersForOccupancyFamily();

/// Stream of family members for a specific occupancy.
/// This is the primary way to get family members in the occupancy-centric architecture.
///
/// Copied from [familyMembersForOccupancy].
class FamilyMembersForOccupancyFamily
    extends Family<AsyncValue<List<FamilyMemberEntity>>> {
  /// Stream of family members for a specific occupancy.
  /// This is the primary way to get family members in the occupancy-centric architecture.
  ///
  /// Copied from [familyMembersForOccupancy].
  const FamilyMembersForOccupancyFamily();

  /// Stream of family members for a specific occupancy.
  /// This is the primary way to get family members in the occupancy-centric architecture.
  ///
  /// Copied from [familyMembersForOccupancy].
  FamilyMembersForOccupancyProvider call(int occupancyId) {
    return FamilyMembersForOccupancyProvider(occupancyId);
  }

  @override
  FamilyMembersForOccupancyProvider getProviderOverride(
    covariant FamilyMembersForOccupancyProvider provider,
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
  String? get name => r'familyMembersForOccupancyProvider';
}

/// Stream of family members for a specific occupancy.
/// This is the primary way to get family members in the occupancy-centric architecture.
///
/// Copied from [familyMembersForOccupancy].
class FamilyMembersForOccupancyProvider
    extends AutoDisposeStreamProvider<List<FamilyMemberEntity>> {
  /// Stream of family members for a specific occupancy.
  /// This is the primary way to get family members in the occupancy-centric architecture.
  ///
  /// Copied from [familyMembersForOccupancy].
  FamilyMembersForOccupancyProvider(int occupancyId)
    : this._internal(
        (ref) => familyMembersForOccupancy(
          ref as FamilyMembersForOccupancyRef,
          occupancyId,
        ),
        from: familyMembersForOccupancyProvider,
        name: r'familyMembersForOccupancyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$familyMembersForOccupancyHash,
        dependencies: FamilyMembersForOccupancyFamily._dependencies,
        allTransitiveDependencies:
            FamilyMembersForOccupancyFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  FamilyMembersForOccupancyProvider._internal(
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
    Stream<List<FamilyMemberEntity>> Function(
      FamilyMembersForOccupancyRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FamilyMembersForOccupancyProvider._internal(
        (ref) => create(ref as FamilyMembersForOccupancyRef),
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
  AutoDisposeStreamProviderElement<List<FamilyMemberEntity>> createElement() {
    return _FamilyMembersForOccupancyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FamilyMembersForOccupancyProvider &&
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
mixin FamilyMembersForOccupancyRef
    on AutoDisposeStreamProviderRef<List<FamilyMemberEntity>> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _FamilyMembersForOccupancyProviderElement
    extends AutoDisposeStreamProviderElement<List<FamilyMemberEntity>>
    with FamilyMembersForOccupancyRef {
  _FamilyMembersForOccupancyProviderElement(super.provider);

  @override
  int get occupancyId =>
      (origin as FamilyMembersForOccupancyProvider).occupancyId;
}

String _$occupanciesForTenantHash() =>
    r'459231a24cc3b246ad862bb413a01988cae48cbf';

/// Get all occupancies (history) for a tenant.
///
/// Copied from [occupanciesForTenant].
@ProviderFor(occupanciesForTenant)
const occupanciesForTenantProvider = OccupanciesForTenantFamily();

/// Get all occupancies (history) for a tenant.
///
/// Copied from [occupanciesForTenant].
class OccupanciesForTenantFamily extends Family<AsyncValue<List<Occupancy>>> {
  /// Get all occupancies (history) for a tenant.
  ///
  /// Copied from [occupanciesForTenant].
  const OccupanciesForTenantFamily();

  /// Get all occupancies (history) for a tenant.
  ///
  /// Copied from [occupanciesForTenant].
  OccupanciesForTenantProvider call(int tenantId) {
    return OccupanciesForTenantProvider(tenantId);
  }

  @override
  OccupanciesForTenantProvider getProviderOverride(
    covariant OccupanciesForTenantProvider provider,
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
  String? get name => r'occupanciesForTenantProvider';
}

/// Get all occupancies (history) for a tenant.
///
/// Copied from [occupanciesForTenant].
class OccupanciesForTenantProvider
    extends AutoDisposeFutureProvider<List<Occupancy>> {
  /// Get all occupancies (history) for a tenant.
  ///
  /// Copied from [occupanciesForTenant].
  OccupanciesForTenantProvider(int tenantId)
    : this._internal(
        (ref) => occupanciesForTenant(ref as OccupanciesForTenantRef, tenantId),
        from: occupanciesForTenantProvider,
        name: r'occupanciesForTenantProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$occupanciesForTenantHash,
        dependencies: OccupanciesForTenantFamily._dependencies,
        allTransitiveDependencies:
            OccupanciesForTenantFamily._allTransitiveDependencies,
        tenantId: tenantId,
      );

  OccupanciesForTenantProvider._internal(
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
    FutureOr<List<Occupancy>> Function(OccupanciesForTenantRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OccupanciesForTenantProvider._internal(
        (ref) => create(ref as OccupanciesForTenantRef),
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
  AutoDisposeFutureProviderElement<List<Occupancy>> createElement() {
    return _OccupanciesForTenantProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OccupanciesForTenantProvider && other.tenantId == tenantId;
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
mixin OccupanciesForTenantRef on AutoDisposeFutureProviderRef<List<Occupancy>> {
  /// The parameter `tenantId` of this provider.
  int get tenantId;
}

class _OccupanciesForTenantProviderElement
    extends AutoDisposeFutureProviderElement<List<Occupancy>>
    with OccupanciesForTenantRef {
  _OccupanciesForTenantProviderElement(super.provider);

  @override
  int get tenantId => (origin as OccupanciesForTenantProvider).tenantId;
}

String _$expiringAgreementsHash() =>
    r'b370265278ea0430ce17e4dfafc6ff66b4b01bdf';

/// See also [expiringAgreements].
@ProviderFor(expiringAgreements)
final expiringAgreementsProvider =
    AutoDisposeFutureProvider<List<AgreementExpirationStatus>>.internal(
      expiringAgreements,
      name: r'expiringAgreementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expiringAgreementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpiringAgreementsRef =
    AutoDisposeFutureProviderRef<List<AgreementExpirationStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
