// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      propertyId: (json['propertyId'] as num?)?.toInt(),
      roomId: (json['roomId'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'propertyId': instance.propertyId,
      'roomId': instance.roomId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.maintenance: 'maintenance',
  ExpenseCategory.repairs: 'repairs',
  ExpenseCategory.taxes: 'taxes',
  ExpenseCategory.utilities: 'utilities',
  ExpenseCategory.cleaning: 'cleaning',
  ExpenseCategory.salary: 'salary',
  ExpenseCategory.other: 'other',
};
