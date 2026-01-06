/// Database and DAO providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/landlord_dao.dart';
import '../../data/database/daos/property_dao.dart';
import '../../data/database/daos/tenant_dao.dart';
import '../../data/database/daos/billing_dao.dart';

part 'database_provider.g.dart';

/// Provides the main database instance.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

/// Provides the LandlordDao.
@riverpod
LandlordDao landlordDao(LandlordDaoRef ref) {
  return ref.watch(appDatabaseProvider).landlordDao;
}

/// Provides the PropertyDao.
@riverpod
PropertyDao propertyDao(PropertyDaoRef ref) {
  return ref.watch(appDatabaseProvider).propertyDao;
}

/// Provides the TenantDao.
@riverpod
TenantDao tenantDao(TenantDaoRef ref) {
  return ref.watch(appDatabaseProvider).tenantDao;
}

/// Provides the BillingDao.
@riverpod
BillingDao billingDao(BillingDaoRef ref) {
  return ref.watch(appDatabaseProvider).billingDao;
}
