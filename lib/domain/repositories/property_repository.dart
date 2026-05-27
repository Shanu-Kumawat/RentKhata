/// Property repository interface.
library;

import '../entities/property.dart';
import '../entities/room.dart';

/// Abstract repository for property and room operations.
abstract class PropertyRepository {
  // ========== Property Operations ==========

  /// Get all properties
  Future<List<Property>> getAllProperties();

  /// Watch all properties
  Stream<List<Property>> watchAllProperties();

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

  // ========== Room Operations ==========

  /// Get all rooms for a property
  Future<List<Room>> getRoomsForProperty(int propertyId);

  /// Watch rooms for a property
  Stream<List<Room>> watchRoomsForProperty(int propertyId);

  /// Get room by ID
  Future<Room?> getRoomById(int id);

  /// Get all rooms
  Future<List<Room>> getAllRooms();

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
}
