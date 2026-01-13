/// Family member domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_member.freezed.dart';
part 'family_member.g.dart';

/// Relationship types for family members.
enum FamilyRelationship { spouse, child, parent, sibling, other }

/// Represents a family member of a tenant.
@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required int id,
    required int tenantId,
    required String name,
    required FamilyRelationship relationship,
    String? phone,
    String? aadharNumber,
    required DateTime createdAt,
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);
}
