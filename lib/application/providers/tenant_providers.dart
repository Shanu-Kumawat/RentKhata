/// Tenant-related providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/entities/occupancy.dart';
import 'repository_providers.dart';

part 'tenant_providers.g.dart';

/// Watch all tenants.
@riverpod
Stream<List<Tenant>> tenantsStream(TenantsStreamRef ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.watchAllTenants();
}

/// Get all tenants (future).
@riverpod
Future<List<Tenant>> tenants(TenantsRef ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getAllTenants();
}

/// Get a single tenant by ID.
@riverpod
Future<Tenant?> tenant(TenantRef ref, int id) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getTenantById(id);
}

/// Search tenants.
@riverpod
Future<List<Tenant>> searchTenants(SearchTenantsRef ref, String query) {
  if (query.isEmpty) return ref.watch(tenantsProvider.future);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.searchTenants(query);
}

/// Get custom fields for a tenant.
@riverpod
Future<List<CustomField>> customFieldsForTenant(
  CustomFieldsForTenantRef ref,
  int tenantId,
) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getCustomFieldsForTenant(tenantId);
}

/// Watch active occupancies.
@riverpod
Stream<List<Occupancy>> activeOccupanciesStream(ActiveOccupanciesStreamRef ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.watchActiveOccupancies();
}

/// Get active occupancies.
@riverpod
Future<List<Occupancy>> activeOccupancies(ActiveOccupanciesRef ref) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getActiveOccupancies();
}

/// Get active occupancy for a room.
@riverpod
Future<Occupancy?> occupancyForRoom(OccupancyForRoomRef ref, int roomId) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getActiveOccupancyForRoom(roomId);
}

/// Get tenant for a room.
@riverpod
Future<Tenant?> tenantForRoom(TenantForRoomRef ref, int roomId) {
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getTenantByRoom(roomId);
}
