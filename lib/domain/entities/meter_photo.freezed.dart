// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meter_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MeterPhoto _$MeterPhotoFromJson(Map<String, dynamic> json) {
  return _MeterPhoto.fromJson(json);
}

/// @nodoc
mixin _$MeterPhoto {
  int get id => throw _privateConstructorUsedError;
  int get billId => throw _privateConstructorUsedError;
  String get photoPath => throw _privateConstructorUsedError;
  int get photoOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MeterPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeterPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeterPhotoCopyWith<MeterPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeterPhotoCopyWith<$Res> {
  factory $MeterPhotoCopyWith(
    MeterPhoto value,
    $Res Function(MeterPhoto) then,
  ) = _$MeterPhotoCopyWithImpl<$Res, MeterPhoto>;
  @useResult
  $Res call({
    int id,
    int billId,
    String photoPath,
    int photoOrder,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MeterPhotoCopyWithImpl<$Res, $Val extends MeterPhoto>
    implements $MeterPhotoCopyWith<$Res> {
  _$MeterPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeterPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billId = null,
    Object? photoPath = null,
    Object? photoOrder = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            billId: null == billId
                ? _value.billId
                : billId // ignore: cast_nullable_to_non_nullable
                      as int,
            photoPath: null == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String,
            photoOrder: null == photoOrder
                ? _value.photoOrder
                : photoOrder // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$MeterPhotoImplCopyWith<$Res>
    implements $MeterPhotoCopyWith<$Res> {
  factory _$$MeterPhotoImplCopyWith(
    _$MeterPhotoImpl value,
    $Res Function(_$MeterPhotoImpl) then,
  ) = __$$MeterPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int billId,
    String photoPath,
    int photoOrder,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MeterPhotoImplCopyWithImpl<$Res>
    extends _$MeterPhotoCopyWithImpl<$Res, _$MeterPhotoImpl>
    implements _$$MeterPhotoImplCopyWith<$Res> {
  __$$MeterPhotoImplCopyWithImpl(
    _$MeterPhotoImpl _value,
    $Res Function(_$MeterPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeterPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billId = null,
    Object? photoPath = null,
    Object? photoOrder = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MeterPhotoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        billId: null == billId
            ? _value.billId
            : billId // ignore: cast_nullable_to_non_nullable
                  as int,
        photoPath: null == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String,
        photoOrder: null == photoOrder
            ? _value.photoOrder
            : photoOrder // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$MeterPhotoImpl implements _MeterPhoto {
  const _$MeterPhotoImpl({
    required this.id,
    required this.billId,
    required this.photoPath,
    this.photoOrder = 1,
    required this.createdAt,
  });

  factory _$MeterPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeterPhotoImplFromJson(json);

  @override
  final int id;
  @override
  final int billId;
  @override
  final String photoPath;
  @override
  @JsonKey()
  final int photoOrder;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MeterPhoto(id: $id, billId: $billId, photoPath: $photoPath, photoOrder: $photoOrder, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeterPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billId, billId) || other.billId == billId) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.photoOrder, photoOrder) ||
                other.photoOrder == photoOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, billId, photoPath, photoOrder, createdAt);

  /// Create a copy of MeterPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeterPhotoImplCopyWith<_$MeterPhotoImpl> get copyWith =>
      __$$MeterPhotoImplCopyWithImpl<_$MeterPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeterPhotoImplToJson(this);
  }
}

abstract class _MeterPhoto implements MeterPhoto {
  const factory _MeterPhoto({
    required final int id,
    required final int billId,
    required final String photoPath,
    final int photoOrder,
    required final DateTime createdAt,
  }) = _$MeterPhotoImpl;

  factory _MeterPhoto.fromJson(Map<String, dynamic> json) =
      _$MeterPhotoImpl.fromJson;

  @override
  int get id;
  @override
  int get billId;
  @override
  String get photoPath;
  @override
  int get photoOrder;
  @override
  DateTime get createdAt;

  /// Create a copy of MeterPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeterPhotoImplCopyWith<_$MeterPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
