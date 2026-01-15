/// Tenant Data Access Object.
library;

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tenant_table.dart';
import '../tables/custom_field_table.dart';
import '../tables/occupancy_table.dart';
import '../tables/family_member_table.dart';

part 'tenant_dao.g.dart';

/// DAO for tenant and occupancy operations.
@DriftAccessor(tables: [Tenants, CustomFields, Occupancies, FamilyMembers])
class TenantDao extends DatabaseAccessor<AppDatabase> with _$TenantDaoMixin {
  TenantDao(super.db);

  // ========== Tenant Operations ==========

  /// Get all tenants
  Future<List<TenantEntity>> getAllTenants() => select(tenants).get();

  /// Watch all tenants
  Stream<List<TenantEntity>> watchAllTenants() => select(tenants).watch();

  /// Get tenant by ID
  Future<TenantEntity?> getTenantById(int id) =>
      (select(tenants)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Search tenants by name or phone
  Future<List<TenantEntity>> searchTenants(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(tenants)..where(
          (t) => t.name.lower().like(lowerQuery) | t.phone.like('%$query%'),
        ))
        .get();
  }

  /// Insert a tenant
  Future<int> insertTenant(TenantsCompanion tenant) =>
      into(tenants).insert(tenant);

  /// Update a tenant
  Future<bool> updateTenant(TenantEntity tenant) =>
      update(tenants).replace(tenant);

  /// Delete a tenant
  Future<int> deleteTenant(int id) =>
      (delete(tenants)..where((t) => t.id.equals(id))).go();

  // ========== Custom Field Operations ==========

  /// Get custom fields for a tenant
  Future<List<CustomFieldEntity>> getCustomFieldsForTenant(int tenantId) =>
      (select(customFields)..where((c) => c.tenantId.equals(tenantId))).get();

  /// Insert a custom field
  Future<int> insertCustomField(CustomFieldsCompanion field) =>
      into(customFields).insert(field);

  /// Update a custom field
  Future<bool> updateCustomField(CustomFieldEntity field) =>
      update(customFields).replace(field);

  /// Delete a custom field
  Future<int> deleteCustomField(int id) =>
      (delete(customFields)..where((c) => c.id.equals(id))).go();

  /// Delete all custom fields for a tenant
  Future<int> deleteCustomFieldsForTenant(int tenantId) =>
      (delete(customFields)..where((c) => c.tenantId.equals(tenantId))).go();

  // ========== Occupancy Operations ==========

  /// Get all occupancies for a tenant
  Future<List<OccupancyEntity>> getOccupanciesForTenant(int tenantId) =>
      (select(occupancies)..where((o) => o.tenantId.equals(tenantId))).get();

  /// Get an occupancy by ID
  Future<OccupancyEntity?> getOccupancyById(int id) =>
      (select(occupancies)..where((o) => o.id.equals(id))).getSingleOrNull();

  /// Get active occupancy for a room
  Future<OccupancyEntity?> getActiveOccupancyForRoom(int roomId) =>
      (select(occupancies)
            ..where((o) => o.roomId.equals(roomId) & o.isActive.equals(true)))
          .getSingleOrNull();

  /// Get all active occupancies
  Future<List<OccupancyEntity>> getActiveOccupancies() =>
      (select(occupancies)..where((o) => o.isActive.equals(true))).get();

  /// Watch active occupancies
  Stream<List<OccupancyEntity>> watchActiveOccupancies() =>
      (select(occupancies)..where((o) => o.isActive.equals(true))).watch();

  /// Insert an occupancy
  Future<int> insertOccupancy(OccupanciesCompanion occupancy) =>
      into(occupancies).insert(occupancy);

  /// Update an occupancy
  Future<bool> updateOccupancy(OccupancyEntity occupancy) =>
      update(occupancies).replace(occupancy);

  /// End an occupancy (set move-out date and inactive)
  Future<bool> endOccupancy(int occupancyId, DateTime moveOutDate) async {
    final occupancy = await (select(
      occupancies,
    )..where((o) => o.id.equals(occupancyId))).getSingleOrNull();

    if (occupancy == null) return false;

    return update(occupancies).replace(
      occupancy.copyWith(moveOutDate: Value(moveOutDate), isActive: false),
    );
  }

  /// Get tenant with their current occupancy info
  Future<TenantEntity?> getTenantByRoom(int roomId) async {
    final occupancy = await getActiveOccupancyForRoom(roomId);
    if (occupancy == null) return null;
    return getTenantById(occupancy.tenantId);
  }

  // ========== Family Member Operations ==========

  /// Get family members for a specific occupancy
  Future<List<FamilyMemberEntity>> getFamilyMembersForOccupancy(
    int occupancyId,
  ) => (select(
    familyMembers,
  )..where((f) => f.occupancyId.equals(occupancyId))).get();

  /// Watch family members for a specific occupancy
  Stream<List<FamilyMemberEntity>> watchFamilyMembersForOccupancy(
    int occupancyId,
  ) => (select(
    familyMembers,
  )..where((f) => f.occupancyId.equals(occupancyId))).watch();

  /// Get family members for a tenant's current active occupancy
  /// Returns empty list if tenant has no active occupancy
  Future<List<FamilyMemberEntity>> getFamilyMembersForTenant(
    int tenantId,
  ) async {
    final activeOccupancy =
        await (select(occupancies)..where(
              (o) => o.tenantId.equals(tenantId) & o.isActive.equals(true),
            ))
            .getSingleOrNull();
    if (activeOccupancy == null) return [];
    return getFamilyMembersForOccupancy(activeOccupancy.id);
  }

  /// Watch family members for a tenant's current active occupancy
  Stream<List<FamilyMemberEntity>> watchFamilyMembersForTenant(int tenantId) {
    return watchActiveOccupancies()
        .map(
          (occupancies) =>
              occupancies.where((o) => o.tenantId == tenantId).firstOrNull,
        )
        .asyncMap((occupancy) async {
          if (occupancy == null) return <FamilyMemberEntity>[];
          return getFamilyMembersForOccupancy(occupancy.id);
        });
  }

  /// Insert a family member
  Future<int> insertFamilyMember(FamilyMembersCompanion member) =>
      into(familyMembers).insert(member);

  /// Update a family member
  Future<bool> updateFamilyMember(FamilyMemberEntity member) =>
      update(familyMembers).replace(member);

  /// Delete a family member
  Future<int> deleteFamilyMember(int id) =>
      (delete(familyMembers)..where((f) => f.id.equals(id))).go();

  /// Delete all family members for an occupancy
  Future<int> deleteFamilyMembersForOccupancy(int occupancyId) => (delete(
    familyMembers,
  )..where((f) => f.occupancyId.equals(occupancyId))).go();

  /// Count family members for an occupancy
  Future<int> countFamilyMembersForOccupancy(int occupancyId) async {
    final members = await getFamilyMembersForOccupancy(occupancyId);
    return members.length;
  }
}
