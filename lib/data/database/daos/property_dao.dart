/// Property Data Access Object.
library;

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/property_table.dart';
import '../tables/room_table.dart';
import '../tables/occupancy_table.dart';

part 'property_dao.g.dart';

/// DAO for property and room operations.
@DriftAccessor(tables: [Properties, Rooms, Occupancies])
class PropertyDao extends DatabaseAccessor<AppDatabase>
    with _$PropertyDaoMixin {
  PropertyDao(super.db);

  // ========== Property Operations ==========

  /// Get all properties (excluding archived by default)
  Future<List<PropertyEntity>> getAllProperties({bool includeArchived = false}) {
    if (includeArchived) {
      return select(properties).get();
    }
    return (select(properties)..where((p) => p.isArchived.equals(false))).get();
  }

  /// Watch all properties (reacts to room and occupancy changes)
  Stream<List<PropertyEntity>> watchAllProperties({bool includeArchived = false}) {
    final query = select(properties).join([
      leftOuterJoin(rooms, rooms.propertyId.equalsExp(properties.id)),
      leftOuterJoin(occupancies, occupancies.roomId.equalsExp(rooms.id)),
    ]);
    if (!includeArchived) {
      query.where(properties.isArchived.equals(false));
    }
    query.groupBy([properties.id]);
    return query.watch().map((rows) => rows.map((r) => r.readTable(properties)).toList());
  }

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

  /// Archive a property
  Future<int> archiveProperty(int id, {bool isArchived = true}) =>
      (update(properties)..where((p) => p.id.equals(id)))
          .write(PropertiesCompanion(isArchived: Value(isArchived)));

  // ========== Room Operations ==========

  /// Get all rooms for a property
  Future<List<RoomEntity>> getRoomsForProperty(int propertyId, {bool includeArchived = false}) {
    final query = select(rooms)..where((r) => r.propertyId.equals(propertyId));
    if (!includeArchived) {
      query.where((r) => r.isArchived.equals(false));
    }
    return query.get();
  }

  /// Watch all rooms for a property
  Stream<List<RoomEntity>> watchRoomsForProperty(int propertyId, {bool includeArchived = false}) {
    final query = select(rooms).join([
      leftOuterJoin(occupancies, occupancies.roomId.equalsExp(rooms.id))
    ]);
    query.where(rooms.propertyId.equals(propertyId));
    if (!includeArchived) {
      query.where(rooms.isArchived.equals(false));
    }
    query.groupBy([rooms.id]);
    return query.watch().map((rows) => rows.map((r) => r.readTable(rooms)).toList());
  }

  /// Get room by ID
  Future<RoomEntity?> getRoomById(int id) =>
      (select(rooms)..where((r) => r.id.equals(id))).getSingleOrNull();

  /// Get all rooms
  Future<List<RoomEntity>> getAllRooms({bool includeArchived = false}) {
    final query = select(rooms).join([
      innerJoin(properties, properties.id.equalsExp(rooms.propertyId))
    ]);

    if (!includeArchived) {
      query.where(rooms.isArchived.equals(false) & properties.isArchived.equals(false));
    }

    return query.map((row) => row.readTable(rooms)).get();
  }

  /// Watch all rooms
  Stream<List<RoomEntity>> watchAllRooms({bool includeArchived = false}) {
    final query = select(rooms).join([
      innerJoin(properties, properties.id.equalsExp(rooms.propertyId)),
      leftOuterJoin(occupancies, occupancies.roomId.equalsExp(rooms.id))
    ]);

    if (!includeArchived) {
      query.where(rooms.isArchived.equals(false) & properties.isArchived.equals(false));
    }
    
    query.groupBy([rooms.id]);
    return query.watch().map((rows) => rows.map((r) => r.readTable(rooms)).toList());
  }

  /// Insert a room
  Future<int> insertRoom(RoomsCompanion room) => into(rooms).insert(room);

  /// Update a room
  Future<bool> updateRoom(RoomEntity room) => update(rooms).replace(room);

  /// Delete a room
  Future<int> deleteRoom(int id) =>
      (delete(rooms)..where((r) => r.id.equals(id))).go();

  /// Archive a room
  Future<int> archiveRoom(int id, {bool isArchived = true}) =>
      (update(rooms)..where((r) => r.id.equals(id)))
          .write(RoomsCompanion(isArchived: Value(isArchived)));

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
