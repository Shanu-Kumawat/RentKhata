// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$propertiesStreamHash() => r'2d0b96e1177326589e8363f6f437585739f92d26';

/// Watch all properties (auto-updates when data changes).
///
/// Copied from [propertiesStream].
@ProviderFor(propertiesStream)
final propertiesStreamProvider =
    AutoDisposeStreamProvider<List<Property>>.internal(
      propertiesStream,
      name: r'propertiesStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$propertiesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PropertiesStreamRef = AutoDisposeStreamProviderRef<List<Property>>;
String _$propertiesHash() => r'3741022e37ab498363ebf5545096969bfd07f1c0';

/// Get all properties (future).
///
/// Copied from [properties].
@ProviderFor(properties)
final propertiesProvider = AutoDisposeFutureProvider<List<Property>>.internal(
  properties,
  name: r'propertiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$propertiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PropertiesRef = AutoDisposeFutureProviderRef<List<Property>>;
String _$propertyHash() => r'b73b1cd83f3015a8ad56f1b5b50338dad52a90a3';

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
    r'a77d085a5e3366e4958f07fb241d7c76a7b8c01e';

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
  RoomsForPropertyStreamProvider call(int propertyId) {
    return RoomsForPropertyStreamProvider(propertyId);
  }

  @override
  RoomsForPropertyStreamProvider getProviderOverride(
    covariant RoomsForPropertyStreamProvider provider,
  ) {
    return call(provider.propertyId);
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
  RoomsForPropertyStreamProvider(int propertyId)
    : this._internal(
        (ref) => roomsForPropertyStream(
          ref as RoomsForPropertyStreamRef,
          propertyId,
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
      );

  RoomsForPropertyStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.propertyId,
  }) : super.internal();

  final int propertyId;

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
        other.propertyId == propertyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, propertyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoomsForPropertyStreamRef on AutoDisposeStreamProviderRef<List<Room>> {
  /// The parameter `propertyId` of this provider.
  int get propertyId;
}

class _RoomsForPropertyStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Room>>
    with RoomsForPropertyStreamRef {
  _RoomsForPropertyStreamProviderElement(super.provider);

  @override
  int get propertyId => (origin as RoomsForPropertyStreamProvider).propertyId;
}

String _$roomsForPropertyHash() => r'7beffe1ed3f30deb97f2e830112b3d2fcac7351d';

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
  RoomsForPropertyProvider call(int propertyId) {
    return RoomsForPropertyProvider(propertyId);
  }

  @override
  RoomsForPropertyProvider getProviderOverride(
    covariant RoomsForPropertyProvider provider,
  ) {
    return call(provider.propertyId);
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
  RoomsForPropertyProvider(int propertyId)
    : this._internal(
        (ref) => roomsForProperty(ref as RoomsForPropertyRef, propertyId),
        from: roomsForPropertyProvider,
        name: r'roomsForPropertyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$roomsForPropertyHash,
        dependencies: RoomsForPropertyFamily._dependencies,
        allTransitiveDependencies:
            RoomsForPropertyFamily._allTransitiveDependencies,
        propertyId: propertyId,
      );

  RoomsForPropertyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.propertyId,
  }) : super.internal();

  final int propertyId;

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
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Room>> createElement() {
    return _RoomsForPropertyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomsForPropertyProvider && other.propertyId == propertyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, propertyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoomsForPropertyRef on AutoDisposeFutureProviderRef<List<Room>> {
  /// The parameter `propertyId` of this provider.
  int get propertyId;
}

class _RoomsForPropertyProviderElement
    extends AutoDisposeFutureProviderElement<List<Room>>
    with RoomsForPropertyRef {
  _RoomsForPropertyProviderElement(super.provider);

  @override
  int get propertyId => (origin as RoomsForPropertyProvider).propertyId;
}

String _$roomHash() => r'4a4b1b319cfcb0e50e68ae23c26246abaa3833cf';

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

String _$allRoomsHash() => r'4c5a118733d48f697a39b9f72cc81d0e955afb03';

/// Get all rooms.
///
/// Copied from [allRooms].
@ProviderFor(allRooms)
final allRoomsProvider = AutoDisposeFutureProvider<List<Room>>.internal(
  allRooms,
  name: r'allRoomsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllRoomsRef = AutoDisposeFutureProviderRef<List<Room>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
