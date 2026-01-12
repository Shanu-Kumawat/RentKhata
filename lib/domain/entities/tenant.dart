/// Tenant domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

/// Represents a tenant profile.
@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    required int id,
    required String name,
    String? phone,
    String? aadharNumber,
    String? photoPath,
    @Default(false) bool isPoliceVerified,
    String? policeVerificationDocPath,
    required DateTime createdAt,
    // Denormalized fields
    int? currentRoomId,
    String? currentRoomNumber,
    String? currentPropertyName,
    @Default(false) bool isCurrentlyOccupying,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}

/// Represents a custom field for a tenant.
@freezed
class CustomField with _$CustomField {
  const factory CustomField({
    required int id,
    required int tenantId,
    required String fieldName,
    required String fieldValue,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);
}
