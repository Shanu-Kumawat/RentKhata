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
    // Identity fields
    String? fatherName,
    int? age,
    String? gender,
    // Additional contact
    String? secondaryPhone,
    // Permanent address
    String? permanentAddressLine,
    String? permanentCity,
    String? permanentState,
    String? permanentPincode,
    // Work details
    String? companyName,
    String? officeAddress,
    // ID document photos
    String? aadhaarFrontPhotoPath,
    String? aadhaarBackPhotoPath,
    // Introducer/Reference
    String? introducerName,
    String? introducerAddress,
    String? introducerPhone,
    // Denormalized fields
    int? currentRoomId,
    String? currentRoomNumber,
    String? currentPropertyName,
    @Default(false) bool isCurrentlyOccupying,
    @Default(false) bool isArchived,
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
