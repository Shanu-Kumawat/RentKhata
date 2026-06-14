/// Property repository implementation.
library;

import 'package:drift/drift.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/property_repository.dart';
import '../database/app_database.dart';
import '../database/daos/property_dao.dart';
import '../database/daos/tenant_dao.dart';

/// Implementation of [PropertyRepository] using Drift database.
class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyDao _propertyDao;
  final TenantDao _tenantDao;

  PropertyRepositoryImpl(this._propertyDao, this._tenantDao);

  /// Convert property entity to domain model with room counts
  Future<Property> _propertyToDomain(PropertyEntity entity) async {
    final rooms = await _propertyDao.getRoomsForProperty(entity.id);
    int occupiedCount = 0;

    for (final room in rooms) {
      final occupancy = await _tenantDao.getActiveOccupancyForRoom(room.id);
      if (occupancy != null) occupiedCount++;
    }

    return Property(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      photoPath: entity.photoPath,
      createdAt: entity.createdAt,
      roomCount: rooms.length,
      occupiedRoomCount: occupiedCount,
      isArchived: entity.isArchived,
    );
  }

  /// Convert room entity to domain model with tenant info
  Future<Room> _roomToDomain(RoomEntity entity, {String? propertyName}) async {
    final occupancy = await _tenantDao.getActiveOccupancyForRoom(entity.id);
    String? tenantName;

    if (occupancy != null) {
      final tenant = await _tenantDao.getTenantById(occupancy.tenantId);
      tenantName = tenant?.name;
    }

    return Room(
      id: entity.id,
      propertyId: entity.propertyId,
      roomNumber: entity.roomNumber,
      baseRent: entity.baseRent,
      hasElectricityMeter: entity.hasElectricityMeter,
      currentElectricityRate: entity.currentElectricityRate,
      createdAt: entity.createdAt,
      propertyName: propertyName,
      currentTenantName: tenantName,
      currentOccupancyId: occupancy?.id,
      isOccupied: occupancy != null,
      isArchived: entity.isArchived,
    );
  }

  // ========== Property Operations ==========

  @override
  Future<List<Property>> getAllProperties({bool includeArchived = false}) async {
    final entities = await _propertyDao.getAllProperties(includeArchived: includeArchived);
    return Future.wait(entities.map(_propertyToDomain));
  }

  @override
  Stream<List<Property>> watchAllProperties({bool includeArchived = false}) {
    return _propertyDao.watchAllProperties(includeArchived: includeArchived).asyncMap(
      (entities) => Future.wait(entities.map(_propertyToDomain)),
    );
  }

  @override
  Future<Property?> getPropertyById(int id) async {
    final entity = await _propertyDao.getPropertyById(id);
    return entity != null ? _propertyToDomain(entity) : null;
  }

  @override
  Future<int> createProperty({
    required String name,
    String? address,
    String? photoPath,
  }) async {
    final property = PropertiesCompanion(
      name: Value(name),
      address: Value(address),
      photoPath: Value(photoPath),
    );
    return _propertyDao.insertProperty(property);
  }

  @override
  Future<bool> updateProperty(Property property) async {
    final entity = PropertyEntity(
      id: property.id,
      name: property.name,
      address: property.address,
      photoPath: property.photoPath,
      createdAt: property.createdAt,
      isArchived: property.isArchived,
    );
    return _propertyDao.updateProperty(entity);
  }

  @override
  Future<bool> deleteProperty(int id) async {
    final rooms = await _propertyDao.getRoomsForProperty(id, includeArchived: true);
    if (rooms.isNotEmpty) {
      throw StateError('Cannot delete a property that contains rooms. Please delete the rooms first.');
    }
    final result = await _propertyDao.deleteProperty(id);
    return result > 0;
  }

  @override
  Future<bool> archiveProperty(int id, {bool isArchived = true}) async {
    if (isArchived) {
      // Check if property has any rooms with active tenants
      final rooms = await _propertyDao.getRoomsForProperty(id, includeArchived: true);
      for (final room in rooms) {
        final occupancy = await _tenantDao.getActiveOccupancyForRoom(room.id);
        if (occupancy != null) {
          throw StateError('Cannot archive a property that has rooms with active tenants. Move them out first.');
        }
      }
    }
    final result = await _propertyDao.archiveProperty(id, isArchived: isArchived);
    return result > 0;
  }

  // ========== Room Operations ==========

  @override
  Future<List<Room>> getRoomsForProperty(int propertyId, {bool includeArchived = false}) async {
    final property = await _propertyDao.getPropertyById(propertyId);
    final entities = await _propertyDao.getRoomsForProperty(propertyId, includeArchived: includeArchived);
    return Future.wait(
      entities.map((e) => _roomToDomain(e, propertyName: property?.name)),
    );
  }

  @override
  Stream<List<Room>> watchRoomsForProperty(int propertyId, {bool includeArchived = false}) {
    return _propertyDao.watchRoomsForProperty(propertyId, includeArchived: includeArchived).asyncMap((
      entities,
    ) async {
      final property = await _propertyDao.getPropertyById(propertyId);
      return Future.wait(
        entities.map((e) => _roomToDomain(e, propertyName: property?.name)),
      );
    });
  }

  @override
  Future<Room?> getRoomById(int id) async {
    final entity = await _propertyDao.getRoomById(id);
    if (entity == null) return null;

    final property = await _propertyDao.getPropertyById(entity.propertyId);
    return _roomToDomain(entity, propertyName: property?.name);
  }

  @override
  Future<List<Room>> getAllRooms({bool includeArchived = false}) async {
    final entities = await _propertyDao.getAllRooms(includeArchived: includeArchived);
    return Future.wait(entities.map((e) async {
      final property = await _propertyDao.getPropertyById(e.propertyId);
      return _roomToDomain(e, propertyName: property?.name);
    }));
  }

  @override
  Future<int> createRoom({
    required int propertyId,
    required String roomNumber,
    double baseRent = 0.0,
    bool hasElectricityMeter = false,
    double currentElectricityRate = 7.0,
  }) async {
    final room = RoomsCompanion(
      propertyId: Value(propertyId),
      roomNumber: Value(roomNumber),
      baseRent: Value(baseRent),
      hasElectricityMeter: Value(hasElectricityMeter),
      currentElectricityRate: Value(currentElectricityRate),
    );
    return _propertyDao.insertRoom(room);
  }

  @override
  Future<bool> updateRoom(Room room) async {
    final entity = RoomEntity(
      id: room.id,
      propertyId: room.propertyId,
      roomNumber: room.roomNumber,
      baseRent: room.baseRent,
      hasElectricityMeter: room.hasElectricityMeter,
      currentElectricityRate: room.currentElectricityRate,
      createdAt: room.createdAt,
      isArchived: room.isArchived,
    );
    return _propertyDao.updateRoom(entity);
  }

  @override
  Future<bool> deleteRoom(int id) async {
    final occupancies = await _tenantDao.getOccupanciesForRoom(id);
    if (occupancies.isNotEmpty) {
      throw StateError('Cannot delete a room that has tenant history. Please archive it instead to keep your financial records intact.');
    }
    final result = await _propertyDao.deleteRoom(id);
    return result > 0;
  }

  @override
  Future<bool> archiveRoom(int id, {bool isArchived = true}) async {
    if (isArchived) {
      final occupancy = await _tenantDao.getActiveOccupancyForRoom(id);
      if (occupancy != null) {
        throw StateError('Cannot archive a room that has an active tenant. Move them out first.');
      }
    }
    final result = await _propertyDao.archiveRoom(id, isArchived: isArchived);
    return result > 0;
  }
}
