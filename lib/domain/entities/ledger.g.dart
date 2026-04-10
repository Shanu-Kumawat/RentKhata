// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LedgerEntryImpl _$$LedgerEntryImplFromJson(Map<String, dynamic> json) =>
    _$LedgerEntryImpl(
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$LedgerEntryTypeEnumMap, json['type']),
      description: json['description'] as String,
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      billId: (json['billId'] as num?)?.toInt(),
      billType: $enumDecodeNullable(_$BillTypeEnumMap, json['billType']),
      paymentId: (json['paymentId'] as num?)?.toInt(),
      paymentMode: $enumDecodeNullable(
        _$PaymentModeEnumMap,
        json['paymentMode'],
      ),
    );

Map<String, dynamic> _$$LedgerEntryImplToJson(_$LedgerEntryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'type': _$LedgerEntryTypeEnumMap[instance.type]!,
      'description': instance.description,
      'debit': instance.debit,
      'credit': instance.credit,
      'balance': instance.balance,
      'billId': instance.billId,
      'billType': _$BillTypeEnumMap[instance.billType],
      'paymentId': instance.paymentId,
      'paymentMode': _$PaymentModeEnumMap[instance.paymentMode],
    };

const _$LedgerEntryTypeEnumMap = {
  LedgerEntryType.openingBalance: 'openingBalance',
  LedgerEntryType.billGenerated: 'billGenerated',
  LedgerEntryType.paymentReceived: 'paymentReceived',
  LedgerEntryType.discount: 'discount',
};

const _$BillTypeEnumMap = {
  BillType.rent: 'rent',
  BillType.electricity: 'electricity',
  BillType.water: 'water',
  BillType.maintenance: 'maintenance',
  BillType.other: 'other',
};

const _$PaymentModeEnumMap = {
  PaymentMode.cash: 'cash',
  PaymentMode.upi: 'upi',
  PaymentMode.bankTransfer: 'bankTransfer',
  PaymentMode.cheque: 'cheque',
  PaymentMode.other: 'other',
};

_$LedgerStatementImpl _$$LedgerStatementImplFromJson(
  Map<String, dynamic> json,
) => _$LedgerStatementImpl(
  occupancyId: (json['occupancyId'] as num).toInt(),
  tenantName: json['tenantName'] as String,
  tenantPhone: json['tenantPhone'] as String,
  roomNumber: json['roomNumber'] as String,
  propertyName: json['propertyName'] as String,
  landlordName: json['landlordName'] as String,
  landlordPhone: json['landlordPhone'] as String,
  moveInDate: DateTime.parse(json['moveInDate'] as String),
  agreementEndDate: json['agreementEndDate'] == null
      ? null
      : DateTime.parse(json['agreementEndDate'] as String),
  statementDate: DateTime.parse(json['statementDate'] as String),
  entries: (json['entries'] as List<dynamic>)
      .map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalBilled: (json['totalBilled'] as num).toDouble(),
  totalPaid: (json['totalPaid'] as num).toDouble(),
  currentBalance: (json['currentBalance'] as num).toDouble(),
);

Map<String, dynamic> _$$LedgerStatementImplToJson(
  _$LedgerStatementImpl instance,
) => <String, dynamic>{
  'occupancyId': instance.occupancyId,
  'tenantName': instance.tenantName,
  'tenantPhone': instance.tenantPhone,
  'roomNumber': instance.roomNumber,
  'propertyName': instance.propertyName,
  'landlordName': instance.landlordName,
  'landlordPhone': instance.landlordPhone,
  'moveInDate': instance.moveInDate.toIso8601String(),
  'agreementEndDate': instance.agreementEndDate?.toIso8601String(),
  'statementDate': instance.statementDate.toIso8601String(),
  'entries': instance.entries,
  'totalBilled': instance.totalBilled,
  'totalPaid': instance.totalPaid,
  'currentBalance': instance.currentBalance,
};
