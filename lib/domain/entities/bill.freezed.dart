// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Bill _$BillFromJson(Map<String, dynamic> json) {
  return _Bill.fromJson(json);
}

/// @nodoc
mixin _$Bill {
  int get id => throw _privateConstructorUsedError;
  int get occupancyId => throw _privateConstructorUsedError;
  BillType get billType => throw _privateConstructorUsedError;
  int get billingMonth => throw _privateConstructorUsedError;
  int get billingYear => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double? get electricityPrevReading => throw _privateConstructorUsedError;
  double? get electricityCurrReading => throw _privateConstructorUsedError;
  double? get electricityRateAtBilling => throw _privateConstructorUsedError;
  double? get electricityCharges => throw _privateConstructorUsedError;
  String? get meterPhotoPath => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime? get periodStartDate => throw _privateConstructorUsedError;
  DateTime? get periodEndDate =>
      throw _privateConstructorUsedError; // Calculated fields
  double get paidAmount => throw _privateConstructorUsedError;
  double get pendingAmount =>
      throw _privateConstructorUsedError; // Denormalized fields
  String? get roomNumber => throw _privateConstructorUsedError;
  String? get tenantName => throw _privateConstructorUsedError;
  String? get propertyName => throw _privateConstructorUsedError;

  /// Serializes this Bill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillCopyWith<Bill> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillCopyWith<$Res> {
  factory $BillCopyWith(Bill value, $Res Function(Bill) then) =
      _$BillCopyWithImpl<$Res, Bill>;
  @useResult
  $Res call({
    int id,
    int occupancyId,
    BillType billType,
    int billingMonth,
    int billingYear,
    double amount,
    double? electricityPrevReading,
    double? electricityCurrReading,
    double? electricityRateAtBilling,
    double? electricityCharges,
    String? meterPhotoPath,
    String? notes,
    DateTime createdAt,
    DateTime? dueDate,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    double paidAmount,
    double pendingAmount,
    String? roomNumber,
    String? tenantName,
    String? propertyName,
  });
}

/// @nodoc
class _$BillCopyWithImpl<$Res, $Val extends Bill>
    implements $BillCopyWith<$Res> {
  _$BillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? occupancyId = null,
    Object? billType = null,
    Object? billingMonth = null,
    Object? billingYear = null,
    Object? amount = null,
    Object? electricityPrevReading = freezed,
    Object? electricityCurrReading = freezed,
    Object? electricityRateAtBilling = freezed,
    Object? electricityCharges = freezed,
    Object? meterPhotoPath = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? dueDate = freezed,
    Object? periodStartDate = freezed,
    Object? periodEndDate = freezed,
    Object? paidAmount = null,
    Object? pendingAmount = null,
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
            occupancyId: null == occupancyId
                ? _value.occupancyId
                : occupancyId // ignore: cast_nullable_to_non_nullable
                      as int,
            billType: null == billType
                ? _value.billType
                : billType // ignore: cast_nullable_to_non_nullable
                      as BillType,
            billingMonth: null == billingMonth
                ? _value.billingMonth
                : billingMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            billingYear: null == billingYear
                ? _value.billingYear
                : billingYear // ignore: cast_nullable_to_non_nullable
                      as int,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            electricityPrevReading: freezed == electricityPrevReading
                ? _value.electricityPrevReading
                : electricityPrevReading // ignore: cast_nullable_to_non_nullable
                      as double?,
            electricityCurrReading: freezed == electricityCurrReading
                ? _value.electricityCurrReading
                : electricityCurrReading // ignore: cast_nullable_to_non_nullable
                      as double?,
            electricityRateAtBilling: freezed == electricityRateAtBilling
                ? _value.electricityRateAtBilling
                : electricityRateAtBilling // ignore: cast_nullable_to_non_nullable
                      as double?,
            electricityCharges: freezed == electricityCharges
                ? _value.electricityCharges
                : electricityCharges // ignore: cast_nullable_to_non_nullable
                      as double?,
            meterPhotoPath: freezed == meterPhotoPath
                ? _value.meterPhotoPath
                : meterPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            periodStartDate: freezed == periodStartDate
                ? _value.periodStartDate
                : periodStartDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            periodEndDate: freezed == periodEndDate
                ? _value.periodEndDate
                : periodEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            pendingAmount: null == pendingAmount
                ? _value.pendingAmount
                : pendingAmount // ignore: cast_nullable_to_non_nullable
                      as double,
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
abstract class _$$BillImplCopyWith<$Res> implements $BillCopyWith<$Res> {
  factory _$$BillImplCopyWith(
    _$BillImpl value,
    $Res Function(_$BillImpl) then,
  ) = __$$BillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int occupancyId,
    BillType billType,
    int billingMonth,
    int billingYear,
    double amount,
    double? electricityPrevReading,
    double? electricityCurrReading,
    double? electricityRateAtBilling,
    double? electricityCharges,
    String? meterPhotoPath,
    String? notes,
    DateTime createdAt,
    DateTime? dueDate,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    double paidAmount,
    double pendingAmount,
    String? roomNumber,
    String? tenantName,
    String? propertyName,
  });
}

/// @nodoc
class __$$BillImplCopyWithImpl<$Res>
    extends _$BillCopyWithImpl<$Res, _$BillImpl>
    implements _$$BillImplCopyWith<$Res> {
  __$$BillImplCopyWithImpl(_$BillImpl _value, $Res Function(_$BillImpl) _then)
    : super(_value, _then);

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? occupancyId = null,
    Object? billType = null,
    Object? billingMonth = null,
    Object? billingYear = null,
    Object? amount = null,
    Object? electricityPrevReading = freezed,
    Object? electricityCurrReading = freezed,
    Object? electricityRateAtBilling = freezed,
    Object? electricityCharges = freezed,
    Object? meterPhotoPath = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? dueDate = freezed,
    Object? periodStartDate = freezed,
    Object? periodEndDate = freezed,
    Object? paidAmount = null,
    Object? pendingAmount = null,
    Object? roomNumber = freezed,
    Object? tenantName = freezed,
    Object? propertyName = freezed,
  }) {
    return _then(
      _$BillImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        occupancyId: null == occupancyId
            ? _value.occupancyId
            : occupancyId // ignore: cast_nullable_to_non_nullable
                  as int,
        billType: null == billType
            ? _value.billType
            : billType // ignore: cast_nullable_to_non_nullable
                  as BillType,
        billingMonth: null == billingMonth
            ? _value.billingMonth
            : billingMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        billingYear: null == billingYear
            ? _value.billingYear
            : billingYear // ignore: cast_nullable_to_non_nullable
                  as int,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        electricityPrevReading: freezed == electricityPrevReading
            ? _value.electricityPrevReading
            : electricityPrevReading // ignore: cast_nullable_to_non_nullable
                  as double?,
        electricityCurrReading: freezed == electricityCurrReading
            ? _value.electricityCurrReading
            : electricityCurrReading // ignore: cast_nullable_to_non_nullable
                  as double?,
        electricityRateAtBilling: freezed == electricityRateAtBilling
            ? _value.electricityRateAtBilling
            : electricityRateAtBilling // ignore: cast_nullable_to_non_nullable
                  as double?,
        electricityCharges: freezed == electricityCharges
            ? _value.electricityCharges
            : electricityCharges // ignore: cast_nullable_to_non_nullable
                  as double?,
        meterPhotoPath: freezed == meterPhotoPath
            ? _value.meterPhotoPath
            : meterPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        periodStartDate: freezed == periodStartDate
            ? _value.periodStartDate
            : periodStartDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        periodEndDate: freezed == periodEndDate
            ? _value.periodEndDate
            : periodEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        pendingAmount: null == pendingAmount
            ? _value.pendingAmount
            : pendingAmount // ignore: cast_nullable_to_non_nullable
                  as double,
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
class _$BillImpl extends _Bill {
  const _$BillImpl({
    required this.id,
    required this.occupancyId,
    required this.billType,
    required this.billingMonth,
    required this.billingYear,
    required this.amount,
    this.electricityPrevReading,
    this.electricityCurrReading,
    this.electricityRateAtBilling,
    this.electricityCharges,
    this.meterPhotoPath,
    this.notes,
    required this.createdAt,
    this.dueDate,
    this.periodStartDate,
    this.periodEndDate,
    this.paidAmount = 0.0,
    this.pendingAmount = 0.0,
    this.roomNumber,
    this.tenantName,
    this.propertyName,
  }) : super._();

  factory _$BillImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillImplFromJson(json);

  @override
  final int id;
  @override
  final int occupancyId;
  @override
  final BillType billType;
  @override
  final int billingMonth;
  @override
  final int billingYear;
  @override
  final double amount;
  @override
  final double? electricityPrevReading;
  @override
  final double? electricityCurrReading;
  @override
  final double? electricityRateAtBilling;
  @override
  final double? electricityCharges;
  @override
  final String? meterPhotoPath;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? dueDate;
  @override
  final DateTime? periodStartDate;
  @override
  final DateTime? periodEndDate;
  // Calculated fields
  @override
  @JsonKey()
  final double paidAmount;
  @override
  @JsonKey()
  final double pendingAmount;
  // Denormalized fields
  @override
  final String? roomNumber;
  @override
  final String? tenantName;
  @override
  final String? propertyName;

  @override
  String toString() {
    return 'Bill(id: $id, occupancyId: $occupancyId, billType: $billType, billingMonth: $billingMonth, billingYear: $billingYear, amount: $amount, electricityPrevReading: $electricityPrevReading, electricityCurrReading: $electricityCurrReading, electricityRateAtBilling: $electricityRateAtBilling, electricityCharges: $electricityCharges, meterPhotoPath: $meterPhotoPath, notes: $notes, createdAt: $createdAt, dueDate: $dueDate, periodStartDate: $periodStartDate, periodEndDate: $periodEndDate, paidAmount: $paidAmount, pendingAmount: $pendingAmount, roomNumber: $roomNumber, tenantName: $tenantName, propertyName: $propertyName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.occupancyId, occupancyId) ||
                other.occupancyId == occupancyId) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.billingMonth, billingMonth) ||
                other.billingMonth == billingMonth) &&
            (identical(other.billingYear, billingYear) ||
                other.billingYear == billingYear) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.electricityPrevReading, electricityPrevReading) ||
                other.electricityPrevReading == electricityPrevReading) &&
            (identical(other.electricityCurrReading, electricityCurrReading) ||
                other.electricityCurrReading == electricityCurrReading) &&
            (identical(
                  other.electricityRateAtBilling,
                  electricityRateAtBilling,
                ) ||
                other.electricityRateAtBilling == electricityRateAtBilling) &&
            (identical(other.electricityCharges, electricityCharges) ||
                other.electricityCharges == electricityCharges) &&
            (identical(other.meterPhotoPath, meterPhotoPath) ||
                other.meterPhotoPath == meterPhotoPath) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.periodStartDate, periodStartDate) ||
                other.periodStartDate == periodStartDate) &&
            (identical(other.periodEndDate, periodEndDate) ||
                other.periodEndDate == periodEndDate) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.pendingAmount, pendingAmount) ||
                other.pendingAmount == pendingAmount) &&
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
    occupancyId,
    billType,
    billingMonth,
    billingYear,
    amount,
    electricityPrevReading,
    electricityCurrReading,
    electricityRateAtBilling,
    electricityCharges,
    meterPhotoPath,
    notes,
    createdAt,
    dueDate,
    periodStartDate,
    periodEndDate,
    paidAmount,
    pendingAmount,
    roomNumber,
    tenantName,
    propertyName,
  ]);

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillImplCopyWith<_$BillImpl> get copyWith =>
      __$$BillImplCopyWithImpl<_$BillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillImplToJson(this);
  }
}

abstract class _Bill extends Bill {
  const factory _Bill({
    required final int id,
    required final int occupancyId,
    required final BillType billType,
    required final int billingMonth,
    required final int billingYear,
    required final double amount,
    final double? electricityPrevReading,
    final double? electricityCurrReading,
    final double? electricityRateAtBilling,
    final double? electricityCharges,
    final String? meterPhotoPath,
    final String? notes,
    required final DateTime createdAt,
    final DateTime? dueDate,
    final DateTime? periodStartDate,
    final DateTime? periodEndDate,
    final double paidAmount,
    final double pendingAmount,
    final String? roomNumber,
    final String? tenantName,
    final String? propertyName,
  }) = _$BillImpl;
  const _Bill._() : super._();

  factory _Bill.fromJson(Map<String, dynamic> json) = _$BillImpl.fromJson;

  @override
  int get id;
  @override
  int get occupancyId;
  @override
  BillType get billType;
  @override
  int get billingMonth;
  @override
  int get billingYear;
  @override
  double get amount;
  @override
  double? get electricityPrevReading;
  @override
  double? get electricityCurrReading;
  @override
  double? get electricityRateAtBilling;
  @override
  double? get electricityCharges;
  @override
  String? get meterPhotoPath;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get dueDate;
  @override
  DateTime? get periodStartDate;
  @override
  DateTime? get periodEndDate; // Calculated fields
  @override
  double get paidAmount;
  @override
  double get pendingAmount; // Denormalized fields
  @override
  String? get roomNumber;
  @override
  String? get tenantName;
  @override
  String? get propertyName;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillImplCopyWith<_$BillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
