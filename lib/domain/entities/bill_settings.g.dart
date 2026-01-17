// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillSettingsDataImpl _$$BillSettingsDataImplFromJson(
  Map<String, dynamic> json,
) => _$BillSettingsDataImpl(
  id: (json['id'] as num).toInt(),
  billNumberPrefix: json['billNumberPrefix'] as String? ?? 'INV',
  dueDateOffsetDays: (json['dueDateOffsetDays'] as num?)?.toInt() ?? 10,
  autoReminders: json['autoReminders'] as bool? ?? true,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$BillSettingsDataImplToJson(
  _$BillSettingsDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'billNumberPrefix': instance.billNumberPrefix,
  'dueDateOffsetDays': instance.dueDateOffsetDays,
  'autoReminders': instance.autoReminders,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
