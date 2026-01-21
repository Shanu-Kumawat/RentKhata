// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingAttentionItemImpl _$$BillingAttentionItemImplFromJson(
  Map<String, dynamic> json,
) => _$BillingAttentionItemImpl(
  occupancyId: (json['occupancyId'] as num).toInt(),
  roomId: (json['roomId'] as num).toInt(),
  roomNumber: json['roomNumber'] as String,
  tenantName: json['tenantName'] as String,
  cycleStart: DateTime.parse(json['cycleStart'] as String),
  cycleEnd: DateTime.parse(json['cycleEnd'] as String),
  status: $enumDecode(_$BillingCycleStatusEnumMap, json['status']),
  billType: $enumDecode(_$BillTypeEnumMap, json['billType']),
  daysUntilCycleEnd: (json['daysUntilCycleEnd'] as num).toInt(),
  agreedRent: (json['agreedRent'] as num).toDouble(),
  propertyName: json['propertyName'] as String?,
);

Map<String, dynamic> _$$BillingAttentionItemImplToJson(
  _$BillingAttentionItemImpl instance,
) => <String, dynamic>{
  'occupancyId': instance.occupancyId,
  'roomId': instance.roomId,
  'roomNumber': instance.roomNumber,
  'tenantName': instance.tenantName,
  'cycleStart': instance.cycleStart.toIso8601String(),
  'cycleEnd': instance.cycleEnd.toIso8601String(),
  'status': _$BillingCycleStatusEnumMap[instance.status]!,
  'billType': _$BillTypeEnumMap[instance.billType]!,
  'daysUntilCycleEnd': instance.daysUntilCycleEnd,
  'agreedRent': instance.agreedRent,
  'propertyName': instance.propertyName,
};

const _$BillingCycleStatusEnumMap = {
  BillingCycleStatus.upToDate: 'upToDate',
  BillingCycleStatus.dueSoon: 'dueSoon',
  BillingCycleStatus.overdue: 'overdue',
};

const _$BillTypeEnumMap = {
  BillType.rent: 'rent',
  BillType.electricity: 'electricity',
  BillType.water: 'water',
  BillType.maintenance: 'maintenance',
  BillType.other: 'other',
};
