// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BillSettingsData _$BillSettingsDataFromJson(Map<String, dynamic> json) {
  return _BillSettingsData.fromJson(json);
}

/// @nodoc
mixin _$BillSettingsData {
  int get id => throw _privateConstructorUsedError;
  String get billNumberPrefix => throw _privateConstructorUsedError;
  int get dueDateOffsetDays => throw _privateConstructorUsedError;
  bool get autoReminders => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BillSettingsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillSettingsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillSettingsDataCopyWith<BillSettingsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillSettingsDataCopyWith<$Res> {
  factory $BillSettingsDataCopyWith(
    BillSettingsData value,
    $Res Function(BillSettingsData) then,
  ) = _$BillSettingsDataCopyWithImpl<$Res, BillSettingsData>;
  @useResult
  $Res call({
    int id,
    String billNumberPrefix,
    int dueDateOffsetDays,
    bool autoReminders,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$BillSettingsDataCopyWithImpl<$Res, $Val extends BillSettingsData>
    implements $BillSettingsDataCopyWith<$Res> {
  _$BillSettingsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillSettingsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billNumberPrefix = null,
    Object? dueDateOffsetDays = null,
    Object? autoReminders = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            billNumberPrefix: null == billNumberPrefix
                ? _value.billNumberPrefix
                : billNumberPrefix // ignore: cast_nullable_to_non_nullable
                      as String,
            dueDateOffsetDays: null == dueDateOffsetDays
                ? _value.dueDateOffsetDays
                : dueDateOffsetDays // ignore: cast_nullable_to_non_nullable
                      as int,
            autoReminders: null == autoReminders
                ? _value.autoReminders
                : autoReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$BillSettingsDataImplCopyWith<$Res>
    implements $BillSettingsDataCopyWith<$Res> {
  factory _$$BillSettingsDataImplCopyWith(
    _$BillSettingsDataImpl value,
    $Res Function(_$BillSettingsDataImpl) then,
  ) = __$$BillSettingsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String billNumberPrefix,
    int dueDateOffsetDays,
    bool autoReminders,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$BillSettingsDataImplCopyWithImpl<$Res>
    extends _$BillSettingsDataCopyWithImpl<$Res, _$BillSettingsDataImpl>
    implements _$$BillSettingsDataImplCopyWith<$Res> {
  __$$BillSettingsDataImplCopyWithImpl(
    _$BillSettingsDataImpl _value,
    $Res Function(_$BillSettingsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillSettingsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billNumberPrefix = null,
    Object? dueDateOffsetDays = null,
    Object? autoReminders = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BillSettingsDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        billNumberPrefix: null == billNumberPrefix
            ? _value.billNumberPrefix
            : billNumberPrefix // ignore: cast_nullable_to_non_nullable
                  as String,
        dueDateOffsetDays: null == dueDateOffsetDays
            ? _value.dueDateOffsetDays
            : dueDateOffsetDays // ignore: cast_nullable_to_non_nullable
                  as int,
        autoReminders: null == autoReminders
            ? _value.autoReminders
            : autoReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$BillSettingsDataImpl implements _BillSettingsData {
  const _$BillSettingsDataImpl({
    required this.id,
    this.billNumberPrefix = 'INV',
    this.dueDateOffsetDays = 10,
    this.autoReminders = true,
    required this.updatedAt,
  });

  factory _$BillSettingsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillSettingsDataImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String billNumberPrefix;
  @override
  @JsonKey()
  final int dueDateOffsetDays;
  @override
  @JsonKey()
  final bool autoReminders;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BillSettingsData(id: $id, billNumberPrefix: $billNumberPrefix, dueDateOffsetDays: $dueDateOffsetDays, autoReminders: $autoReminders, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillSettingsDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billNumberPrefix, billNumberPrefix) ||
                other.billNumberPrefix == billNumberPrefix) &&
            (identical(other.dueDateOffsetDays, dueDateOffsetDays) ||
                other.dueDateOffsetDays == dueDateOffsetDays) &&
            (identical(other.autoReminders, autoReminders) ||
                other.autoReminders == autoReminders) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    billNumberPrefix,
    dueDateOffsetDays,
    autoReminders,
    updatedAt,
  );

  /// Create a copy of BillSettingsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillSettingsDataImplCopyWith<_$BillSettingsDataImpl> get copyWith =>
      __$$BillSettingsDataImplCopyWithImpl<_$BillSettingsDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BillSettingsDataImplToJson(this);
  }
}

abstract class _BillSettingsData implements BillSettingsData {
  const factory _BillSettingsData({
    required final int id,
    final String billNumberPrefix,
    final int dueDateOffsetDays,
    final bool autoReminders,
    required final DateTime updatedAt,
  }) = _$BillSettingsDataImpl;

  factory _BillSettingsData.fromJson(Map<String, dynamic> json) =
      _$BillSettingsDataImpl.fromJson;

  @override
  int get id;
  @override
  String get billNumberPrefix;
  @override
  int get dueDateOffsetDays;
  @override
  bool get autoReminders;
  @override
  DateTime get updatedAt;

  /// Create a copy of BillSettingsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillSettingsDataImplCopyWith<_$BillSettingsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
