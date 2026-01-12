/// Property-related providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/room.dart';
import 'repository_providers.dart';

part 'property_providers.g.dart';

/// Watch all properties (auto-updates when data changes).
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
/// This provider auto-refreshes when propertiesStream emits new data.
@riverpod
Future<Property?> property(PropertyRef ref, int id) async {
  // Watch the stream to trigger refresh when properties change
  ref.watch(propertiesStreamProvider);
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getPropertyById(id);
}

/// Watch rooms for a property (auto-updates when data changes).
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
/// This provider auto-refreshes when room data changes.
@riverpod
Future<Room?> room(RoomRef ref, int id) async {
  // Watch the all rooms stream indirectly through property stream
  ref.watch(propertiesStreamProvider);
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getRoomById(id);
}

/// Get all rooms.
@riverpod
Future<List<Room>> allRooms(AllRoomsRef ref) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getAllRooms();
}
