// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occupancy_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$occupancyHash() => r'035a9f384066a6ca1c0545aa247a2fc6ec3779cb';

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

/// Get occupancy by ID with room and tenant info.
///
/// Copied from [occupancy].
@ProviderFor(occupancy)
const occupancyProvider = OccupancyFamily();

/// Get occupancy by ID with room and tenant info.
///
/// Copied from [occupancy].
class OccupancyFamily extends Family<AsyncValue<Occupancy?>> {
  /// Get occupancy by ID with room and tenant info.
  ///
  /// Copied from [occupancy].
  const OccupancyFamily();

  /// Get occupancy by ID with room and tenant info.
  ///
  /// Copied from [occupancy].
  OccupancyProvider call(int occupancyId) {
    return OccupancyProvider(occupancyId);
  }

  @override
  OccupancyProvider getProviderOverride(covariant OccupancyProvider provider) {
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
  String? get name => r'occupancyProvider';
}

/// Get occupancy by ID with room and tenant info.
///
/// Copied from [occupancy].
class OccupancyProvider extends AutoDisposeFutureProvider<Occupancy?> {
  /// Get occupancy by ID with room and tenant info.
  ///
  /// Copied from [occupancy].
  OccupancyProvider(int occupancyId)
    : this._internal(
        (ref) => occupancy(ref as OccupancyRef, occupancyId),
        from: occupancyProvider,
        name: r'occupancyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$occupancyHash,
        dependencies: OccupancyFamily._dependencies,
        allTransitiveDependencies: OccupancyFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  OccupancyProvider._internal(
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
    FutureOr<Occupancy?> Function(OccupancyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OccupancyProvider._internal(
        (ref) => create(ref as OccupancyRef),
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
  AutoDisposeFutureProviderElement<Occupancy?> createElement() {
    return _OccupancyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OccupancyProvider && other.occupancyId == occupancyId;
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
mixin OccupancyRef on AutoDisposeFutureProviderRef<Occupancy?> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _OccupancyProviderElement
    extends AutoDisposeFutureProviderElement<Occupancy?>
    with OccupancyRef {
  _OccupancyProviderElement(super.provider);

  @override
  int get occupancyId => (origin as OccupancyProvider).occupancyId;
}

String _$occupancyDetailHash() => r'0d905f24f072170009e9148da4476d28e959ddd0';

/// Get complete occupancy detail with all related data.
///
/// Copied from [occupancyDetail].
@ProviderFor(occupancyDetail)
const occupancyDetailProvider = OccupancyDetailFamily();

/// Get complete occupancy detail with all related data.
///
/// Copied from [occupancyDetail].
class OccupancyDetailFamily extends Family<AsyncValue<OccupancyDetail?>> {
  /// Get complete occupancy detail with all related data.
  ///
  /// Copied from [occupancyDetail].
  const OccupancyDetailFamily();

  /// Get complete occupancy detail with all related data.
  ///
  /// Copied from [occupancyDetail].
  OccupancyDetailProvider call(int occupancyId) {
    return OccupancyDetailProvider(occupancyId);
  }

  @override
  OccupancyDetailProvider getProviderOverride(
    covariant OccupancyDetailProvider provider,
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
  String? get name => r'occupancyDetailProvider';
}

/// Get complete occupancy detail with all related data.
///
/// Copied from [occupancyDetail].
class OccupancyDetailProvider
    extends AutoDisposeFutureProvider<OccupancyDetail?> {
  /// Get complete occupancy detail with all related data.
  ///
  /// Copied from [occupancyDetail].
  OccupancyDetailProvider(int occupancyId)
    : this._internal(
        (ref) => occupancyDetail(ref as OccupancyDetailRef, occupancyId),
        from: occupancyDetailProvider,
        name: r'occupancyDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$occupancyDetailHash,
        dependencies: OccupancyDetailFamily._dependencies,
        allTransitiveDependencies:
            OccupancyDetailFamily._allTransitiveDependencies,
        occupancyId: occupancyId,
      );

  OccupancyDetailProvider._internal(
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
    FutureOr<OccupancyDetail?> Function(OccupancyDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OccupancyDetailProvider._internal(
        (ref) => create(ref as OccupancyDetailRef),
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
  AutoDisposeFutureProviderElement<OccupancyDetail?> createElement() {
    return _OccupancyDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OccupancyDetailProvider && other.occupancyId == occupancyId;
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
mixin OccupancyDetailRef on AutoDisposeFutureProviderRef<OccupancyDetail?> {
  /// The parameter `occupancyId` of this provider.
  int get occupancyId;
}

class _OccupancyDetailProviderElement
    extends AutoDisposeFutureProviderElement<OccupancyDetail?>
    with OccupancyDetailRef {
  _OccupancyDetailProviderElement(super.provider);

  @override
  int get occupancyId => (origin as OccupancyDetailProvider).occupancyId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
