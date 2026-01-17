// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillImpl _$$BillImplFromJson(Map<String, dynamic> json) => _$BillImpl(
  id: (json['id'] as num).toInt(),
  occupancyId: (json['occupancyId'] as num).toInt(),
  billType: $enumDecode(_$BillTypeEnumMap, json['billType']),
  billingMonth: (json['billingMonth'] as num).toInt(),
  billingYear: (json['billingYear'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  billNumber: json['billNumber'] as String?,
  status:
      $enumDecodeNullable(_$BillStatusEnumMap, json['status']) ??
      BillStatus.draft,
  electricityPrevReading: (json['electricityPrevReading'] as num?)?.toDouble(),
  electricityCurrReading: (json['electricityCurrReading'] as num?)?.toDouble(),
  electricityRateAtBilling: (json['electricityRateAtBilling'] as num?)
      ?.toDouble(),
  electricityCharges: (json['electricityCharges'] as num?)?.toDouble(),
  meterPhotoPath: json['meterPhotoPath'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  periodStartDate: json['periodStartDate'] == null
      ? null
      : DateTime.parse(json['periodStartDate'] as String),
  periodEndDate: json['periodEndDate'] == null
      ? null
      : DateTime.parse(json['periodEndDate'] as String),
  paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
  pendingAmount: (json['pendingAmount'] as num?)?.toDouble() ?? 0.0,
  roomNumber: json['roomNumber'] as String?,
  tenantName: json['tenantName'] as String?,
  propertyName: json['propertyName'] as String?,
);

Map<String, dynamic> _$$BillImplToJson(_$BillImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'occupancyId': instance.occupancyId,
      'billType': _$BillTypeEnumMap[instance.billType]!,
      'billingMonth': instance.billingMonth,
      'billingYear': instance.billingYear,
      'amount': instance.amount,
      'billNumber': instance.billNumber,
      'status': _$BillStatusEnumMap[instance.status]!,
      'electricityPrevReading': instance.electricityPrevReading,
      'electricityCurrReading': instance.electricityCurrReading,
      'electricityRateAtBilling': instance.electricityRateAtBilling,
      'electricityCharges': instance.electricityCharges,
      'meterPhotoPath': instance.meterPhotoPath,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'periodStartDate': instance.periodStartDate?.toIso8601String(),
      'periodEndDate': instance.periodEndDate?.toIso8601String(),
      'paidAmount': instance.paidAmount,
      'pendingAmount': instance.pendingAmount,
      'roomNumber': instance.roomNumber,
      'tenantName': instance.tenantName,
      'propertyName': instance.propertyName,
    };

const _$BillTypeEnumMap = {
  BillType.rent: 'rent',
  BillType.electricity: 'electricity',
  BillType.water: 'water',
  BillType.maintenance: 'maintenance',
  BillType.other: 'other',
};

const _$BillStatusEnumMap = {
  BillStatus.draft: 'draft',
  BillStatus.sent: 'sent',
  BillStatus.partial: 'partial',
  BillStatus.paid: 'paid',
  BillStatus.overdue: 'overdue',
  BillStatus.voided: 'voided',
};
