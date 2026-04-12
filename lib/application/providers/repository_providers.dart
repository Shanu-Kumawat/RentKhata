/// Repository providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/landlord_repository.dart';
import '../../domain/repositories/property_repository.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../../domain/repositories/billing_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../data/repositories/landlord_repository_impl.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../data/repositories/tenant_repository_impl.dart';
import '../../data/repositories/billing_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import 'database_provider.dart';

part 'repository_providers.g.dart';

/// Provides the LandlordRepository.
@riverpod
LandlordRepository landlordRepository(Ref ref) {
  return LandlordRepositoryImpl(ref.watch(landlordDaoProvider));
}

/// Provides the PropertyRepository.
@riverpod
PropertyRepository propertyRepository(Ref ref) {
  return PropertyRepositoryImpl(
    ref.watch(propertyDaoProvider),
    ref.watch(tenantDaoProvider),
  );
}

/// Provides the TenantRepository.
@Riverpod(keepAlive: true)
TenantRepository tenantRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TenantRepositoryImpl(db.tenantDao, db.propertyDao, db.documentDao);
}

/// Provides the BillingRepository.
@riverpod
BillingRepository billingRepository(Ref ref) {
  return BillingRepositoryImpl(
    ref.watch(billingDaoProvider),
    ref.watch(tenantDaoProvider),
    ref.watch(propertyDaoProvider),
  );
}

/// Provides the ExpenseRepository.
@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ExpenseRepositoryImpl(db.expenseDao);
}
