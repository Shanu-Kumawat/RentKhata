// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occupancy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Occupancy _$OccupancyFromJson(Map<String, dynamic> json) {
  return _Occupancy.fromJson(json);
}

/// @nodoc
mixin _$Occupancy {
  int get id => throw _privateConstructorUsedError;
  int get roomId => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  DateTime get moveInDate => throw _privateConstructorUsedError;
  DateTime? get moveOutDate => throw _privateConstructorUsedError;
  double get agreedRent => throw _privateConstructorUsedError;
  double get securityDeposit => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError; // Deposit tracking
  DepositStatus get depositStatus => throw _privateConstructorUsedError;
  DateTime? get depositReceivedDate => throw _privateConstructorUsedError;
  DateTime? get depositReturnedDate => throw _privateConstructorUsedError;
  double? get depositReturnedAmount =>
      throw _privateConstructorUsedError; // Settlement details
  double get deductionAmount => throw _privateConstructorUsedError;
  String? get deductionReason => throw _privateConstructorUsedError;
  String? get settlementNotes => throw _privateConstructorUsedError;
  bool get isSettled =>
      throw _privateConstructorUsedError; // Denormalized fields
  String? get roomNumber => throw _privateConstructorUsedError;
  String? get tenantName => throw _privateConstructorUsedError;
  String? get propertyName => throw _privateConstructorUsedError;

  /// Serializes this Occupancy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Occupancy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccupancyCopyWith<Occupancy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccupancyCopyWith<$Res> {
  factory $OccupancyCopyWith(Occupancy value, $Res Function(Occupancy) then) =
      _$OccupancyCopyWithImpl<$Res, Occupancy>;
  @useResult
  $Res call({
    int id,
    int roomId,
    int tenantId,
    DateTime moveInDate,
    DateTime? moveOutDate,
    double agreedRent,
    double securityDeposit,
    bool isActive,
    DepositStatus depositStatus,
    DateTime? depositReceivedDate,
    DateTime? depositReturnedDate,
    double? depositReturnedAmount,
    double deductionAmount,
    String? deductionReason,
    String? settlementNotes,
    bool isSettled,
    String? roomNumber,
    String? tenantName,
    String? propertyName,
  });
}

/// @nodoc
class _$OccupancyCopyWithImpl<$Res, $Val extends Occupancy>
    implements $OccupancyCopyWith<$Res> {
  _$OccupancyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Occupancy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? tenantId = null,
    Object? moveInDate = null,
    Object? moveOutDate = freezed,
    Object? agreedRent = null,
    Object? securityDeposit = null,
    Object? isActive = null,
    Object? depositStatus = null,
    Object? depositReceivedDate = freezed,
    Object? depositReturnedDate = freezed,
    Object? depositReturnedAmount = freezed,
    Object? deductionAmount = null,
    Object? deductionReason = freezed,
    Object? settlementNotes = freezed,
    Object? isSettled = null,
    Object? roomNumber = freezed,
    Object? tenantName = freezed,
    Object? propertyName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as int,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as int,
            moveInDate: null == moveInDate
                ? _value.moveInDate
                : moveInDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            moveOutDate: freezed == moveOutDate
                ? _value.moveOutDate
                : moveOutDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            agreedRent: null == agreedRent
                ? _value.agreedRent
                : agreedRent // ignore: cast_nullable_to_non_nullable
                      as double,
            securityDeposit: null == securityDeposit
                ? _value.securityDeposit
                : securityDeposit // ignore: cast_nullable_to_non_nullable
                      as double,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            depositStatus: null == depositStatus
                ? _value.depositStatus
                : depositStatus // ignore: cast_nullable_to_non_nullable
                      as DepositStatus,
            depositReceivedDate: freezed == depositReceivedDate
                ? _value.depositReceivedDate
                : depositReceivedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            depositReturnedDate: freezed == depositReturnedDate
                ? _value.depositReturnedDate
                : depositReturnedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            depositReturnedAmount: freezed == depositReturnedAmount
                ? _value.depositReturnedAmount
                : depositReturnedAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            deductionAmount: null == deductionAmount
                ? _value.deductionAmount
                : deductionAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            deductionReason: freezed == deductionReason
                ? _value.deductionReason
                : deductionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            settlementNotes: freezed == settlementNotes
                ? _value.settlementNotes
                : settlementNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSettled: null == isSettled
                ? _value.isSettled
                : isSettled // ignore: cast_nullable_to_non_nullable
                      as bool,
            roomNumber: freezed == roomNumber
                ? _value.roomNumber
                : roomNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenantName: freezed == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertyName: freezed == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OccupancyImplCopyWith<$Res>
    implements $OccupancyCopyWith<$Res> {
  factory _$$OccupancyImplCopyWith(
    _$OccupancyImpl value,
    $Res Function(_$OccupancyImpl) then,
  ) = __$$OccupancyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int roomId,
    int tenantId,
    DateTime moveInDate,
    DateTime? moveOutDate,
    double agreedRent,
    double securityDeposit,
    bool isActive,
    DepositStatus depositStatus,
    DateTime? depositReceivedDate,
    DateTime? depositReturnedDate,
    double? depositReturnedAmount,
    double deductionAmount,
    String? deductionReason,
    String? settlementNotes,
    bool isSettled,
    String? roomNumber,
    String? tenantName,
    String? propertyName,
  });
}

/// @nodoc
class __$$OccupancyImplCopyWithImpl<$Res>
    extends _$OccupancyCopyWithImpl<$Res, _$OccupancyImpl>
    implements _$$OccupancyImplCopyWith<$Res> {
  __$$OccupancyImplCopyWithImpl(
    _$OccupancyImpl _value,
    $Res Function(_$OccupancyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Occupancy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? tenantId = null,
    Object? moveInDate = null,
    Object? moveOutDate = freezed,
    Object? agreedRent = null,
    Object? securityDeposit = null,
    Object? isActive = null,
    Object? depositStatus = null,
    Object? depositReceivedDate = freezed,
    Object? depositReturnedDate = freezed,
    Object? depositReturnedAmount = freezed,
    Object? deductionAmount = null,
    Object? deductionReason = freezed,
    Object? settlementNotes = freezed,
    Object? isSettled = null,
    Object? roomNumber = freezed,
    Object? tenantName = freezed,
    Object? propertyName = freezed,
  }) {
    return _then(
      _$OccupancyImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as int,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as int,
        moveInDate: null == moveInDate
            ? _value.moveInDate
            : moveInDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        moveOutDate: freezed == moveOutDate
            ? _value.moveOutDate
            : moveOutDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        agreedRent: null == agreedRent
            ? _value.agreedRent
            : agreedRent // ignore: cast_nullable_to_non_nullable
                  as double,
        securityDeposit: null == securityDeposit
            ? _value.securityDeposit
            : securityDeposit // ignore: cast_nullable_to_non_nullable
                  as double,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        depositStatus: null == depositStatus
            ? _value.depositStatus
            : depositStatus // ignore: cast_nullable_to_non_nullable
                  as DepositStatus,
        depositReceivedDate: freezed == depositReceivedDate
            ? _value.depositReceivedDate
            : depositReceivedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        depositReturnedDate: freezed == depositReturnedDate
            ? _value.depositReturnedDate
            : depositReturnedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        depositReturnedAmount: freezed == depositReturnedAmount
            ? _value.depositReturnedAmount
            : depositReturnedAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        deductionAmount: null == deductionAmount
            ? _value.deductionAmount
            : deductionAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        deductionReason: freezed == deductionReason
            ? _value.deductionReason
            : deductionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        settlementNotes: freezed == settlementNotes
            ? _value.settlementNotes
            : settlementNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSettled: null == isSettled
            ? _value.isSettled
            : isSettled // ignore: cast_nullable_to_non_nullable
                  as bool,
        roomNumber: freezed == roomNumber
            ? _value.roomNumber
            : roomNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenantName: freezed == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyName: freezed == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OccupancyImpl implements _Occupancy {
  const _$OccupancyImpl({
    required this.id,
    required this.roomId,
    required this.tenantId,
    required this.moveInDate,
    this.moveOutDate,
    required this.agreedRent,
    this.securityDeposit = 0.0,
    this.isActive = true,
    this.depositStatus = DepositStatus.pending,
    this.depositReceivedDate,
    this.depositReturnedDate,
    this.depositReturnedAmount,
    this.deductionAmount = 0.0,
    this.deductionReason,
    this.settlementNotes,
    this.isSettled = false,
    this.roomNumber,
    this.tenantName,
    this.propertyName,
  });

  factory _$OccupancyImpl.fromJson(Map<String, dynamic> json) =>
      _$$OccupancyImplFromJson(json);

  @override
  final int id;
  @override
  final int roomId;
  @override
  final int tenantId;
  @override
  final DateTime moveInDate;
  @override
  final DateTime? moveOutDate;
  @override
  final double agreedRent;
  @override
  @JsonKey()
  final double securityDeposit;
  @override
  @JsonKey()
  final bool isActive;
  // Deposit tracking
  @override
  @JsonKey()
  final DepositStatus depositStatus;
  @override
  final DateTime? depositReceivedDate;
  @override
  final DateTime? depositReturnedDate;
  @override
  final double? depositReturnedAmount;
  // Settlement details
  @override
  @JsonKey()
  final double deductionAmount;
  @override
  final String? deductionReason;
  @override
  final String? settlementNotes;
  @override
  @JsonKey()
  final bool isSettled;
  // Denormalized fields
  @override
  final String? roomNumber;
  @override
  final String? tenantName;
  @override
  final String? propertyName;

  @override
  String toString() {
    return 'Occupancy(id: $id, roomId: $roomId, tenantId: $tenantId, moveInDate: $moveInDate, moveOutDate: $moveOutDate, agreedRent: $agreedRent, securityDeposit: $securityDeposit, isActive: $isActive, depositStatus: $depositStatus, depositReceivedDate: $depositReceivedDate, depositReturnedDate: $depositReturnedDate, depositReturnedAmount: $depositReturnedAmount, deductionAmount: $deductionAmount, deductionReason: $deductionReason, settlementNotes: $settlementNotes, isSettled: $isSettled, roomNumber: $roomNumber, tenantName: $tenantName, propertyName: $propertyName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccupancyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.moveInDate, moveInDate) ||
                other.moveInDate == moveInDate) &&
            (identical(other.moveOutDate, moveOutDate) ||
                other.moveOutDate == moveOutDate) &&
            (identical(other.agreedRent, agreedRent) ||
                other.agreedRent == agreedRent) &&
            (identical(other.securityDeposit, securityDeposit) ||
                other.securityDeposit == securityDeposit) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.depositStatus, depositStatus) ||
                other.depositStatus == depositStatus) &&
            (identical(other.depositReceivedDate, depositReceivedDate) ||
                other.depositReceivedDate == depositReceivedDate) &&
            (identical(other.depositReturnedDate, depositReturnedDate) ||
                other.depositReturnedDate == depositReturnedDate) &&
            (identical(other.depositReturnedAmount, depositReturnedAmount) ||
                other.depositReturnedAmount == depositReturnedAmount) &&
            (identical(other.deductionAmount, deductionAmount) ||
                other.deductionAmount == deductionAmount) &&
            (identical(other.deductionReason, deductionReason) ||
                other.deductionReason == deductionReason) &&
            (identical(other.settlementNotes, settlementNotes) ||
                other.settlementNotes == settlementNotes) &&
            (identical(other.isSettled, isSettled) ||
                other.isSettled == isSettled) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    roomId,
    tenantId,
    moveInDate,
    moveOutDate,
    agreedRent,
    securityDeposit,
    isActive,
    depositStatus,
    depositReceivedDate,
    depositReturnedDate,
    depositReturnedAmount,
    deductionAmount,
    deductionReason,
    settlementNotes,
    isSettled,
    roomNumber,
    tenantName,
    propertyName,
  ]);

  /// Create a copy of Occupancy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccupancyImplCopyWith<_$OccupancyImpl> get copyWith =>
      __$$OccupancyImplCopyWithImpl<_$OccupancyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OccupancyImplToJson(this);
  }
}

abstract class _Occupancy implements Occupancy {
  const factory _Occupancy({
    required final int id,
    required final int roomId,
    required final int tenantId,
    required final DateTime moveInDate,
    final DateTime? moveOutDate,
    required final double agreedRent,
    final double securityDeposit,
    final bool isActive,
    final DepositStatus depositStatus,
    final DateTime? depositReceivedDate,
    final DateTime? depositReturnedDate,
    final double? depositReturnedAmount,
    final double deductionAmount,
    final String? deductionReason,
    final String? settlementNotes,
    final bool isSettled,
    final String? roomNumber,
    final String? tenantName,
    final String? propertyName,
  }) = _$OccupancyImpl;

  factory _Occupancy.fromJson(Map<String, dynamic> json) =
      _$OccupancyImpl.fromJson;

  @override
  int get id;
  @override
  int get roomId;
  @override
  int get tenantId;
  @override
  DateTime get moveInDate;
  @override
  DateTime? get moveOutDate;
  @override
  double get agreedRent;
  @override
  double get securityDeposit;
  @override
  bool get isActive; // Deposit tracking
  @override
  DepositStatus get depositStatus;
  @override
  DateTime? get depositReceivedDate;
  @override
  DateTime? get depositReturnedDate;
  @override
  double? get depositReturnedAmount; // Settlement details
  @override
  double get deductionAmount;
  @override
  String? get deductionReason;
  @override
  String? get settlementNotes;
  @override
  bool get isSettled; // Denormalized fields
  @override
  String? get roomNumber;
  @override
  String? get tenantName;
  @override
  String? get propertyName;

  /// Create a copy of Occupancy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccupancyImplCopyWith<_$OccupancyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
