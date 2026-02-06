/// Landlord domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'landlord.freezed.dart';
part 'landlord.g.dart';

/// Represents a landlord's profile.
@freezed
class Landlord with _$Landlord {
  const factory Landlord({
    required int id,
    required String name,
    String? upiId,
    String? phone,
    String? photoPath,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Landlord;

  factory Landlord.fromJson(Map<String, dynamic> json) =>
      _$LandlordFromJson(json);
}
