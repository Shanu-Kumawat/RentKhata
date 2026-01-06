// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landlord.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Landlord _$LandlordFromJson(Map<String, dynamic> json) {
  return _Landlord.fromJson(json);
}

/// @nodoc
mixin _$Landlord {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get upiId => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Landlord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Landlord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LandlordCopyWith<Landlord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandlordCopyWith<$Res> {
  factory $LandlordCopyWith(Landlord value, $Res Function(Landlord) then) =
      _$LandlordCopyWithImpl<$Res, Landlord>;
  @useResult
  $Res call({
    int id,
    String name,
    String? upiId,
    String? phone,
    String? photoPath,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$LandlordCopyWithImpl<$Res, $Val extends Landlord>
    implements $LandlordCopyWith<$Res> {
  _$LandlordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Landlord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? upiId = freezed,
    Object? phone = freezed,
    Object? photoPath = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            upiId: freezed == upiId
                ? _value.upiId
                : upiId // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LandlordImplCopyWith<$Res>
    implements $LandlordCopyWith<$Res> {
  factory _$$LandlordImplCopyWith(
    _$LandlordImpl value,
    $Res Function(_$LandlordImpl) then,
  ) = __$$LandlordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? upiId,
    String? phone,
    String? photoPath,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$LandlordImplCopyWithImpl<$Res>
    extends _$LandlordCopyWithImpl<$Res, _$LandlordImpl>
    implements _$$LandlordImplCopyWith<$Res> {
  __$$LandlordImplCopyWithImpl(
    _$LandlordImpl _value,
    $Res Function(_$LandlordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Landlord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? upiId = freezed,
    Object? phone = freezed,
    Object? photoPath = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$LandlordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        upiId: freezed == upiId
            ? _value.upiId
            : upiId // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LandlordImpl implements _Landlord {
  const _$LandlordImpl({
    required this.id,
    required this.name,
    this.upiId,
    this.phone,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$LandlordImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandlordImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? upiId;
  @override
  final String? phone;
  @override
  final String? photoPath;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Landlord(id: $id, name: $name, upiId: $upiId, phone: $phone, photoPath: $photoPath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandlordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.upiId, upiId) || other.upiId == upiId) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    upiId,
    phone,
    photoPath,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Landlord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LandlordImplCopyWith<_$LandlordImpl> get copyWith =>
      __$$LandlordImplCopyWithImpl<_$LandlordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandlordImplToJson(this);
  }
}

abstract class _Landlord implements Landlord {
  const factory _Landlord({
    required final int id,
    required final String name,
    final String? upiId,
    final String? phone,
    final String? photoPath,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$LandlordImpl;

  factory _Landlord.fromJson(Map<String, dynamic> json) =
      _$LandlordImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get upiId;
  @override
  String? get phone;
  @override
  String? get photoPath;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Landlord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LandlordImplCopyWith<_$LandlordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
