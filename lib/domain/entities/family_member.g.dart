// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FamilyMemberImpl _$$FamilyMemberImplFromJson(Map<String, dynamic> json) =>
    _$FamilyMemberImpl(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenantId'] as num).toInt(),
      name: json['name'] as String,
      relationship: $enumDecode(
        _$FamilyRelationshipEnumMap,
        json['relationship'],
      ),
      phone: json['phone'] as String?,
      aadharNumber: json['aadharNumber'] as String?,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FamilyMemberImplToJson(_$FamilyMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'name': instance.name,
      'relationship': _$FamilyRelationshipEnumMap[instance.relationship]!,
      'phone': instance.phone,
      'aadharNumber': instance.aadharNumber,
      'age': instance.age,
      'gender': instance.gender,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FamilyRelationshipEnumMap = {
  FamilyRelationship.spouse: 'spouse',
  FamilyRelationship.child: 'child',
  FamilyRelationship.parent: 'parent',
  FamilyRelationship.sibling: 'sibling',
  FamilyRelationship.other: 'other',
};
