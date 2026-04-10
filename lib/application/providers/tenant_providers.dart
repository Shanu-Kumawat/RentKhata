/// Tenant-related providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/entities/occupancy.dart';
import '../../domain/entities/document.dart';
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

@riverpod
Future<List<Occupancy>> tenantOccupancyHistory(Ref ref, int tenantId) {
  return ref.watch(tenantRepositoryProvider).getOccupanciesForTenant(tenantId);
}

@riverpod
Future<List<Document>> tenantDocuments(Ref ref, int tenantId) {
  return ref.watch(tenantRepositoryProvider).getDocumentsForTenant(tenantId);
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

/// Stream of family members for a tenant's current active occupancy.
@riverpod
Stream<List<FamilyMemberEntity>> familyMembersForTenant(Ref ref, int tenantId) {
  final db = ref.watch(appDatabaseProvider);
  return db.tenantDao.watchFamilyMembersForTenant(tenantId);
}

/// Stream of family members for a specific occupancy.
/// This is the primary way to get family members in the occupancy-centric architecture.
@riverpod
Stream<List<FamilyMemberEntity>> familyMembersForOccupancy(
  Ref ref,
  int occupancyId,
) {
  final db = ref.watch(appDatabaseProvider);
  return db.tenantDao.watchFamilyMembersForOccupancy(occupancyId);
}

/// Get all occupancies (history) for a tenant.
@riverpod
Future<List<Occupancy>> occupanciesForTenant(Ref ref, int tenantId) {
  // Watch active occupancies stream to trigger refresh on changes
  ref.watch(activeOccupanciesStreamProvider);
  final repo = ref.watch(tenantRepositoryProvider);
  return repo.getOccupanciesForTenant(tenantId);
}

// ============================================================================
// AGREEMENT EXPIRATION PROVIDERS
// ============================================================================

class AgreementExpirationStatus {
  final Occupancy occupancy;
  final bool isExpired;
  final int daysRemaining;

  const AgreementExpirationStatus({
    required this.occupancy,
    required this.isExpired,
    required this.daysRemaining,
  });
}

@riverpod
Future<List<AgreementExpirationStatus>> expiringAgreements(Ref ref) async {
  // Use the stream's future to guarantee we get the latest real-time emitted value
  final occupancies = await ref.watch(activeOccupanciesStreamProvider.future);
  
  final now = DateTime.now();
  // Strip time for accurate day calculation
  final today = DateTime(now.year, now.month, now.day);

  final List<AgreementExpirationStatus> expiring = [];

  for (final o in occupancies) {
    if (o.agreementEndDate != null) {
      final end = o.agreementEndDate!;
      final endDate = DateTime(end.year, end.month, end.day);
      final days = endDate.difference(today).inDays;
      
      // If expired or expiring within 30 days
      if (days <= 30) {
        expiring.add(AgreementExpirationStatus(
          occupancy: o,
          isExpired: days < 0,
          daysRemaining: days,
        ));
      }
    }
  }

  // Sort by urgency
  expiring.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
  return expiring;
}
