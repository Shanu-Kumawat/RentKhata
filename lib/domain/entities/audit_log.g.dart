// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogImpl _$$AuditLogImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogImpl(
      id: (json['id'] as num).toInt(),
      entityType: $enumDecode(_$AuditEntityTypeEnumMap, json['entityType']),
      entityId: (json['entityId'] as num).toInt(),
      action: $enumDecode(_$AuditActionEnumMap, json['action']),
      fieldName: json['fieldName'] as String?,
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AuditLogImplToJson(_$AuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': _$AuditEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
      'action': _$AuditActionEnumMap[instance.action]!,
      'fieldName': instance.fieldName,
      'oldValue': instance.oldValue,
      'newValue': instance.newValue,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AuditEntityTypeEnumMap = {
  AuditEntityType.bill: 'bill',
  AuditEntityType.payment: 'payment',
  AuditEntityType.electricityRate: 'electricityRate',
};

const _$AuditActionEnumMap = {
  AuditAction.create: 'create',
  AuditAction.update: 'update',
  AuditAction.delete: 'delete',
  AuditAction.void_: 'void_',
};
