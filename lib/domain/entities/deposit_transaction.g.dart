// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DepositTransactionImpl _$$DepositTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$DepositTransactionImpl(
  id: (json['id'] as num).toInt(),
  occupancyId: (json['occupancyId'] as num).toInt(),
  transactionType: $enumDecode(
    _$DepositTransactionTypeEnumMap,
    json['transactionType'],
  ),
  amount: (json['amount'] as num).toDouble(),
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$DepositTransactionImplToJson(
  _$DepositTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'occupancyId': instance.occupancyId,
  'transactionType': _$DepositTransactionTypeEnumMap[instance.transactionType]!,
  'amount': instance.amount,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$DepositTransactionTypeEnumMap = {
  DepositTransactionType.received: 'received',
  DepositTransactionType.deduction: 'deduction',
  DepositTransactionType.returned: 'returned',
};
