/// Property repository interface.
library;

import '../entities/property.dart';
import '../entities/room.dart';

/// Abstract repository for property and room operations.
abstract class PropertyRepository {
  // ========== Property Operations ==========

  /// Get all properties
  Future<List<Property>> getAllProperties({bool includeArchived = false});

  /// Watch all properties
  Stream<List<Property>> watchAllProperties({bool includeArchived = false});

  /// Get property by ID
  Future<Property?> getPropertyById(int id);

  /// Create a new property
  Future<int> createProperty({
    required String name,
    String? address,
    String? photoPath,
  });

  /// Update a property
  Future<bool> updateProperty(Property property);

  /// Delete a property
  Future<bool> deleteProperty(int id);

  /// Archive/Unarchive a property
  Future<bool> archiveProperty(int id, {bool isArchived = true});

  // ========== Room Operations ==========

  /// Get all rooms for a property
  Future<List<Room>> getRoomsForProperty(int propertyId, {bool includeArchived = false});

  /// Watch rooms for a property
  Stream<List<Room>> watchRoomsForProperty(int propertyId, {bool includeArchived = false});

  /// Get room by ID
  Future<Room?> getRoomById(int id);

  /// Get all rooms
  Future<List<Room>> getAllRooms({bool includeArchived = false});

  /// Create a new room
  Future<int> createRoom({
    required int propertyId,
    required String roomNumber,
    double baseRent = 0.0,
    bool hasElectricityMeter = false,
    double currentElectricityRate = 7.0,
  });

  /// Update a room
  Future<bool> updateRoom(Room room);

  /// Delete a room
  Future<bool> deleteRoom(int id);

  /// Archive/Unarchive a room
  Future<bool> archiveRoom(int id, {bool isArchived = true});
}
