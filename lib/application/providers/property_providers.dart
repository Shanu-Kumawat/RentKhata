/// Property-related providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/room.dart';
import 'repository_providers.dart';

part 'property_providers.g.dart';

/// Watch all properties (auto-updates when data changes).
@riverpod
Stream<List<Property>> propertiesStream(Ref ref, {bool includeArchived = false}) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.watchAllProperties(includeArchived: includeArchived);
}

/// Get all properties (future).
@riverpod
Future<List<Property>> properties(Ref ref, {bool includeArchived = false}) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getAllProperties(includeArchived: includeArchived);
}

/// Get a single property by ID.
/// This provider auto-refreshes when propertiesStream emits new data.
@riverpod
Future<Property?> property(Ref ref, int id) async {
  // Watch the stream to trigger refresh when properties change
  ref.watch(propertiesStreamProvider());
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getPropertyById(id);
}

/// Watch rooms for a property (auto-updates when data changes).
@riverpod
Stream<List<Room>> roomsForPropertyStream(Ref ref, int propertyId, {bool includeArchived = false}) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.watchRoomsForProperty(propertyId, includeArchived: includeArchived);
}

/// Get rooms for a property.
@riverpod
Future<List<Room>> roomsForProperty(Ref ref, int propertyId, {bool includeArchived = false}) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getRoomsForProperty(propertyId, includeArchived: includeArchived);
}

/// Get a single room by ID.
/// This provider auto-refreshes when room data changes.
@riverpod
Future<Room?> room(Ref ref, int id) async {
  // Watch the all rooms stream indirectly through property stream
  ref.watch(propertiesStreamProvider());
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getRoomById(id);
}

/// Get all rooms.
@riverpod
Future<List<Room>> allRooms(Ref ref, {bool includeArchived = false}) {
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getAllRooms(includeArchived: includeArchived);
}
