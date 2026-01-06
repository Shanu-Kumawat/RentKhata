/// Property Data Access Object.
library;

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/property_table.dart';
import '../tables/room_table.dart';

part 'property_dao.g.dart';

/// DAO for property and room operations.
@DriftAccessor(tables: [Properties, Rooms])
class PropertyDao extends DatabaseAccessor<AppDatabase>
    with _$PropertyDaoMixin {
  PropertyDao(super.db);

  // ========== Property Operations ==========

  /// Get all properties
  Future<List<PropertyEntity>> getAllProperties() => select(properties).get();

  /// Watch all properties
  Stream<List<PropertyEntity>> watchAllProperties() =>
      select(properties).watch();

  /// Get property by ID
  Future<PropertyEntity?> getPropertyById(int id) =>
      (select(properties)..where((p) => p.id.equals(id))).getSingleOrNull();

  /// Insert a property
  Future<int> insertProperty(PropertiesCompanion property) =>
      into(properties).insert(property);

  /// Update a property
  Future<bool> updateProperty(PropertyEntity property) =>
      update(properties).replace(property);

  /// Delete a property
  Future<int> deleteProperty(int id) =>
      (delete(properties)..where((p) => p.id.equals(id))).go();

  // ========== Room Operations ==========

  /// Get all rooms for a property
  Future<List<RoomEntity>> getRoomsForProperty(int propertyId) =>
      (select(rooms)..where((r) => r.propertyId.equals(propertyId))).get();

  /// Watch all rooms for a property
  Stream<List<RoomEntity>> watchRoomsForProperty(int propertyId) =>
      (select(rooms)..where((r) => r.propertyId.equals(propertyId))).watch();

  /// Get room by ID
  Future<RoomEntity?> getRoomById(int id) =>
      (select(rooms)..where((r) => r.id.equals(id))).getSingleOrNull();

  /// Get all rooms
  Future<List<RoomEntity>> getAllRooms() => select(rooms).get();

  /// Insert a room
  Future<int> insertRoom(RoomsCompanion room) => into(rooms).insert(room);

  /// Update a room
  Future<bool> updateRoom(RoomEntity room) => update(rooms).replace(room);

  /// Delete a room
  Future<int> deleteRoom(int id) =>
      (delete(rooms)..where((r) => r.id.equals(id))).go();

  /// Get property with room count
  Future<List<({PropertyEntity property, int roomCount})>>
      getPropertiesWithRoomCount() async {
    final propertyList = await getAllProperties();
    final result = <({PropertyEntity property, int roomCount})>[];

    for (final property in propertyList) {
      final roomList = await getRoomsForProperty(property.id);
      result.add((property: property, roomCount: roomList.length));
    }

    return result;
  }
}
