// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageTemplateImpl _$$MessageTemplateImplFromJson(
  Map<String, dynamic> json,
) => _$MessageTemplateImpl(
  id: (json['id'] as num).toInt(),
  templateType: $enumDecode(_$TemplateTypeEnumMap, json['templateType']),
  name: json['name'] as String,
  body: json['body'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$MessageTemplateImplToJson(
  _$MessageTemplateImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'templateType': _$TemplateTypeEnumMap[instance.templateType]!,
  'name': instance.name,
  'body': instance.body,
  'isDefault': instance.isDefault,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$TemplateTypeEnumMap = {
  TemplateType.invoice: 'invoice',
  TemplateType.receipt: 'receipt',
};
