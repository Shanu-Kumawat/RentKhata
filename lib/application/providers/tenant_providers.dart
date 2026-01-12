/// Tenant-related providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/entities/occupancy.dart';
import 'repository_providers.dart';

part 'tenant_providers.g.dart';

/// Watch all tenants (auto-updates when data changes).
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
/// This provider auto-refreshes when tenantsStream emits new data.
@riverpod
Future<Tenant?> tenant(TenantRef ref, int id) async {
  // Watch the stream to trigger refresh when tenants change
  ref.watch(tenantsStreamProvider);
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
/// This auto-refreshes when tenants change.
@riverpod
Future<List<CustomField>> customFieldsForTenant(
  CustomFieldsForTenantRef ref,
  int tenantId,
) {
  // Watch tenants stream to refresh custom fields when tenant updates
  ref.watch(tenantsStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getCustomFieldsForTenant(tenantId);
}

/// Watch active occupancies (auto-updates when data changes).
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
/// This provider auto-refreshes when occupancy data changes.
@riverpod
Future<Occupancy?> occupancyForRoom(OccupancyForRoomRef ref, int roomId) {
  // Watch active occupancies stream to trigger refresh
  ref.watch(activeOccupanciesStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getActiveOccupancyForRoom(roomId);
}

/// Get tenant for a room.
/// This provider auto-refreshes when tenant data changes.
@riverpod
Future<Tenant?> tenantForRoom(TenantForRoomRef ref, int roomId) {
  // Watch tenants and occupancies to trigger refresh
  ref.watch(tenantsStreamProvider);
  ref.watch(activeOccupanciesStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getTenantByRoom(roomId);
}
