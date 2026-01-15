// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) {
  return _FamilyMember.fromJson(json);
}

/// @nodoc
mixin _$FamilyMember {
  int get id => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FamilyRelationship get relationship => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get aadharNumber => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FamilyMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyMemberCopyWith<FamilyMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyMemberCopyWith<$Res> {
  factory $FamilyMemberCopyWith(
    FamilyMember value,
    $Res Function(FamilyMember) then,
  ) = _$FamilyMemberCopyWithImpl<$Res, FamilyMember>;
  @useResult
  $Res call({
    int id,
    int tenantId,
    String name,
    FamilyRelationship relationship,
    String? phone,
    String? aadharNumber,
    int? age,
    String? gender,
    DateTime createdAt,
  });
}

/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res, $Val extends FamilyMember>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? name = null,
    Object? relationship = null,
    Object? phone = freezed,
    Object? aadharNumber = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            relationship: null == relationship
                ? _value.relationship
                : relationship // ignore: cast_nullable_to_non_nullable
                      as FamilyRelationship,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            aadharNumber: freezed == aadharNumber
                ? _value.aadharNumber
                : aadharNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FamilyMemberImplCopyWith<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  factory _$$FamilyMemberImplCopyWith(
    _$FamilyMemberImpl value,
    $Res Function(_$FamilyMemberImpl) then,
  ) = __$$FamilyMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int tenantId,
    String name,
    FamilyRelationship relationship,
    String? phone,
    String? aadharNumber,
    int? age,
    String? gender,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$FamilyMemberImplCopyWithImpl<$Res>
    extends _$FamilyMemberCopyWithImpl<$Res, _$FamilyMemberImpl>
    implements _$$FamilyMemberImplCopyWith<$Res> {
  __$$FamilyMemberImplCopyWithImpl(
    _$FamilyMemberImpl _value,
    $Res Function(_$FamilyMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? name = null,
    Object? relationship = null,
    Object? phone = freezed,
    Object? aadharNumber = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$FamilyMemberImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        relationship: null == relationship
            ? _value.relationship
            : relationship // ignore: cast_nullable_to_non_nullable
                  as FamilyRelationship,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        aadharNumber: freezed == aadharNumber
            ? _value.aadharNumber
            : aadharNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyMemberImpl implements _FamilyMember {
  const _$FamilyMemberImpl({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.relationship,
    this.phone,
    this.aadharNumber,
    this.age,
    this.gender,
    required this.createdAt,
  });

  factory _$FamilyMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyMemberImplFromJson(json);

  @override
  final int id;
  @override
  final int tenantId;
  @override
  final String name;
  @override
  final FamilyRelationship relationship;
  @override
  final String? phone;
  @override
  final String? aadharNumber;
  @override
  final int? age;
  @override
  final String? gender;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FamilyMember(id: $id, tenantId: $tenantId, name: $name, relationship: $relationship, phone: $phone, aadharNumber: $aadharNumber, age: $age, gender: $gender, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.aadharNumber, aadharNumber) ||
                other.aadharNumber == aadharNumber) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tenantId,
    name,
    relationship,
    phone,
    aadharNumber,
    age,
    gender,
    createdAt,
  );

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      __$$FamilyMemberImplCopyWithImpl<_$FamilyMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyMemberImplToJson(this);
  }
}

abstract class _FamilyMember implements FamilyMember {
  const factory _FamilyMember({
    required final int id,
    required final int tenantId,
    required final String name,
    required final FamilyRelationship relationship,
    final String? phone,
    final String? aadharNumber,
    final int? age,
    final String? gender,
    required final DateTime createdAt,
  }) = _$FamilyMemberImpl;

  factory _FamilyMember.fromJson(Map<String, dynamic> json) =
      _$FamilyMemberImpl.fromJson;

  @override
  int get id;
  @override
  int get tenantId;
  @override
  String get name;
  @override
  FamilyRelationship get relationship;
  @override
  String? get phone;
  @override
  String? get aadharNumber;
  @override
  int? get age;
  @override
  String? get gender;
  @override
  DateTime get createdAt;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
