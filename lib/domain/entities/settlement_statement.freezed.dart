// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement_statement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SettlementBillDeduction _$SettlementBillDeductionFromJson(
  Map<String, dynamic> json,
) {
  return _SettlementBillDeduction.fromJson(json);
}

/// @nodoc
mixin _$SettlementBillDeduction {
  String get billTypeLabel => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this SettlementBillDeduction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettlementBillDeduction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementBillDeductionCopyWith<SettlementBillDeduction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementBillDeductionCopyWith<$Res> {
  factory $SettlementBillDeductionCopyWith(
    SettlementBillDeduction value,
    $Res Function(SettlementBillDeduction) then,
  ) = _$SettlementBillDeductionCopyWithImpl<$Res, SettlementBillDeduction>;
  @useResult
  $Res call({String billTypeLabel, String period, double amount});
}

/// @nodoc
class _$SettlementBillDeductionCopyWithImpl<
  $Res,
  $Val extends SettlementBillDeduction
>
    implements $SettlementBillDeductionCopyWith<$Res> {
  _$SettlementBillDeductionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettlementBillDeduction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billTypeLabel = null,
    Object? period = null,
    Object? amount = null,
  }) {
    return _then(
      _value.copyWith(
            billTypeLabel: null == billTypeLabel
                ? _value.billTypeLabel
                : billTypeLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettlementBillDeductionImplCopyWith<$Res>
    implements $SettlementBillDeductionCopyWith<$Res> {
  factory _$$SettlementBillDeductionImplCopyWith(
    _$SettlementBillDeductionImpl value,
    $Res Function(_$SettlementBillDeductionImpl) then,
  ) = __$$SettlementBillDeductionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String billTypeLabel, String period, double amount});
}

/// @nodoc
class __$$SettlementBillDeductionImplCopyWithImpl<$Res>
    extends
        _$SettlementBillDeductionCopyWithImpl<
          $Res,
          _$SettlementBillDeductionImpl
        >
    implements _$$SettlementBillDeductionImplCopyWith<$Res> {
  __$$SettlementBillDeductionImplCopyWithImpl(
    _$SettlementBillDeductionImpl _value,
    $Res Function(_$SettlementBillDeductionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettlementBillDeduction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billTypeLabel = null,
    Object? period = null,
    Object? amount = null,
  }) {
    return _then(
      _$SettlementBillDeductionImpl(
        billTypeLabel: null == billTypeLabel
            ? _value.billTypeLabel
            : billTypeLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettlementBillDeductionImpl implements _SettlementBillDeduction {
  const _$SettlementBillDeductionImpl({
    required this.billTypeLabel,
    required this.period,
    required this.amount,
  });

  factory _$SettlementBillDeductionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementBillDeductionImplFromJson(json);

  @override
  final String billTypeLabel;
  @override
  final String period;
  @override
  final double amount;

  @override
  String toString() {
    return 'SettlementBillDeduction(billTypeLabel: $billTypeLabel, period: $period, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementBillDeductionImpl &&
            (identical(other.billTypeLabel, billTypeLabel) ||
                other.billTypeLabel == billTypeLabel) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, billTypeLabel, period, amount);

  /// Create a copy of SettlementBillDeduction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementBillDeductionImplCopyWith<_$SettlementBillDeductionImpl>
  get copyWith =>
      __$$SettlementBillDeductionImplCopyWithImpl<
        _$SettlementBillDeductionImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementBillDeductionImplToJson(this);
  }
}

abstract class _SettlementBillDeduction implements SettlementBillDeduction {
  const factory _SettlementBillDeduction({
    required final String billTypeLabel,
    required final String period,
    required final double amount,
  }) = _$SettlementBillDeductionImpl;

  factory _SettlementBillDeduction.fromJson(Map<String, dynamic> json) =
      _$SettlementBillDeductionImpl.fromJson;

  @override
  String get billTypeLabel;
  @override
  String get period;
  @override
  double get amount;

  /// Create a copy of SettlementBillDeduction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementBillDeductionImplCopyWith<_$SettlementBillDeductionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SettlementStatement _$SettlementStatementFromJson(Map<String, dynamic> json) {
  return _SettlementStatement.fromJson(json);
}

/// @nodoc
mixin _$SettlementStatement {
  int get occupancyId => throw _privateConstructorUsedError;
  String get tenantName => throw _privateConstructorUsedError;
  String get landlordName => throw _privateConstructorUsedError;
  String get propertyName => throw _privateConstructorUsedError;
  String get roomNumber => throw _privateConstructorUsedError;
  DateTime get moveInDate => throw _privateConstructorUsedError;
  DateTime get moveOutDate => throw _privateConstructorUsedError; // Financials
  double get securityDeposit => throw _privateConstructorUsedError;
  List<SettlementBillDeduction> get billDeductions =>
      throw _privateConstructorUsedError;
  double get manualDeduction => throw _privateConstructorUsedError;
  String? get manualDeductionReason =>
      throw _privateConstructorUsedError; // Totals
  double get totalDeductions => throw _privateConstructorUsedError;
  double get refundAmount => throw _privateConstructorUsedError;

  /// Serializes this SettlementStatement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettlementStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementStatementCopyWith<SettlementStatement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementStatementCopyWith<$Res> {
  factory $SettlementStatementCopyWith(
    SettlementStatement value,
    $Res Function(SettlementStatement) then,
  ) = _$SettlementStatementCopyWithImpl<$Res, SettlementStatement>;
  @useResult
  $Res call({
    int occupancyId,
    String tenantName,
    String landlordName,
    String propertyName,
    String roomNumber,
    DateTime moveInDate,
    DateTime moveOutDate,
    double securityDeposit,
    List<SettlementBillDeduction> billDeductions,
    double manualDeduction,
    String? manualDeductionReason,
    double totalDeductions,
    double refundAmount,
  });
}

/// @nodoc
class _$SettlementStatementCopyWithImpl<$Res, $Val extends SettlementStatement>
    implements $SettlementStatementCopyWith<$Res> {
  _$SettlementStatementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettlementStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? occupancyId = null,
    Object? tenantName = null,
    Object? landlordName = null,
    Object? propertyName = null,
    Object? roomNumber = null,
    Object? moveInDate = null,
    Object? moveOutDate = null,
    Object? securityDeposit = null,
    Object? billDeductions = null,
    Object? manualDeduction = null,
    Object? manualDeductionReason = freezed,
    Object? totalDeductions = null,
    Object? refundAmount = null,
  }) {
    return _then(
      _value.copyWith(
            occupancyId: null == occupancyId
                ? _value.occupancyId
                : occupancyId // ignore: cast_nullable_to_non_nullable
                      as int,
            tenantName: null == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String,
            landlordName: null == landlordName
                ? _value.landlordName
                : landlordName // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyName: null == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String,
            roomNumber: null == roomNumber
                ? _value.roomNumber
                : roomNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            moveInDate: null == moveInDate
                ? _value.moveInDate
                : moveInDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            moveOutDate: null == moveOutDate
                ? _value.moveOutDate
                : moveOutDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            securityDeposit: null == securityDeposit
                ? _value.securityDeposit
                : securityDeposit // ignore: cast_nullable_to_non_nullable
                      as double,
            billDeductions: null == billDeductions
                ? _value.billDeductions
                : billDeductions // ignore: cast_nullable_to_non_nullable
                      as List<SettlementBillDeduction>,
            manualDeduction: null == manualDeduction
                ? _value.manualDeduction
                : manualDeduction // ignore: cast_nullable_to_non_nullable
                      as double,
            manualDeductionReason: freezed == manualDeductionReason
                ? _value.manualDeductionReason
                : manualDeductionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalDeductions: null == totalDeductions
                ? _value.totalDeductions
                : totalDeductions // ignore: cast_nullable_to_non_nullable
                      as double,
            refundAmount: null == refundAmount
                ? _value.refundAmount
                : refundAmount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettlementStatementImplCopyWith<$Res>
    implements $SettlementStatementCopyWith<$Res> {
  factory _$$SettlementStatementImplCopyWith(
    _$SettlementStatementImpl value,
    $Res Function(_$SettlementStatementImpl) then,
  ) = __$$SettlementStatementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int occupancyId,
    String tenantName,
    String landlordName,
    String propertyName,
    String roomNumber,
    DateTime moveInDate,
    DateTime moveOutDate,
    double securityDeposit,
    List<SettlementBillDeduction> billDeductions,
    double manualDeduction,
    String? manualDeductionReason,
    double totalDeductions,
    double refundAmount,
  });
}

/// @nodoc
class __$$SettlementStatementImplCopyWithImpl<$Res>
    extends _$SettlementStatementCopyWithImpl<$Res, _$SettlementStatementImpl>
    implements _$$SettlementStatementImplCopyWith<$Res> {
  __$$SettlementStatementImplCopyWithImpl(
    _$SettlementStatementImpl _value,
    $Res Function(_$SettlementStatementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettlementStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? occupancyId = null,
    Object? tenantName = null,
    Object? landlordName = null,
    Object? propertyName = null,
    Object? roomNumber = null,
    Object? moveInDate = null,
    Object? moveOutDate = null,
    Object? securityDeposit = null,
    Object? billDeductions = null,
    Object? manualDeduction = null,
    Object? manualDeductionReason = freezed,
    Object? totalDeductions = null,
    Object? refundAmount = null,
  }) {
    return _then(
      _$SettlementStatementImpl(
        occupancyId: null == occupancyId
            ? _value.occupancyId
            : occupancyId // ignore: cast_nullable_to_non_nullable
                  as int,
        tenantName: null == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String,
        landlordName: null == landlordName
            ? _value.landlordName
            : landlordName // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        roomNumber: null == roomNumber
            ? _value.roomNumber
            : roomNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        moveInDate: null == moveInDate
            ? _value.moveInDate
            : moveInDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        moveOutDate: null == moveOutDate
            ? _value.moveOutDate
            : moveOutDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        securityDeposit: null == securityDeposit
            ? _value.securityDeposit
            : securityDeposit // ignore: cast_nullable_to_non_nullable
                  as double,
        billDeductions: null == billDeductions
            ? _value._billDeductions
            : billDeductions // ignore: cast_nullable_to_non_nullable
                  as List<SettlementBillDeduction>,
        manualDeduction: null == manualDeduction
            ? _value.manualDeduction
            : manualDeduction // ignore: cast_nullable_to_non_nullable
                  as double,
        manualDeductionReason: freezed == manualDeductionReason
            ? _value.manualDeductionReason
            : manualDeductionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalDeductions: null == totalDeductions
            ? _value.totalDeductions
            : totalDeductions // ignore: cast_nullable_to_non_nullable
                  as double,
        refundAmount: null == refundAmount
            ? _value.refundAmount
            : refundAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettlementStatementImpl implements _SettlementStatement {
  const _$SettlementStatementImpl({
    required this.occupancyId,
    required this.tenantName,
    required this.landlordName,
    required this.propertyName,
    required this.roomNumber,
    required this.moveInDate,
    required this.moveOutDate,
    required this.securityDeposit,
    final List<SettlementBillDeduction> billDeductions = const [],
    required this.manualDeduction,
    this.manualDeductionReason,
    required this.totalDeductions,
    required this.refundAmount,
  }) : _billDeductions = billDeductions;

  factory _$SettlementStatementImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementStatementImplFromJson(json);

  @override
  final int occupancyId;
  @override
  final String tenantName;
  @override
  final String landlordName;
  @override
  final String propertyName;
  @override
  final String roomNumber;
  @override
  final DateTime moveInDate;
  @override
  final DateTime moveOutDate;
  // Financials
  @override
  final double securityDeposit;
  final List<SettlementBillDeduction> _billDeductions;
  @override
  @JsonKey()
  List<SettlementBillDeduction> get billDeductions {
    if (_billDeductions is EqualUnmodifiableListView) return _billDeductions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_billDeductions);
  }

  @override
  final double manualDeduction;
  @override
  final String? manualDeductionReason;
  // Totals
  @override
  final double totalDeductions;
  @override
  final double refundAmount;

  @override
  String toString() {
    return 'SettlementStatement(occupancyId: $occupancyId, tenantName: $tenantName, landlordName: $landlordName, propertyName: $propertyName, roomNumber: $roomNumber, moveInDate: $moveInDate, moveOutDate: $moveOutDate, securityDeposit: $securityDeposit, billDeductions: $billDeductions, manualDeduction: $manualDeduction, manualDeductionReason: $manualDeductionReason, totalDeductions: $totalDeductions, refundAmount: $refundAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementStatementImpl &&
            (identical(other.occupancyId, occupancyId) ||
                other.occupancyId == occupancyId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.landlordName, landlordName) ||
                other.landlordName == landlordName) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.moveInDate, moveInDate) ||
                other.moveInDate == moveInDate) &&
            (identical(other.moveOutDate, moveOutDate) ||
                other.moveOutDate == moveOutDate) &&
            (identical(other.securityDeposit, securityDeposit) ||
                other.securityDeposit == securityDeposit) &&
            const DeepCollectionEquality().equals(
              other._billDeductions,
              _billDeductions,
            ) &&
            (identical(other.manualDeduction, manualDeduction) ||
                other.manualDeduction == manualDeduction) &&
            (identical(other.manualDeductionReason, manualDeductionReason) ||
                other.manualDeductionReason == manualDeductionReason) &&
            (identical(other.totalDeductions, totalDeductions) ||
                other.totalDeductions == totalDeductions) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    occupancyId,
    tenantName,
    landlordName,
    propertyName,
    roomNumber,
    moveInDate,
    moveOutDate,
    securityDeposit,
    const DeepCollectionEquality().hash(_billDeductions),
    manualDeduction,
    manualDeductionReason,
    totalDeductions,
    refundAmount,
  );

  /// Create a copy of SettlementStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementStatementImplCopyWith<_$SettlementStatementImpl> get copyWith =>
      __$$SettlementStatementImplCopyWithImpl<_$SettlementStatementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementStatementImplToJson(this);
  }
}

abstract class _SettlementStatement implements SettlementStatement {
  const factory _SettlementStatement({
    required final int occupancyId,
    required final String tenantName,
    required final String landlordName,
    required final String propertyName,
    required final String roomNumber,
    required final DateTime moveInDate,
    required final DateTime moveOutDate,
    required final double securityDeposit,
    final List<SettlementBillDeduction> billDeductions,
    required final double manualDeduction,
    final String? manualDeductionReason,
    required final double totalDeductions,
    required final double refundAmount,
  }) = _$SettlementStatementImpl;

  factory _SettlementStatement.fromJson(Map<String, dynamic> json) =
      _$SettlementStatementImpl.fromJson;

  @override
  int get occupancyId;
  @override
  String get tenantName;
  @override
  String get landlordName;
  @override
  String get propertyName;
  @override
  String get roomNumber;
  @override
  DateTime get moveInDate;
  @override
  DateTime get moveOutDate; // Financials
  @override
  double get securityDeposit;
  @override
  List<SettlementBillDeduction> get billDeductions;
  @override
  double get manualDeduction;
  @override
  String? get manualDeductionReason; // Totals
  @override
  double get totalDeductions;
  @override
  double get refundAmount;

  /// Create a copy of SettlementStatement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementStatementImplCopyWith<_$SettlementStatementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
