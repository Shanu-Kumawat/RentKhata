// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$propertiesStreamHash() => r'6ab818bee5e75906384535197bfe9175a406aafc';

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

/// Watch all properties (auto-updates when data changes).
///
/// Copied from [propertiesStream].
@ProviderFor(propertiesStream)
const propertiesStreamProvider = PropertiesStreamFamily();

/// Watch all properties (auto-updates when data changes).
///
/// Copied from [propertiesStream].
class PropertiesStreamFamily extends Family<AsyncValue<List<Property>>> {
  /// Watch all properties (auto-updates when data changes).
  ///
  /// Copied from [propertiesStream].
  const PropertiesStreamFamily();

  /// Watch all properties (auto-updates when data changes).
  ///
  /// Copied from [propertiesStream].
  PropertiesStreamProvider call({bool includeArchived = false}) {
    return PropertiesStreamProvider(includeArchived: includeArchived);
  }

  @override
  PropertiesStreamProvider getProviderOverride(
    covariant PropertiesStreamProvider provider,
  ) {
    return call(includeArchived: provider.includeArchived);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'propertiesStreamProvider';
}

/// Watch all properties (auto-updates when data changes).
///
/// Copied from [propertiesStream].
class PropertiesStreamProvider
    extends AutoDisposeStreamProvider<List<Property>> {
  /// Watch all properties (auto-updates when data changes).
  ///
  /// Copied from [propertiesStream].
  PropertiesStreamProvider({bool includeArchived = false})
    : this._internal(
        (ref) => propertiesStream(
          ref as PropertiesStreamRef,
          includeArchived: includeArchived,
        ),
        from: propertiesStreamProvider,
        name: r'propertiesStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$propertiesStreamHash,
        dependencies: PropertiesStreamFamily._dependencies,
        allTransitiveDependencies:
            PropertiesStreamFamily._allTransitiveDependencies,
        includeArchived: includeArchived,
      );

  PropertiesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.includeArchived,
  }) : super.internal();

  final bool includeArchived;

  @override
  Override overrideWith(
    Stream<List<Property>> Function(PropertiesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PropertiesStreamProvider._internal(
        (ref) => create(ref as PropertiesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        includeArchived: includeArchived,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Property>> createElement() {
    return _PropertiesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PropertiesStreamProvider &&
        other.includeArchived == includeArchived;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, includeArchived.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PropertiesStreamRef on AutoDisposeStreamProviderRef<List<Property>> {
  /// The parameter `includeArchived` of this provider.
  bool get includeArchived;
}

class _PropertiesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Property>>
    with PropertiesStreamRef {
  _PropertiesStreamProviderElement(super.provider);

  @override
  bool get includeArchived =>
      (origin as PropertiesStreamProvider).includeArchived;
}

String _$propertiesHash() => r'd9293378bf075de59d8d757e477389db206abe46';

/// Get all properties (future).
///
/// Copied from [properties].
@ProviderFor(properties)
const propertiesProvider = PropertiesFamily();

/// Get all properties (future).
///
/// Copied from [properties].
class PropertiesFamily extends Family<AsyncValue<List<Property>>> {
  /// Get all properties (future).
  ///
  /// Copied from [properties].
  const PropertiesFamily();

  /// Get all properties (future).
  ///
  /// Copied from [properties].
  PropertiesProvider call({bool includeArchived = false}) {
    return PropertiesProvider(includeArchived: includeArchived);
  }

  @override
  PropertiesProvider getProviderOverride(
    covariant PropertiesProvider provider,
  ) {
    return call(includeArchived: provider.includeArchived);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'propertiesProvider';
}

/// Get all properties (future).
///
/// Copied from [properties].
class PropertiesProvider extends AutoDisposeFutureProvider<List<Property>> {
  /// Get all properties (future).
  ///
  /// Copied from [properties].
  PropertiesProvider({bool includeArchived = false})
    : this._internal(
        (ref) =>
            properties(ref as PropertiesRef, includeArchived: includeArchived),
        from: propertiesProvider,
        name: r'propertiesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$propertiesHash,
        dependencies: PropertiesFamily._dependencies,
        allTransitiveDependencies: PropertiesFamily._allTransitiveDependencies,
        includeArchived: includeArchived,
      );

  PropertiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.includeArchived,
  }) : super.internal();

  final bool includeArchived;

  @override
  Override overrideWith(
    FutureOr<List<Property>> Function(PropertiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PropertiesProvider._internal(
        (ref) => create(ref as PropertiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        includeArchived: includeArchived,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Property>> createElement() {
    return _PropertiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PropertiesProvider &&
        other.includeArchived == includeArchived;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, includeArchived.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PropertiesRef on AutoDisposeFutureProviderRef<List<Property>> {
  /// The parameter `includeArchived` of this provider.
  bool get includeArchived;
}

class _PropertiesProviderElement
    extends AutoDisposeFutureProviderElement<List<Property>>
    with PropertiesRef {
  _PropertiesProviderElement(super.provider);

  @override
  bool get includeArchived => (origin as PropertiesProvider).includeArchived;
}

String _$propertyHash() => r'99b0313e500b30aa7c85467463c46ad76a402939';

/// Get a single property by ID.
/// This provider auto-refreshes when propertiesStream emits new data.
///
/// Copied from [property].
@ProviderFor(property)
const propertyProvider = PropertyFamily();

/// Get a single property by ID.
/// This provider auto-refreshes when propertiesStream emits new data.
///
/// Copied from [property].
class PropertyFamily extends Family<AsyncValue<Property?>> {
  /// Get a single property by ID.
  /// This provider auto-refreshes when propertiesStream emits new data.
  ///
  /// Copied from [property].
  const PropertyFamily();

  /// Get a single property by ID.
  /// This provider auto-refreshes when propertiesStream emits new data.
  ///
  /// Copied from [property].
  PropertyProvider call(int id) {
    return PropertyProvider(id);
  }

  @override
  PropertyProvider getProviderOverride(covariant PropertyProvider provider) {
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
  String? get name => r'propertyProvider';
}

/// Get a single property by ID.
/// This provider auto-refreshes when propertiesStream emits new data.
///
/// Copied from [property].
class PropertyProvider extends AutoDisposeFutureProvider<Property?> {
  /// Get a single property by ID.
  /// This provider auto-refreshes when propertiesStream emits new data.
  ///
  /// Copied from [property].
  PropertyProvider(int id)
    : this._internal(
        (ref) => property(ref as PropertyRef, id),
        from: propertyProvider,
        name: r'propertyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$propertyHash,
        dependencies: PropertyFamily._dependencies,
        allTransitiveDependencies: PropertyFamily._allTransitiveDependencies,
        id: id,
      );

  PropertyProvider._internal(
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
  Override overrideWith(
    FutureOr<Property?> Function(PropertyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PropertyProvider._internal(
        (ref) => create(ref as PropertyRef),
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
  AutoDisposeFutureProviderElement<Property?> createElement() {
    return _PropertyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PropertyProvider && other.id == id;
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
mixin PropertyRef on AutoDisposeFutureProviderRef<Property?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PropertyProviderElement
    extends AutoDisposeFutureProviderElement<Property?>
    with PropertyRef {
  _PropertyProviderElement(super.provider);

  @override
  int get id => (origin as PropertyProvider).id;
}

String _$roomsForPropertyStreamHash() =>
    r'e4114f03a7252d55eb8a7aaa4f3cac209a04007a';

/// Watch rooms for a property (auto-updates when data changes).
///
/// Copied from [roomsForPropertyStream].
@ProviderFor(roomsForPropertyStream)
const roomsForPropertyStreamProvider = RoomsForPropertyStreamFamily();

/// Watch rooms for a property (auto-updates when data changes).
///
/// Copied from [roomsForPropertyStream].
class RoomsForPropertyStreamFamily extends Family<AsyncValue<List<Room>>> {
  /// Watch rooms for a property (auto-updates when data changes).
  ///
  /// Copied from [roomsForPropertyStream].
  const RoomsForPropertyStreamFamily();

  /// Watch rooms for a property (auto-updates when data changes).
  ///
  /// Copied from [roomsForPropertyStream].
  RoomsForPropertyStreamProvider call(
    int propertyId, {
    bool includeArchived = false,
  }) {
    return RoomsForPropertyStreamProvider(
      propertyId,
      includeArchived: includeArchived,
    );
  }

  @override
  RoomsForPropertyStreamProvider getProviderOverride(
    covariant RoomsForPropertyStreamProvider provider,
  ) {
    return call(provider.propertyId, includeArchived: provider.includeArchived);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'roomsForPropertyStreamProvider';
}

/// Watch rooms for a property (auto-updates when data changes).
///
/// Copied from [roomsForPropertyStream].
class RoomsForPropertyStreamProvider
    extends AutoDisposeStreamProvider<List<Room>> {
  /// Watch rooms for a property (auto-updates when data changes).
  ///
  /// Copied from [roomsForPropertyStream].
  RoomsForPropertyStreamProvider(int propertyId, {bool includeArchived = false})
    : this._internal(
        (ref) => roomsForPropertyStream(
          ref as RoomsForPropertyStreamRef,
          propertyId,
          includeArchived: includeArchived,
        ),
        from: roomsForPropertyStreamProvider,
        name: r'roomsForPropertyStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$roomsForPropertyStreamHash,
        dependencies: RoomsForPropertyStreamFamily._dependencies,
        allTransitiveDependencies:
            RoomsForPropertyStreamFamily._allTransitiveDependencies,
        propertyId: propertyId,
        includeArchived: includeArchived,
      );

  RoomsForPropertyStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.propertyId,
    required this.includeArchived,
  }) : super.internal();

  final int propertyId;
  final bool includeArchived;

  @override
  Override overrideWith(
    Stream<List<Room>> Function(RoomsForPropertyStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoomsForPropertyStreamProvider._internal(
        (ref) => create(ref as RoomsForPropertyStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        propertyId: propertyId,
        includeArchived: includeArchived,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Room>> createElement() {
    return _RoomsForPropertyStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomsForPropertyStreamProvider &&
        other.propertyId == propertyId &&
        other.includeArchived == includeArchived;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, propertyId.hashCode);
    hash = _SystemHash.combine(hash, includeArchived.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoomsForPropertyStreamRef on AutoDisposeStreamProviderRef<List<Room>> {
  /// The parameter `propertyId` of this provider.
  int get propertyId;

  /// The parameter `includeArchived` of this provider.
  bool get includeArchived;
}

class _RoomsForPropertyStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Room>>
    with RoomsForPropertyStreamRef {
  _RoomsForPropertyStreamProviderElement(super.provider);

  @override
  int get propertyId => (origin as RoomsForPropertyStreamProvider).propertyId;
  @override
  bool get includeArchived =>
      (origin as RoomsForPropertyStreamProvider).includeArchived;
}

String _$roomsForPropertyHash() => r'd8a800aee5516e42ac98a674265e75eff48419f6';

/// Get rooms for a property.
///
/// Copied from [roomsForProperty].
@ProviderFor(roomsForProperty)
const roomsForPropertyProvider = RoomsForPropertyFamily();

/// Get rooms for a property.
///
/// Copied from [roomsForProperty].
class RoomsForPropertyFamily extends Family<AsyncValue<List<Room>>> {
  /// Get rooms for a property.
  ///
  /// Copied from [roomsForProperty].
  const RoomsForPropertyFamily();

  /// Get rooms for a property.
  ///
  /// Copied from [roomsForProperty].
  RoomsForPropertyProvider call(
    int propertyId, {
    bool includeArchived = false,
  }) {
    return RoomsForPropertyProvider(
      propertyId,
      includeArchived: includeArchived,
    );
  }

  @override
  RoomsForPropertyProvider getProviderOverride(
    covariant RoomsForPropertyProvider provider,
  ) {
    return call(provider.propertyId, includeArchived: provider.includeArchived);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'roomsForPropertyProvider';
}

/// Get rooms for a property.
///
/// Copied from [roomsForProperty].
class RoomsForPropertyProvider extends AutoDisposeFutureProvider<List<Room>> {
  /// Get rooms for a property.
  ///
  /// Copied from [roomsForProperty].
  RoomsForPropertyProvider(int propertyId, {bool includeArchived = false})
    : this._internal(
        (ref) => roomsForProperty(
          ref as RoomsForPropertyRef,
          propertyId,
          includeArchived: includeArchived,
        ),
        from: roomsForPropertyProvider,
        name: r'roomsForPropertyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$roomsForPropertyHash,
        dependencies: RoomsForPropertyFamily._dependencies,
        allTransitiveDependencies:
            RoomsForPropertyFamily._allTransitiveDependencies,
        propertyId: propertyId,
        includeArchived: includeArchived,
      );

  RoomsForPropertyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.propertyId,
    required this.includeArchived,
  }) : super.internal();

  final int propertyId;
  final bool includeArchived;

  @override
  Override overrideWith(
    FutureOr<List<Room>> Function(RoomsForPropertyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoomsForPropertyProvider._internal(
        (ref) => create(ref as RoomsForPropertyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        propertyId: propertyId,
        includeArchived: includeArchived,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Room>> createElement() {
    return _RoomsForPropertyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomsForPropertyProvider &&
        other.propertyId == propertyId &&
        other.includeArchived == includeArchived;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, propertyId.hashCode);
    hash = _SystemHash.combine(hash, includeArchived.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoomsForPropertyRef on AutoDisposeFutureProviderRef<List<Room>> {
  /// The parameter `propertyId` of this provider.
  int get propertyId;

  /// The parameter `includeArchived` of this provider.
  bool get includeArchived;
}

class _RoomsForPropertyProviderElement
    extends AutoDisposeFutureProviderElement<List<Room>>
    with RoomsForPropertyRef {
  _RoomsForPropertyProviderElement(super.provider);

  @override
  int get propertyId => (origin as RoomsForPropertyProvider).propertyId;
  @override
  bool get includeArchived =>
      (origin as RoomsForPropertyProvider).includeArchived;
}

String _$roomHash() => r'b1f13c8bc207dbffa8ba998915e0bcc51e71ba46';

/// Get a single room by ID.
/// This provider auto-refreshes when room data changes.
///
/// Copied from [room].
@ProviderFor(room)
const roomProvider = RoomFamily();

/// Get a single room by ID.
/// This provider auto-refreshes when room data changes.
///
/// Copied from [room].
class RoomFamily extends Family<AsyncValue<Room?>> {
  /// Get a single room by ID.
  /// This provider auto-refreshes when room data changes.
  ///
  /// Copied from [room].
  const RoomFamily();

  /// Get a single room by ID.
  /// This provider auto-refreshes when room data changes.
  ///
  /// Copied from [room].
  RoomProvider call(int id) {
    return RoomProvider(id);
  }

  @override
  RoomProvider getProviderOverride(covariant RoomProvider provider) {
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
  String? get name => r'roomProvider';
}

/// Get a single room by ID.
/// This provider auto-refreshes when room data changes.
///
/// Copied from [room].
class RoomProvider extends AutoDisposeFutureProvider<Room?> {
  /// Get a single room by ID.
  /// This provider auto-refreshes when room data changes.
  ///
  /// Copied from [room].
  RoomProvider(int id)
    : this._internal(
        (ref) => room(ref as RoomRef, id),
        from: roomProvider,
        name: r'roomProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$roomHash,
        dependencies: RoomFamily._dependencies,
        allTransitiveDependencies: RoomFamily._allTransitiveDependencies,
        id: id,
      );

  RoomProvider._internal(
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
  Override overrideWith(FutureOr<Room?> Function(RoomRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: RoomProvider._internal(
        (ref) => create(ref as RoomRef),
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
  AutoDisposeFutureProviderElement<Room?> createElement() {
    return _RoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomProvider && other.id == id;
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
mixin RoomRef on AutoDisposeFutureProviderRef<Room?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _RoomProviderElement extends AutoDisposeFutureProviderElement<Room?>
    with RoomRef {
  _RoomProviderElement(super.provider);

  @override
  int get id => (origin as RoomProvider).id;
}

String _$allRoomsHash() => r'44808788912a91ebbbacb5686013278bdd7c4ad5';

/// Get all rooms.
///
/// Copied from [allRooms].
@ProviderFor(allRooms)
const allRoomsProvider = AllRoomsFamily();

/// Get all rooms.
///
/// Copied from [allRooms].
class AllRoomsFamily extends Family<AsyncValue<List<Room>>> {
  /// Get all rooms.
  ///
  /// Copied from [allRooms].
  const AllRoomsFamily();

  /// Get all rooms.
  ///
  /// Copied from [allRooms].
  AllRoomsProvider call({bool includeArchived = false}) {
    return AllRoomsProvider(includeArchived: includeArchived);
  }

  @override
  AllRoomsProvider getProviderOverride(covariant AllRoomsProvider provider) {
    return call(includeArchived: provider.includeArchived);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allRoomsProvider';
}

/// Get all rooms.
///
/// Copied from [allRooms].
class AllRoomsProvider extends AutoDisposeFutureProvider<List<Room>> {
  /// Get all rooms.
  ///
  /// Copied from [allRooms].
  AllRoomsProvider({bool includeArchived = false})
    : this._internal(
        (ref) => allRooms(ref as AllRoomsRef, includeArchived: includeArchived),
        from: allRoomsProvider,
        name: r'allRoomsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$allRoomsHash,
        dependencies: AllRoomsFamily._dependencies,
        allTransitiveDependencies: AllRoomsFamily._allTransitiveDependencies,
        includeArchived: includeArchived,
      );

  AllRoomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.includeArchived,
  }) : super.internal();

  final bool includeArchived;

  @override
  Override overrideWith(
    FutureOr<List<Room>> Function(AllRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllRoomsProvider._internal(
        (ref) => create(ref as AllRoomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        includeArchived: includeArchived,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Room>> createElement() {
    return _AllRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllRoomsProvider &&
        other.includeArchived == includeArchived;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, includeArchived.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllRoomsRef on AutoDisposeFutureProviderRef<List<Room>> {
  /// The parameter `includeArchived` of this provider.
  bool get includeArchived;
}

class _AllRoomsProviderElement
    extends AutoDisposeFutureProviderElement<List<Room>>
    with AllRoomsRef {
  _AllRoomsProviderElement(super.provider);

  @override
  bool get includeArchived => (origin as AllRoomsProvider).includeArchived;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
