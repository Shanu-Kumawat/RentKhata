// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeterPhotoImpl _$$MeterPhotoImplFromJson(Map<String, dynamic> json) =>
    _$MeterPhotoImpl(
      id: (json['id'] as num).toInt(),
      billId: (json['billId'] as num).toInt(),
      photoPath: json['photoPath'] as String,
      photoOrder: (json['photoOrder'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MeterPhotoImplToJson(_$MeterPhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billId': instance.billId,
      'photoPath': instance.photoPath,
      'photoOrder': instance.photoOrder,
      'createdAt': instance.createdAt.toIso8601String(),
    };
