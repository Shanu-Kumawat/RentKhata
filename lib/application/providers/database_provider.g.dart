// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'448adad5717e7b1c0b3ca3ca7e03d0b2116237af';

/// Provides the main database instance.
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$landlordDaoHash() => r'3d1729b11c13863deec9217dfd8cd6b50e247b2a';

/// Provides the LandlordDao.
///
/// Copied from [landlordDao].
@ProviderFor(landlordDao)
final landlordDaoProvider = AutoDisposeProvider<LandlordDao>.internal(
  landlordDao,
  name: r'landlordDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$landlordDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LandlordDaoRef = AutoDisposeProviderRef<LandlordDao>;
String _$propertyDaoHash() => r'1976185007e00a0f2edcde80b645ed1c4bf99088';

/// Provides the PropertyDao.
///
/// Copied from [propertyDao].
@ProviderFor(propertyDao)
final propertyDaoProvider = AutoDisposeProvider<PropertyDao>.internal(
  propertyDao,
  name: r'propertyDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$propertyDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PropertyDaoRef = AutoDisposeProviderRef<PropertyDao>;
String _$tenantDaoHash() => r'fa0ab84eed8b51c512f327f4a1b46c6606b1a095';

/// Provides the TenantDao.
///
/// Copied from [tenantDao].
@ProviderFor(tenantDao)
final tenantDaoProvider = AutoDisposeProvider<TenantDao>.internal(
  tenantDao,
  name: r'tenantDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tenantDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TenantDaoRef = AutoDisposeProviderRef<TenantDao>;
String _$billingDaoHash() => r'53982fde99705ece7045d883adf84695da9fb858';

/// Provides the BillingDao.
///
/// Copied from [billingDao].
@ProviderFor(billingDao)
final billingDaoProvider = AutoDisposeProvider<BillingDao>.internal(
  billingDao,
  name: r'billingDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$billingDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillingDaoRef = AutoDisposeProviderRef<BillingDao>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
