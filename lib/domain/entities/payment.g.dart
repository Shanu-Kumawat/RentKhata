// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: (json['id'] as num).toInt(),
      billId: (json['billId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      paymentMode: $enumDecode(_$PaymentModeEnumMap, json['paymentMode']),
      notes: json['notes'] as String?,
      paymentDate: DateTime.parse(json['paymentDate'] as String),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billId': instance.billId,
      'amount': instance.amount,
      'paymentMode': _$PaymentModeEnumMap[instance.paymentMode]!,
      'notes': instance.notes,
      'paymentDate': instance.paymentDate.toIso8601String(),
    };

const _$PaymentModeEnumMap = {
  PaymentMode.cash: 'cash',
  PaymentMode.upi: 'upi',
  PaymentMode.bankTransfer: 'bankTransfer',
  PaymentMode.cheque: 'cheque',
  PaymentMode.other: 'other',
};
