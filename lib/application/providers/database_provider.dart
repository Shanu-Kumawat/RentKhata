/// Database and DAO providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/landlord_dao.dart';
import '../../data/database/daos/property_dao.dart';
import '../../data/database/daos/tenant_dao.dart';
import '../../data/database/daos/billing_dao.dart';

part 'database_provider.g.dart';

/// Provides the main database instance.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

/// Provides the LandlordDao.
@riverpod
LandlordDao landlordDao(Ref ref) {
  return ref.watch(appDatabaseProvider).landlordDao;
}

/// Provides the PropertyDao.
@riverpod
PropertyDao propertyDao(Ref ref) {
  return ref.watch(appDatabaseProvider).propertyDao;
}

/// Provides the TenantDao.
@riverpod
TenantDao tenantDao(Ref ref) {
  return ref.watch(appDatabaseProvider).tenantDao;
}

/// Provides the BillingDao.
@riverpod
BillingDao billingDao(Ref ref) {
  return ref.watch(appDatabaseProvider).billingDao;
}
