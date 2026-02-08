// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentImpl _$$DocumentImplFromJson(Map<String, dynamic> json) =>
    _$DocumentImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenantId'] as num).toInt(),
      title: json['title'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$DocumentImplToJson(_$DocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'title': instance.title,
      'filePath': instance.filePath,
      'fileType': instance.fileType,
      'createdAt': instance.createdAt.toIso8601String(),
    };
