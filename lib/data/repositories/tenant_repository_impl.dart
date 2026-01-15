/// Tenant repository implementation.
library;

import 'package:drift/drift.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/entities/occupancy.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../database/app_database.dart';
import '../database/daos/tenant_dao.dart';
import '../database/daos/property_dao.dart';

/// Implementation of [TenantRepository] using Drift database.
class TenantRepositoryImpl implements TenantRepository {
  final TenantDao _tenantDao;
  final PropertyDao _propertyDao;

  TenantRepositoryImpl(this._tenantDao, this._propertyDao);

  /// Convert tenant entity to domain model with current occupancy info
  Future<Tenant> _tenantToDomain(TenantEntity entity) async {
    final occupancies = await _tenantDao.getOccupanciesForTenant(entity.id);
    final activeOccupancy = occupancies.where((o) => o.isActive).firstOrNull;

    String? roomNumber;
    String? propertyName;

    if (activeOccupancy != null) {
      final room = await _propertyDao.getRoomById(activeOccupancy.roomId);
      roomNumber = room?.roomNumber;
      if (room != null) {
        final property = await _propertyDao.getPropertyById(room.propertyId);
        propertyName = property?.name;
      }
    }

    return Tenant(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      aadharNumber: entity.aadharNumber,
      photoPath: entity.photoPath,
      isPoliceVerified: entity.isPoliceVerified,
      policeVerificationDocPath: entity.policeVerificationDocPath,
      createdAt: entity.createdAt,
      // New profile fields
      fatherName: entity.fatherName,
      age: entity.age,
      gender: entity.gender,
      secondaryPhone: entity.secondaryPhone,
      permanentAddressLine: entity.permanentAddressLine,
      permanentCity: entity.permanentCity,
      permanentState: entity.permanentState,
      permanentPincode: entity.permanentPincode,
      companyName: entity.companyName,
      officeAddress: entity.officeAddress,
      aadhaarFrontPhotoPath: entity.aadhaarFrontPhotoPath,
      aadhaarBackPhotoPath: entity.aadhaarBackPhotoPath,
      introducerName: entity.introducerName,
      introducerAddress: entity.introducerAddress,
      introducerPhone: entity.introducerPhone,
      // Denormalized fields
      currentRoomId: activeOccupancy?.roomId,
      currentRoomNumber: roomNumber,
      currentPropertyName: propertyName,
      isCurrentlyOccupying: activeOccupancy != null,
    );
  }

  /// Convert occupancy entity to domain model
  Future<Occupancy> _occupancyToDomain(OccupancyEntity entity) async {
    final room = await _propertyDao.getRoomById(entity.roomId);
    final tenant = await _tenantDao.getTenantById(entity.tenantId);
    String? propertyName;

    if (room != null) {
      final property = await _propertyDao.getPropertyById(room.propertyId);
      propertyName = property?.name;
    }

    return Occupancy(
      id: entity.id,
      roomId: entity.roomId,
      tenantId: entity.tenantId,
      moveInDate: entity.moveInDate,
      moveOutDate: entity.moveOutDate,
      agreedRent: entity.agreedRent,
      securityDeposit: entity.securityDeposit,
      isActive: entity.isActive,
      roomNumber: room?.roomNumber,
      tenantName: tenant?.name,
      propertyName: propertyName,
    );
  }

  // ========== Tenant Operations ==========

  @override
  Future<List<Tenant>> getAllTenants() async {
    final entities = await _tenantDao.getAllTenants();
    return Future.wait(entities.map(_tenantToDomain));
  }

  @override
  Stream<List<Tenant>> watchAllTenants() {
    return _tenantDao.watchAllTenants().asyncMap(
      (entities) => Future.wait(entities.map(_tenantToDomain)),
    );
  }

  @override
  Future<Tenant?> getTenantById(int id) async {
    final entity = await _tenantDao.getTenantById(id);
    return entity != null ? _tenantToDomain(entity) : null;
  }

  @override
  Future<List<Tenant>> searchTenants(String query) async {
    final entities = await _tenantDao.searchTenants(query);
    return Future.wait(entities.map(_tenantToDomain));
  }

  @override
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
  }) async {
    final tenant = TenantsCompanion(
      name: Value(name),
      phone: Value(phone),
      aadharNumber: Value(aadharNumber),
      photoPath: Value(photoPath),
      isPoliceVerified: Value(isPoliceVerified),
      policeVerificationDocPath: Value(policeVerificationDocPath),
      fatherName: Value(fatherName),
      age: Value(age),
      gender: Value(gender),
      secondaryPhone: Value(secondaryPhone),
      permanentAddressLine: Value(permanentAddressLine),
      permanentCity: Value(permanentCity),
      permanentState: Value(permanentState),
      permanentPincode: Value(permanentPincode),
      companyName: Value(companyName),
      officeAddress: Value(officeAddress),
      aadhaarFrontPhotoPath: Value(aadhaarFrontPhotoPath),
      aadhaarBackPhotoPath: Value(aadhaarBackPhotoPath),
      introducerName: Value(introducerName),
      introducerAddress: Value(introducerAddress),
      introducerPhone: Value(introducerPhone),
    );
    return _tenantDao.insertTenant(tenant);
  }

  @override
  Future<bool> updateTenant(Tenant tenant) async {
    final entity = TenantEntity(
      id: tenant.id,
      name: tenant.name,
      phone: tenant.phone,
      aadharNumber: tenant.aadharNumber,
      photoPath: tenant.photoPath,
      isPoliceVerified: tenant.isPoliceVerified,
      policeVerificationDocPath: tenant.policeVerificationDocPath,
      createdAt: tenant.createdAt,
      fatherName: tenant.fatherName,
      age: tenant.age,
      gender: tenant.gender,
      secondaryPhone: tenant.secondaryPhone,
      permanentAddressLine: tenant.permanentAddressLine,
      permanentCity: tenant.permanentCity,
      permanentState: tenant.permanentState,
      permanentPincode: tenant.permanentPincode,
      companyName: tenant.companyName,
      officeAddress: tenant.officeAddress,
      aadhaarFrontPhotoPath: tenant.aadhaarFrontPhotoPath,
      aadhaarBackPhotoPath: tenant.aadhaarBackPhotoPath,
      introducerName: tenant.introducerName,
      introducerAddress: tenant.introducerAddress,
      introducerPhone: tenant.introducerPhone,
    );
    return _tenantDao.updateTenant(entity);
  }

  @override
  Future<bool> deleteTenant(int id) async {
    final result = await _tenantDao.deleteTenant(id);
    return result > 0;
  }

  // ========== Custom Field Operations ==========

  @override
  Future<List<CustomField>> getCustomFieldsForTenant(int tenantId) async {
    final entities = await _tenantDao.getCustomFieldsForTenant(tenantId);
    return entities
        .map(
          (e) => CustomField(
            id: e.id,
            tenantId: e.tenantId,
            fieldName: e.fieldName,
            fieldValue: e.fieldValue,
          ),
        )
        .toList();
  }

  @override
  Future<int> addCustomField({
    required int tenantId,
    required String fieldName,
    required String fieldValue,
  }) async {
    final field = CustomFieldsCompanion(
      tenantId: Value(tenantId),
      fieldName: Value(fieldName),
      fieldValue: Value(fieldValue),
    );
    return _tenantDao.insertCustomField(field);
  }

  @override
  Future<bool> updateCustomField(CustomField field) async {
    final entity = CustomFieldEntity(
      id: field.id,
      tenantId: field.tenantId,
      fieldName: field.fieldName,
      fieldValue: field.fieldValue,
    );
    return _tenantDao.updateCustomField(entity);
  }

  @override
  Future<bool> deleteCustomField(int id) async {
    final result = await _tenantDao.deleteCustomField(id);
    return result > 0;
  }

  // ========== Occupancy Operations ==========

  @override
  Future<List<Occupancy>> getActiveOccupancies() async {
    final entities = await _tenantDao.getActiveOccupancies();
    return Future.wait(entities.map(_occupancyToDomain));
  }

  @override
  Stream<List<Occupancy>> watchActiveOccupancies() {
    return _tenantDao.watchActiveOccupancies().asyncMap(
      (entities) => Future.wait(entities.map(_occupancyToDomain)),
    );
  }

  @override
  Future<Occupancy?> getActiveOccupancyForRoom(int roomId) async {
    final entity = await _tenantDao.getActiveOccupancyForRoom(roomId);
    return entity != null ? _occupancyToDomain(entity) : null;
  }

  @override
  Future<List<Occupancy>> getOccupanciesForTenant(int tenantId) async {
    final entities = await _tenantDao.getOccupanciesForTenant(tenantId);
    return Future.wait(entities.map(_occupancyToDomain));
  }

  @override
  Future<int> createOccupancy({
    required int roomId,
    required int tenantId,
    required DateTime moveInDate,
    required double agreedRent,
    double securityDeposit = 0.0,
  }) async {
    final occupancy = OccupanciesCompanion(
      roomId: Value(roomId),
      tenantId: Value(tenantId),
      moveInDate: Value(moveInDate),
      agreedRent: Value(agreedRent),
      securityDeposit: Value(securityDeposit),
      isActive: const Value(true),
    );
    return _tenantDao.insertOccupancy(occupancy);
  }

  @override
  Future<bool> endOccupancy(int occupancyId, DateTime moveOutDate) async {
    return _tenantDao.endOccupancy(occupancyId, moveOutDate);
  }

  @override
  Future<Tenant?> getTenantByRoom(int roomId) async {
    final entity = await _tenantDao.getTenantByRoom(roomId);
    return entity != null ? _tenantToDomain(entity) : null;
  }
}
