// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occupancy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OccupancyImpl _$$OccupancyImplFromJson(Map<String, dynamic> json) =>
    _$OccupancyImpl(
      id: (json['id'] as num).toInt(),
      roomId: (json['roomId'] as num).toInt(),
      tenantId: (json['tenantId'] as num).toInt(),
      moveInDate: DateTime.parse(json['moveInDate'] as String),
      moveOutDate: json['moveOutDate'] == null
          ? null
          : DateTime.parse(json['moveOutDate'] as String),
      agreedRent: (json['agreedRent'] as num).toDouble(),
      securityDeposit: (json['securityDeposit'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
      roomNumber: json['roomNumber'] as String?,
      tenantName: json['tenantName'] as String?,
      propertyName: json['propertyName'] as String?,
    );

Map<String, dynamic> _$$OccupancyImplToJson(_$OccupancyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'tenantId': instance.tenantId,
      'moveInDate': instance.moveInDate.toIso8601String(),
      'moveOutDate': instance.moveOutDate?.toIso8601String(),
      'agreedRent': instance.agreedRent,
      'securityDeposit': instance.securityDeposit,
      'isActive': instance.isActive,
      'roomNumber': instance.roomNumber,
      'tenantName': instance.tenantName,
      'propertyName': instance.propertyName,
    };
