/// Room domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

/// Represents a room within a property.
@freezed
class Room with _$Room {
  const factory Room({
    required int id,
    required int propertyId,
    required String roomNumber,
    @Default(0.0) double baseRent,
    @Default(false) bool hasElectricityMeter,
    @Default(7.0) double currentElectricityRate,
    required DateTime createdAt,
    // Denormalized fields for convenience
    String? propertyName,
    String? currentTenantName,
    int? currentOccupancyId,
    @Default(false) bool isOccupied,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
