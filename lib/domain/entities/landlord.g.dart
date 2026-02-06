// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landlord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LandlordImpl _$$LandlordImplFromJson(Map<String, dynamic> json) =>
    _$LandlordImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      upiId: json['upiId'] as String?,
      phone: json['phone'] as String?,
      photoPath: json['photoPath'] as String?,
      signaturePath: json['signaturePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$LandlordImplToJson(_$LandlordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'upiId': instance.upiId,
      'phone': instance.phone,
      'photoPath': instance.photoPath,
      'signaturePath': instance.signaturePath,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
