// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phone: json['phone'] as String?,
  aadharNumber: json['aadharNumber'] as String?,
  photoPath: json['photoPath'] as String?,
  isPoliceVerified: json['isPoliceVerified'] as bool? ?? false,
  policeVerificationDocPath: json['policeVerificationDocPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  currentRoomId: (json['currentRoomId'] as num?)?.toInt(),
  currentRoomNumber: json['currentRoomNumber'] as String?,
  currentPropertyName: json['currentPropertyName'] as String?,
  isCurrentlyOccupying: json['isCurrentlyOccupying'] as bool? ?? false,
);

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'aadharNumber': instance.aadharNumber,
      'photoPath': instance.photoPath,
      'isPoliceVerified': instance.isPoliceVerified,
      'policeVerificationDocPath': instance.policeVerificationDocPath,
      'createdAt': instance.createdAt.toIso8601String(),
      'currentRoomId': instance.currentRoomId,
      'currentRoomNumber': instance.currentRoomNumber,
      'currentPropertyName': instance.currentPropertyName,
      'isCurrentlyOccupying': instance.isCurrentlyOccupying,
    };

_$CustomFieldImpl _$$CustomFieldImplFromJson(Map<String, dynamic> json) =>
    _$CustomFieldImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenantId'] as num).toInt(),
      fieldName: json['fieldName'] as String,
      fieldValue: json['fieldValue'] as String,
    );

Map<String, dynamic> _$$CustomFieldImplToJson(_$CustomFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'fieldName': instance.fieldName,
      'fieldValue': instance.fieldValue,
    };
