/// Tenant-related providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/entities/occupancy.dart';
import '../../data/database/app_database.dart';
import 'repository_providers.dart';
import 'database_provider.dart';

part 'tenant_providers.g.dart';

/// Watch all tenants (auto-updates when data changes).
@riverpod
Stream<List<Tenant>> tenantsStream(Ref ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.watchAllTenants();
}

/// Get all tenants (future).
@riverpod
Future<List<Tenant>> tenants(Ref ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getAllTenants();
}

/// Get a single tenant by ID.
/// This provider auto-refreshes when tenantsStream emits new data.
@riverpod
Future<Tenant?> tenant(Ref ref, int id) async {
  // Watch the stream to trigger refresh when tenants change
  ref.watch(tenantsStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getTenantById(id);
}

/// Search tenants.
@riverpod
Future<List<Tenant>> searchTenants(Ref ref, String query) {
  if (query.isEmpty) return ref.watch(tenantsProvider.future);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.searchTenants(query);
}

/// Get custom fields for a tenant.
/// This auto-refreshes when tenants change.
@riverpod
Future<List<CustomField>> customFieldsForTenant(Ref ref, int tenantId) {
  // Watch tenants stream to refresh custom fields when tenant updates
  ref.watch(tenantsStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getCustomFieldsForTenant(tenantId);
}

/// Watch active occupancies (auto-updates when data changes).
@riverpod
Stream<List<Occupancy>> activeOccupanciesStream(Ref ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.watchActiveOccupancies();
}

/// Get active occupancies.
@riverpod
Future<List<Occupancy>> activeOccupancies(Ref ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getActiveOccupancies();
}

/// Get active occupancy for a room.
/// This provider auto-refreshes when occupancy data changes.
@riverpod
Future<Occupancy?> occupancyForRoom(Ref ref, int roomId) {
  // Watch active occupancies stream to trigger refresh
  ref.watch(activeOccupanciesStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getActiveOccupancyForRoom(roomId);
}

/// Get tenant for a room.
/// This provider auto-refreshes when tenant data changes.
@riverpod
Future<Tenant?> tenantForRoom(Ref ref, int roomId) {
  // Watch tenants and occupancies to trigger refresh
  ref.watch(tenantsStreamProvider);
  ref.watch(activeOccupanciesStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getTenantByRoom(roomId);
}

/// Stream of family members for a tenant.
@riverpod
Stream<List<FamilyMemberEntity>> familyMembersForTenant(Ref ref, int tenantId) {
  final db = ref.watch(appDatabaseProvider);
  return db.tenantDao.watchFamilyMembersForTenant(tenantId);
}

/// Get all occupancies (history) for a tenant.
@riverpod
Future<List<Occupancy>> occupanciesForTenant(Ref ref, int tenantId) {
  // Watch active occupancies stream to trigger refresh on changes
  ref.watch(activeOccupanciesStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getOccupanciesForTenant(tenantId);
}
