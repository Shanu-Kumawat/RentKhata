/// Tenant repository interface.
library;

import '../entities/tenant.dart';
import '../entities/occupancy.dart';

/// Abstract repository for tenant and occupancy operations.
abstract class TenantRepository {
  // ========== Tenant Operations ==========

  /// Get all tenants
  Future<List<Tenant>> getAllTenants();

  /// Watch all tenants
  Stream<List<Tenant>> watchAllTenants();

  /// Get tenant by ID
  Future<Tenant?> getTenantById(int id);

  /// Search tenants by name or phone
  Future<List<Tenant>> searchTenants(String query);

  /// Create a new tenant
  Future<int> createTenant({
    required String name,
    String? phone,
    String? aadharNumber,
    String? photoPath,
    bool isPoliceVerified = false,
    String? policeVerificationDocPath,
    // Identity fields
    String? fatherName,
    int? age,
    String? gender,
    // Additional contact
    String? secondaryPhone,
    // Permanent address
    String? permanentAddressLine,
    String? permanentCity,
    String? permanentState,
    String? permanentPincode,
    // Work details
    String? companyName,
    String? officeAddress,
    // ID document photos
    String? aadhaarFrontPhotoPath,
    String? aadhaarBackPhotoPath,
    // Introducer/Reference
    String? introducerName,
    String? introducerAddress,
    String? introducerPhone,
  });

  /// Update a tenant
  Future<bool> updateTenant(Tenant tenant);

  /// Delete a tenant
  Future<bool> deleteTenant(int id);

  // ========== Custom Field Operations ==========

  /// Get custom fields for a tenant
  Future<List<CustomField>> getCustomFieldsForTenant(int tenantId);

  /// Add a custom field
  Future<int> addCustomField({
    required int tenantId,
    required String fieldName,
    required String fieldValue,
  });

  /// Update a custom field
  Future<bool> updateCustomField(CustomField field);

  /// Delete a custom field
  Future<bool> deleteCustomField(int id);

  // ========== Occupancy Operations ==========

  /// Get all active occupancies
  Future<List<Occupancy>> getActiveOccupancies();

  /// Watch active occupancies
  Stream<List<Occupancy>> watchActiveOccupancies();

  /// Get occupancy for a room
  Future<Occupancy?> getActiveOccupancyForRoom(int roomId);

  /// Get occupancy history for a tenant
  Future<List<Occupancy>> getOccupanciesForTenant(int tenantId);

  /// Create a new occupancy (move tenant into room)
  Future<int> createOccupancy({
    required int roomId,
    required int tenantId,
    required DateTime moveInDate,
    required double agreedRent,
    double securityDeposit = 0.0,
  });

  /// End an occupancy (move tenant out)
  Future<bool> endOccupancy(int occupancyId, DateTime moveOutDate);

  /// Get tenant for a room
  Future<Tenant?> getTenantByRoom(int roomId);
}
