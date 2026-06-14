// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyImpl _$$PropertyImplFromJson(Map<String, dynamic> json) =>
    _$PropertyImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String?,
      photoPath: json['photoPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      roomCount: (json['roomCount'] as num?)?.toInt() ?? 0,
      occupiedRoomCount: (json['occupiedRoomCount'] as num?)?.toInt() ?? 0,
      isArchived: json['isArchived'] as bool? ?? false,
    );

Map<String, dynamic> _$$PropertyImplToJson(_$PropertyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'photoPath': instance.photoPath,
      'createdAt': instance.createdAt.toIso8601String(),
      'roomCount': instance.roomCount,
      'occupiedRoomCount': instance.occupiedRoomCount,
      'isArchived': instance.isArchived,
    };
