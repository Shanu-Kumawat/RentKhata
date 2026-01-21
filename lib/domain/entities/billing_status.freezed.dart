// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BillingAttentionItem _$BillingAttentionItemFromJson(Map<String, dynamic> json) {
  return _BillingAttentionItem.fromJson(json);
}

/// @nodoc
mixin _$BillingAttentionItem {
  int get occupancyId => throw _privateConstructorUsedError;
  int get roomId => throw _privateConstructorUsedError;
  String get roomNumber => throw _privateConstructorUsedError;
  String get tenantName => throw _privateConstructorUsedError;
  DateTime get cycleStart => throw _privateConstructorUsedError;
  DateTime get cycleEnd => throw _privateConstructorUsedError;
  BillingCycleStatus get status => throw _privateConstructorUsedError;

  /// Days until cycle ends. Negative values mean cycle is overdue.
  int get daysUntilCycleEnd => throw _privateConstructorUsedError;

  /// The agreed rent amount for pre-filling bill
  double get agreedRent => throw _privateConstructorUsedError;

  /// Property name for context
  String? get propertyName => throw _privateConstructorUsedError;

  /// Serializes this BillingAttentionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillingAttentionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingAttentionItemCopyWith<BillingAttentionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingAttentionItemCopyWith<$Res> {
  factory $BillingAttentionItemCopyWith(
    BillingAttentionItem value,
    $Res Function(BillingAttentionItem) then,
  ) = _$BillingAttentionItemCopyWithImpl<$Res, BillingAttentionItem>;
  @useResult
  $Res call({
    int occupancyId,
    int roomId,
    String roomNumber,
    String tenantName,
    DateTime cycleStart,
    DateTime cycleEnd,
    BillingCycleStatus status,
    int daysUntilCycleEnd,
    double agreedRent,
    String? propertyName,
  });
}

/// @nodoc
class _$BillingAttentionItemCopyWithImpl<
  $Res,
  $Val extends BillingAttentionItem
>
    implements $BillingAttentionItemCopyWith<$Res> {
  _$BillingAttentionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingAttentionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? occupancyId = null,
    Object? roomId = null,
    Object? roomNumber = null,
    Object? tenantName = null,
    Object? cycleStart = null,
    Object? cycleEnd = null,
    Object? status = null,
    Object? daysUntilCycleEnd = null,
    Object? agreedRent = null,
    Object? propertyName = freezed,
  }) {
    return _then(
      _value.copyWith(
            occupancyId: null == occupancyId
                ? _value.occupancyId
                : occupancyId // ignore: cast_nullable_to_non_nullable
                      as int,
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as int,
            roomNumber: null == roomNumber
                ? _value.roomNumber
                : roomNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantName: null == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String,
            cycleStart: null == cycleStart
                ? _value.cycleStart
                : cycleStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            cycleEnd: null == cycleEnd
                ? _value.cycleEnd
                : cycleEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BillingCycleStatus,
            daysUntilCycleEnd: null == daysUntilCycleEnd
                ? _value.daysUntilCycleEnd
                : daysUntilCycleEnd // ignore: cast_nullable_to_non_nullable
                      as int,
            agreedRent: null == agreedRent
                ? _value.agreedRent
                : agreedRent // ignore: cast_nullable_to_non_nullable
                      as double,
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
abstract class _$$BillingAttentionItemImplCopyWith<$Res>
    implements $BillingAttentionItemCopyWith<$Res> {
  factory _$$BillingAttentionItemImplCopyWith(
    _$BillingAttentionItemImpl value,
    $Res Function(_$BillingAttentionItemImpl) then,
  ) = __$$BillingAttentionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int occupancyId,
    int roomId,
    String roomNumber,
    String tenantName,
    DateTime cycleStart,
    DateTime cycleEnd,
    BillingCycleStatus status,
    int daysUntilCycleEnd,
    double agreedRent,
    String? propertyName,
  });
}

/// @nodoc
class __$$BillingAttentionItemImplCopyWithImpl<$Res>
    extends _$BillingAttentionItemCopyWithImpl<$Res, _$BillingAttentionItemImpl>
    implements _$$BillingAttentionItemImplCopyWith<$Res> {
  __$$BillingAttentionItemImplCopyWithImpl(
    _$BillingAttentionItemImpl _value,
    $Res Function(_$BillingAttentionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillingAttentionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? occupancyId = null,
    Object? roomId = null,
    Object? roomNumber = null,
    Object? tenantName = null,
    Object? cycleStart = null,
    Object? cycleEnd = null,
    Object? status = null,
    Object? daysUntilCycleEnd = null,
    Object? agreedRent = null,
    Object? propertyName = freezed,
  }) {
    return _then(
      _$BillingAttentionItemImpl(
        occupancyId: null == occupancyId
            ? _value.occupancyId
            : occupancyId // ignore: cast_nullable_to_non_nullable
                  as int,
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as int,
        roomNumber: null == roomNumber
            ? _value.roomNumber
            : roomNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantName: null == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String,
        cycleStart: null == cycleStart
            ? _value.cycleStart
            : cycleStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        cycleEnd: null == cycleEnd
            ? _value.cycleEnd
            : cycleEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BillingCycleStatus,
        daysUntilCycleEnd: null == daysUntilCycleEnd
            ? _value.daysUntilCycleEnd
            : daysUntilCycleEnd // ignore: cast_nullable_to_non_nullable
                  as int,
        agreedRent: null == agreedRent
            ? _value.agreedRent
            : agreedRent // ignore: cast_nullable_to_non_nullable
                  as double,
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
class _$BillingAttentionItemImpl extends _BillingAttentionItem {
  const _$BillingAttentionItemImpl({
    required this.occupancyId,
    required this.roomId,
    required this.roomNumber,
    required this.tenantName,
    required this.cycleStart,
    required this.cycleEnd,
    required this.status,
    required this.daysUntilCycleEnd,
    required this.agreedRent,
    this.propertyName,
  }) : super._();

  factory _$BillingAttentionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingAttentionItemImplFromJson(json);

  @override
  final int occupancyId;
  @override
  final int roomId;
  @override
  final String roomNumber;
  @override
  final String tenantName;
  @override
  final DateTime cycleStart;
  @override
  final DateTime cycleEnd;
  @override
  final BillingCycleStatus status;

  /// Days until cycle ends. Negative values mean cycle is overdue.
  @override
  final int daysUntilCycleEnd;

  /// The agreed rent amount for pre-filling bill
  @override
  final double agreedRent;

  /// Property name for context
  @override
  final String? propertyName;

  @override
  String toString() {
    return 'BillingAttentionItem(occupancyId: $occupancyId, roomId: $roomId, roomNumber: $roomNumber, tenantName: $tenantName, cycleStart: $cycleStart, cycleEnd: $cycleEnd, status: $status, daysUntilCycleEnd: $daysUntilCycleEnd, agreedRent: $agreedRent, propertyName: $propertyName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingAttentionItemImpl &&
            (identical(other.occupancyId, occupancyId) ||
                other.occupancyId == occupancyId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.cycleStart, cycleStart) ||
                other.cycleStart == cycleStart) &&
            (identical(other.cycleEnd, cycleEnd) ||
                other.cycleEnd == cycleEnd) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.daysUntilCycleEnd, daysUntilCycleEnd) ||
                other.daysUntilCycleEnd == daysUntilCycleEnd) &&
            (identical(other.agreedRent, agreedRent) ||
                other.agreedRent == agreedRent) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    occupancyId,
    roomId,
    roomNumber,
    tenantName,
    cycleStart,
    cycleEnd,
    status,
    daysUntilCycleEnd,
    agreedRent,
    propertyName,
  );

  /// Create a copy of BillingAttentionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingAttentionItemImplCopyWith<_$BillingAttentionItemImpl>
  get copyWith =>
      __$$BillingAttentionItemImplCopyWithImpl<_$BillingAttentionItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingAttentionItemImplToJson(this);
  }
}

abstract class _BillingAttentionItem extends BillingAttentionItem {
  const factory _BillingAttentionItem({
    required final int occupancyId,
    required final int roomId,
    required final String roomNumber,
    required final String tenantName,
    required final DateTime cycleStart,
    required final DateTime cycleEnd,
    required final BillingCycleStatus status,
    required final int daysUntilCycleEnd,
    required final double agreedRent,
    final String? propertyName,
  }) = _$BillingAttentionItemImpl;
  const _BillingAttentionItem._() : super._();

  factory _BillingAttentionItem.fromJson(Map<String, dynamic> json) =
      _$BillingAttentionItemImpl.fromJson;

  @override
  int get occupancyId;
  @override
  int get roomId;
  @override
  String get roomNumber;
  @override
  String get tenantName;
  @override
  DateTime get cycleStart;
  @override
  DateTime get cycleEnd;
  @override
  BillingCycleStatus get status;

  /// Days until cycle ends. Negative values mean cycle is overdue.
  @override
  int get daysUntilCycleEnd;

  /// The agreed rent amount for pre-filling bill
  @override
  double get agreedRent;

  /// Property name for context
  @override
  String? get propertyName;

  /// Create a copy of BillingAttentionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingAttentionItemImplCopyWith<_$BillingAttentionItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}
