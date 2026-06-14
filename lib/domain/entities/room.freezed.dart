// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Room _$RoomFromJson(Map<String, dynamic> json) {
  return _Room.fromJson(json);
}

/// @nodoc
mixin _$Room {
  int get id => throw _privateConstructorUsedError;
  int get propertyId => throw _privateConstructorUsedError;
  String get roomNumber => throw _privateConstructorUsedError;
  double get baseRent => throw _privateConstructorUsedError;
  bool get hasElectricityMeter => throw _privateConstructorUsedError;
  double get currentElectricityRate => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Denormalized fields for convenience
  String? get propertyName => throw _privateConstructorUsedError;
  String? get currentTenantName => throw _privateConstructorUsedError;
  int? get currentOccupancyId => throw _privateConstructorUsedError;
  bool get isOccupied => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;

  /// Serializes this Room to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomCopyWith<Room> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomCopyWith<$Res> {
  factory $RoomCopyWith(Room value, $Res Function(Room) then) =
      _$RoomCopyWithImpl<$Res, Room>;
  @useResult
  $Res call({
    int id,
    int propertyId,
    String roomNumber,
    double baseRent,
    bool hasElectricityMeter,
    double currentElectricityRate,
    DateTime createdAt,
    String? propertyName,
    String? currentTenantName,
    int? currentOccupancyId,
    bool isOccupied,
    bool isArchived,
  });
}

/// @nodoc
class _$RoomCopyWithImpl<$Res, $Val extends Room>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? propertyId = null,
    Object? roomNumber = null,
    Object? baseRent = null,
    Object? hasElectricityMeter = null,
    Object? currentElectricityRate = null,
    Object? createdAt = null,
    Object? propertyName = freezed,
    Object? currentTenantName = freezed,
    Object? currentOccupancyId = freezed,
    Object? isOccupied = null,
    Object? isArchived = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            propertyId: null == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as int,
            roomNumber: null == roomNumber
                ? _value.roomNumber
                : roomNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            baseRent: null == baseRent
                ? _value.baseRent
                : baseRent // ignore: cast_nullable_to_non_nullable
                      as double,
            hasElectricityMeter: null == hasElectricityMeter
                ? _value.hasElectricityMeter
                : hasElectricityMeter // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentElectricityRate: null == currentElectricityRate
                ? _value.currentElectricityRate
                : currentElectricityRate // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentTenantName: freezed == currentTenantName
                ? _value.currentTenantName
                : currentTenantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentOccupancyId: freezed == currentOccupancyId
                ? _value.currentOccupancyId
                : currentOccupancyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            isOccupied: null == isOccupied
                ? _value.isOccupied
                : isOccupied // ignore: cast_nullable_to_non_nullable
                      as bool,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoomImplCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$$RoomImplCopyWith(
    _$RoomImpl value,
    $Res Function(_$RoomImpl) then,
  ) = __$$RoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int propertyId,
    String roomNumber,
    double baseRent,
    bool hasElectricityMeter,
    double currentElectricityRate,
    DateTime createdAt,
    String? propertyName,
    String? currentTenantName,
    int? currentOccupancyId,
    bool isOccupied,
    bool isArchived,
  });
}

/// @nodoc
class __$$RoomImplCopyWithImpl<$Res>
    extends _$RoomCopyWithImpl<$Res, _$RoomImpl>
    implements _$$RoomImplCopyWith<$Res> {
  __$$RoomImplCopyWithImpl(_$RoomImpl _value, $Res Function(_$RoomImpl) _then)
    : super(_value, _then);

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? propertyId = null,
    Object? roomNumber = null,
    Object? baseRent = null,
    Object? hasElectricityMeter = null,
    Object? currentElectricityRate = null,
    Object? createdAt = null,
    Object? propertyName = freezed,
    Object? currentTenantName = freezed,
    Object? currentOccupancyId = freezed,
    Object? isOccupied = null,
    Object? isArchived = null,
  }) {
    return _then(
      _$RoomImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        propertyId: null == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as int,
        roomNumber: null == roomNumber
            ? _value.roomNumber
            : roomNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        baseRent: null == baseRent
            ? _value.baseRent
            : baseRent // ignore: cast_nullable_to_non_nullable
                  as double,
        hasElectricityMeter: null == hasElectricityMeter
            ? _value.hasElectricityMeter
            : hasElectricityMeter // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentElectricityRate: null == currentElectricityRate
            ? _value.currentElectricityRate
            : currentElectricityRate // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentTenantName: freezed == currentTenantName
            ? _value.currentTenantName
            : currentTenantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentOccupancyId: freezed == currentOccupancyId
            ? _value.currentOccupancyId
            : currentOccupancyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        isOccupied: null == isOccupied
            ? _value.isOccupied
            : isOccupied // ignore: cast_nullable_to_non_nullable
                  as bool,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomImpl implements _Room {
  const _$RoomImpl({
    required this.id,
    required this.propertyId,
    required this.roomNumber,
    this.baseRent = 0.0,
    this.hasElectricityMeter = false,
    this.currentElectricityRate = 7.0,
    required this.createdAt,
    this.propertyName,
    this.currentTenantName,
    this.currentOccupancyId,
    this.isOccupied = false,
    this.isArchived = false,
  });

  factory _$RoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomImplFromJson(json);

  @override
  final int id;
  @override
  final int propertyId;
  @override
  final String roomNumber;
  @override
  @JsonKey()
  final double baseRent;
  @override
  @JsonKey()
  final bool hasElectricityMeter;
  @override
  @JsonKey()
  final double currentElectricityRate;
  @override
  final DateTime createdAt;
  // Denormalized fields for convenience
  @override
  final String? propertyName;
  @override
  final String? currentTenantName;
  @override
  final int? currentOccupancyId;
  @override
  @JsonKey()
  final bool isOccupied;
  @override
  @JsonKey()
  final bool isArchived;

  @override
  String toString() {
    return 'Room(id: $id, propertyId: $propertyId, roomNumber: $roomNumber, baseRent: $baseRent, hasElectricityMeter: $hasElectricityMeter, currentElectricityRate: $currentElectricityRate, createdAt: $createdAt, propertyName: $propertyName, currentTenantName: $currentTenantName, currentOccupancyId: $currentOccupancyId, isOccupied: $isOccupied, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.baseRent, baseRent) ||
                other.baseRent == baseRent) &&
            (identical(other.hasElectricityMeter, hasElectricityMeter) ||
                other.hasElectricityMeter == hasElectricityMeter) &&
            (identical(other.currentElectricityRate, currentElectricityRate) ||
                other.currentElectricityRate == currentElectricityRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.currentTenantName, currentTenantName) ||
                other.currentTenantName == currentTenantName) &&
            (identical(other.currentOccupancyId, currentOccupancyId) ||
                other.currentOccupancyId == currentOccupancyId) &&
            (identical(other.isOccupied, isOccupied) ||
                other.isOccupied == isOccupied) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    propertyId,
    roomNumber,
    baseRent,
    hasElectricityMeter,
    currentElectricityRate,
    createdAt,
    propertyName,
    currentTenantName,
    currentOccupancyId,
    isOccupied,
    isArchived,
  );

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomImplCopyWith<_$RoomImpl> get copyWith =>
      __$$RoomImplCopyWithImpl<_$RoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomImplToJson(this);
  }
}

abstract class _Room implements Room {
  const factory _Room({
    required final int id,
    required final int propertyId,
    required final String roomNumber,
    final double baseRent,
    final bool hasElectricityMeter,
    final double currentElectricityRate,
    required final DateTime createdAt,
    final String? propertyName,
    final String? currentTenantName,
    final int? currentOccupancyId,
    final bool isOccupied,
    final bool isArchived,
  }) = _$RoomImpl;

  factory _Room.fromJson(Map<String, dynamic> json) = _$RoomImpl.fromJson;

  @override
  int get id;
  @override
  int get propertyId;
  @override
  String get roomNumber;
  @override
  double get baseRent;
  @override
  bool get hasElectricityMeter;
  @override
  double get currentElectricityRate;
  @override
  DateTime get createdAt; // Denormalized fields for convenience
  @override
  String? get propertyName;
  @override
  String? get currentTenantName;
  @override
  int? get currentOccupancyId;
  @override
  bool get isOccupied;
  @override
  bool get isArchived;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomImplCopyWith<_$RoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
