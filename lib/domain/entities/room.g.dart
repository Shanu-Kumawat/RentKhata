// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomImpl _$$RoomImplFromJson(Map<String, dynamic> json) => _$RoomImpl(
  id: (json['id'] as num).toInt(),
  propertyId: (json['propertyId'] as num).toInt(),
  roomNumber: json['roomNumber'] as String,
  baseRent: (json['baseRent'] as num?)?.toDouble() ?? 0.0,
  hasElectricityMeter: json['hasElectricityMeter'] as bool? ?? false,
  currentElectricityRate:
      (json['currentElectricityRate'] as num?)?.toDouble() ?? 7.0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  propertyName: json['propertyName'] as String?,
  currentTenantName: json['currentTenantName'] as String?,
  currentOccupancyId: (json['currentOccupancyId'] as num?)?.toInt(),
  isOccupied: json['isOccupied'] as bool? ?? false,
);

Map<String, dynamic> _$$RoomImplToJson(_$RoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'roomNumber': instance.roomNumber,
      'baseRent': instance.baseRent,
      'hasElectricityMeter': instance.hasElectricityMeter,
      'currentElectricityRate': instance.currentElectricityRate,
      'createdAt': instance.createdAt.toIso8601String(),
      'propertyName': instance.propertyName,
      'currentTenantName': instance.currentTenantName,
      'currentOccupancyId': instance.currentOccupancyId,
      'isOccupied': instance.isOccupied,
    };
