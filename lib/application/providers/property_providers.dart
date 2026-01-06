/// Property-related providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/room.dart';
import 'repository_providers.dart';

part 'property_providers.g.dart';

/// Watch all properties.
@riverpod
Stream<List<Property>> propertiesStream(PropertiesStreamRef ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.watchAllProperties();
}

/// Get all properties (future).
@riverpod
Future<List<Property>> properties(PropertiesRef ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getAllProperties();
}

/// Get a single property by ID.
@riverpod
Future<Property?> property(PropertyRef ref, int id) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getPropertyById(id);
}

/// Watch rooms for a property.
@riverpod
Stream<List<Room>> roomsForPropertyStream(
  RoomsForPropertyStreamRef ref,
  int propertyId,
) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.watchRoomsForProperty(propertyId);
}

/// Get rooms for a property.
@riverpod
Future<List<Room>> roomsForProperty(RoomsForPropertyRef ref, int propertyId) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getRoomsForProperty(propertyId);
}

/// Get a single room by ID.
@riverpod
Future<Room?> room(RoomRef ref, int id) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getRoomById(id);
}

/// Get all rooms.
@riverpod
Future<List<Room>> allRooms(AllRoomsRef ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getAllRooms();
}
