// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) {
  return _AuditLog.fromJson(json);
}

/// @nodoc
mixin _$AuditLog {
  int get id => throw _privateConstructorUsedError;
  AuditEntityType get entityType => throw _privateConstructorUsedError;
  int get entityId => throw _privateConstructorUsedError;
  AuditAction get action => throw _privateConstructorUsedError;
  String? get fieldName => throw _privateConstructorUsedError;
  String? get oldValue => throw _privateConstructorUsedError;
  String? get newValue => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AuditLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuditLogCopyWith<AuditLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogCopyWith<$Res> {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) then) =
      _$AuditLogCopyWithImpl<$Res, AuditLog>;
  @useResult
  $Res call({
    int id,
    AuditEntityType entityType,
    int entityId,
    AuditAction action,
    String? fieldName,
    String? oldValue,
    String? newValue,
    String? notes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AuditLogCopyWithImpl<$Res, $Val extends AuditLog>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? fieldName = freezed,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as AuditEntityType,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as int,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as AuditAction,
            fieldName: freezed == fieldName
                ? _value.fieldName
                : fieldName // ignore: cast_nullable_to_non_nullable
                      as String?,
            oldValue: freezed == oldValue
                ? _value.oldValue
                : oldValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            newValue: freezed == newValue
                ? _value.newValue
                : newValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AuditLogImplCopyWith<$Res>
    implements $AuditLogCopyWith<$Res> {
  factory _$$AuditLogImplCopyWith(
    _$AuditLogImpl value,
    $Res Function(_$AuditLogImpl) then,
  ) = __$$AuditLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    AuditEntityType entityType,
    int entityId,
    AuditAction action,
    String? fieldName,
    String? oldValue,
    String? newValue,
    String? notes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AuditLogImplCopyWithImpl<$Res>
    extends _$AuditLogCopyWithImpl<$Res, _$AuditLogImpl>
    implements _$$AuditLogImplCopyWith<$Res> {
  __$$AuditLogImplCopyWithImpl(
    _$AuditLogImpl _value,
    $Res Function(_$AuditLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? fieldName = freezed,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$AuditLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as AuditEntityType,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as int,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as AuditAction,
        fieldName: freezed == fieldName
            ? _value.fieldName
            : fieldName // ignore: cast_nullable_to_non_nullable
                  as String?,
        oldValue: freezed == oldValue
            ? _value.oldValue
            : oldValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        newValue: freezed == newValue
            ? _value.newValue
            : newValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
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
class _$AuditLogImpl implements _AuditLog {
  const _$AuditLogImpl({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.fieldName,
    this.oldValue,
    this.newValue,
    this.notes,
    required this.createdAt,
  });

  factory _$AuditLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogImplFromJson(json);

  @override
  final int id;
  @override
  final AuditEntityType entityType;
  @override
  final int entityId;
  @override
  final AuditAction action;
  @override
  final String? fieldName;
  @override
  final String? oldValue;
  @override
  final String? newValue;
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AuditLog(id: $id, entityType: $entityType, entityId: $entityId, action: $action, fieldName: $fieldName, oldValue: $oldValue, newValue: $newValue, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.fieldName, fieldName) ||
                other.fieldName == fieldName) &&
            (identical(other.oldValue, oldValue) ||
                other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entityType,
    entityId,
    action,
    fieldName,
    oldValue,
    newValue,
    notes,
    createdAt,
  );

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      __$$AuditLogImplCopyWithImpl<_$AuditLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogImplToJson(this);
  }
}

abstract class _AuditLog implements AuditLog {
  const factory _AuditLog({
    required final int id,
    required final AuditEntityType entityType,
    required final int entityId,
    required final AuditAction action,
    final String? fieldName,
    final String? oldValue,
    final String? newValue,
    final String? notes,
    required final DateTime createdAt,
  }) = _$AuditLogImpl;

  factory _AuditLog.fromJson(Map<String, dynamic> json) =
      _$AuditLogImpl.fromJson;

  @override
  int get id;
  @override
  AuditEntityType get entityType;
  @override
  int get entityId;
  @override
  AuditAction get action;
  @override
  String? get fieldName;
  @override
  String? get oldValue;
  @override
  String? get newValue;
  @override
  String? get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
