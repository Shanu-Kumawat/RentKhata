/// Property domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart';

/// Represents a rental property.
@freezed
class Property with _$Property {
  const factory Property({
    required int id,
    required String name,
    String? address,
    String? photoPath,
    required DateTime createdAt,
    @Default(0) int roomCount,
    @Default(0) int occupiedRoomCount,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
}
