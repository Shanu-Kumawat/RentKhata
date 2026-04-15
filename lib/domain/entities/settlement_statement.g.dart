// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_statement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettlementBillDeductionImpl _$$SettlementBillDeductionImplFromJson(
  Map<String, dynamic> json,
) => _$SettlementBillDeductionImpl(
  billTypeLabel: json['billTypeLabel'] as String,
  period: json['period'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$$SettlementBillDeductionImplToJson(
  _$SettlementBillDeductionImpl instance,
) => <String, dynamic>{
  'billTypeLabel': instance.billTypeLabel,
  'period': instance.period,
  'amount': instance.amount,
};

_$SettlementStatementImpl _$$SettlementStatementImplFromJson(
  Map<String, dynamic> json,
) => _$SettlementStatementImpl(
  occupancyId: (json['occupancyId'] as num).toInt(),
  tenantName: json['tenantName'] as String,
  landlordName: json['landlordName'] as String,
  propertyName: json['propertyName'] as String,
  roomNumber: json['roomNumber'] as String,
  moveInDate: DateTime.parse(json['moveInDate'] as String),
  moveOutDate: DateTime.parse(json['moveOutDate'] as String),
  securityDeposit: (json['securityDeposit'] as num).toDouble(),
  billDeductions:
      (json['billDeductions'] as List<dynamic>?)
          ?.map(
            (e) => SettlementBillDeduction.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  manualDeduction: (json['manualDeduction'] as num).toDouble(),
  manualDeductionReason: json['manualDeductionReason'] as String?,
  totalDeductions: (json['totalDeductions'] as num).toDouble(),
  refundAmount: (json['refundAmount'] as num).toDouble(),
);

Map<String, dynamic> _$$SettlementStatementImplToJson(
  _$SettlementStatementImpl instance,
) => <String, dynamic>{
  'occupancyId': instance.occupancyId,
  'tenantName': instance.tenantName,
  'landlordName': instance.landlordName,
  'propertyName': instance.propertyName,
  'roomNumber': instance.roomNumber,
  'moveInDate': instance.moveInDate.toIso8601String(),
  'moveOutDate': instance.moveOutDate.toIso8601String(),
  'securityDeposit': instance.securityDeposit,
  'billDeductions': instance.billDeductions,
  'manualDeduction': instance.manualDeduction,
  'manualDeductionReason': instance.manualDeductionReason,
  'totalDeductions': instance.totalDeductions,
  'refundAmount': instance.refundAmount,
};
