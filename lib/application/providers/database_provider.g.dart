// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'105bd8a8ef41e172ff5db2d8e451479a0697fd42';

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
String _$landlordDaoHash() => r'e6cbf07337ceef9e66214d944230e411e312f6f4';

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
String _$propertyDaoHash() => r'd4701d5039b6aa5d9378c7923091be6bf10d90a2';

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
String _$tenantDaoHash() => r'16bc96a6d4f033a7ba93233c522c16079859cc9c';

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
String _$billingDaoHash() => r'95acd8ad7243f3f37281a3b27bbf268a44ef8bb3';

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
