// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LedgerEntry _$LedgerEntryFromJson(Map<String, dynamic> json) {
  return _LedgerEntry.fromJson(json);
}

/// @nodoc
mixin _$LedgerEntry {
  DateTime get date => throw _privateConstructorUsedError;
  LedgerEntryType get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get debit =>
      throw _privateConstructorUsedError; // Amount charged to the tenant
  double get credit =>
      throw _privateConstructorUsedError; // Amount received from the tenant
  double get balance =>
      throw _privateConstructorUsedError; // Running balance at this point
  // Optional references back to the original entities
  int? get billId => throw _privateConstructorUsedError;
  BillType? get billType => throw _privateConstructorUsedError;
  int? get paymentId => throw _privateConstructorUsedError;
  PaymentMode? get paymentMode => throw _privateConstructorUsedError;

  /// Serializes this LedgerEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LedgerEntryCopyWith<LedgerEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerEntryCopyWith<$Res> {
  factory $LedgerEntryCopyWith(
    LedgerEntry value,
    $Res Function(LedgerEntry) then,
  ) = _$LedgerEntryCopyWithImpl<$Res, LedgerEntry>;
  @useResult
  $Res call({
    DateTime date,
    LedgerEntryType type,
    String description,
    double debit,
    double credit,
    double balance,
    int? billId,
    BillType? billType,
    int? paymentId,
    PaymentMode? paymentMode,
  });
}

/// @nodoc
class _$LedgerEntryCopyWithImpl<$Res, $Val extends LedgerEntry>
    implements $LedgerEntryCopyWith<$Res> {
  _$LedgerEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? type = null,
    Object? description = null,
    Object? debit = null,
    Object? credit = null,
    Object? balance = null,
    Object? billId = freezed,
    Object? billType = freezed,
    Object? paymentId = freezed,
    Object? paymentMode = freezed,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as LedgerEntryType,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            debit: null == debit
                ? _value.debit
                : debit // ignore: cast_nullable_to_non_nullable
                      as double,
            credit: null == credit
                ? _value.credit
                : credit // ignore: cast_nullable_to_non_nullable
                      as double,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            billId: freezed == billId
                ? _value.billId
                : billId // ignore: cast_nullable_to_non_nullable
                      as int?,
            billType: freezed == billType
                ? _value.billType
                : billType // ignore: cast_nullable_to_non_nullable
                      as BillType?,
            paymentId: freezed == paymentId
                ? _value.paymentId
                : paymentId // ignore: cast_nullable_to_non_nullable
                      as int?,
            paymentMode: freezed == paymentMode
                ? _value.paymentMode
                : paymentMode // ignore: cast_nullable_to_non_nullable
                      as PaymentMode?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LedgerEntryImplCopyWith<$Res>
    implements $LedgerEntryCopyWith<$Res> {
  factory _$$LedgerEntryImplCopyWith(
    _$LedgerEntryImpl value,
    $Res Function(_$LedgerEntryImpl) then,
  ) = __$$LedgerEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    LedgerEntryType type,
    String description,
    double debit,
    double credit,
    double balance,
    int? billId,
    BillType? billType,
    int? paymentId,
    PaymentMode? paymentMode,
  });
}

/// @nodoc
class __$$LedgerEntryImplCopyWithImpl<$Res>
    extends _$LedgerEntryCopyWithImpl<$Res, _$LedgerEntryImpl>
    implements _$$LedgerEntryImplCopyWith<$Res> {
  __$$LedgerEntryImplCopyWithImpl(
    _$LedgerEntryImpl _value,
    $Res Function(_$LedgerEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? type = null,
    Object? description = null,
    Object? debit = null,
    Object? credit = null,
    Object? balance = null,
    Object? billId = freezed,
    Object? billType = freezed,
    Object? paymentId = freezed,
    Object? paymentMode = freezed,
  }) {
    return _then(
      _$LedgerEntryImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as LedgerEntryType,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        debit: null == debit
            ? _value.debit
            : debit // ignore: cast_nullable_to_non_nullable
                  as double,
        credit: null == credit
            ? _value.credit
            : credit // ignore: cast_nullable_to_non_nullable
                  as double,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        billId: freezed == billId
            ? _value.billId
            : billId // ignore: cast_nullable_to_non_nullable
                  as int?,
        billType: freezed == billType
            ? _value.billType
            : billType // ignore: cast_nullable_to_non_nullable
                  as BillType?,
        paymentId: freezed == paymentId
            ? _value.paymentId
            : paymentId // ignore: cast_nullable_to_non_nullable
                  as int?,
        paymentMode: freezed == paymentMode
            ? _value.paymentMode
            : paymentMode // ignore: cast_nullable_to_non_nullable
                  as PaymentMode?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerEntryImpl implements _LedgerEntry {
  const _$LedgerEntryImpl({
    required this.date,
    required this.type,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    this.billId,
    this.billType,
    this.paymentId,
    this.paymentMode,
  });

  factory _$LedgerEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerEntryImplFromJson(json);

  @override
  final DateTime date;
  @override
  final LedgerEntryType type;
  @override
  final String description;
  @override
  final double debit;
  // Amount charged to the tenant
  @override
  final double credit;
  // Amount received from the tenant
  @override
  final double balance;
  // Running balance at this point
  // Optional references back to the original entities
  @override
  final int? billId;
  @override
  final BillType? billType;
  @override
  final int? paymentId;
  @override
  final PaymentMode? paymentMode;

  @override
  String toString() {
    return 'LedgerEntry(date: $date, type: $type, description: $description, debit: $debit, credit: $credit, balance: $balance, billId: $billId, billType: $billType, paymentId: $paymentId, paymentMode: $paymentMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerEntryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.billId, billId) || other.billId == billId) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.paymentMode, paymentMode) ||
                other.paymentMode == paymentMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    type,
    description,
    debit,
    credit,
    balance,
    billId,
    billType,
    paymentId,
    paymentMode,
  );

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerEntryImplCopyWith<_$LedgerEntryImpl> get copyWith =>
      __$$LedgerEntryImplCopyWithImpl<_$LedgerEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerEntryImplToJson(this);
  }
}

abstract class _LedgerEntry implements LedgerEntry {
  const factory _LedgerEntry({
    required final DateTime date,
    required final LedgerEntryType type,
    required final String description,
    required final double debit,
    required final double credit,
    required final double balance,
    final int? billId,
    final BillType? billType,
    final int? paymentId,
    final PaymentMode? paymentMode,
  }) = _$LedgerEntryImpl;

  factory _LedgerEntry.fromJson(Map<String, dynamic> json) =
      _$LedgerEntryImpl.fromJson;

  @override
  DateTime get date;
  @override
  LedgerEntryType get type;
  @override
  String get description;
  @override
  double get debit; // Amount charged to the tenant
  @override
  double get credit; // Amount received from the tenant
  @override
  double get balance; // Running balance at this point
  // Optional references back to the original entities
  @override
  int? get billId;
  @override
  BillType? get billType;
  @override
  int? get paymentId;
  @override
  PaymentMode? get paymentMode;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LedgerEntryImplCopyWith<_$LedgerEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LedgerStatement _$LedgerStatementFromJson(Map<String, dynamic> json) {
  return _LedgerStatement.fromJson(json);
}

/// @nodoc
mixin _$LedgerStatement {
  int get occupancyId => throw _privateConstructorUsedError;
  String get tenantName => throw _privateConstructorUsedError;
  String get tenantPhone => throw _privateConstructorUsedError;
  String get roomNumber => throw _privateConstructorUsedError;
  String get propertyName => throw _privateConstructorUsedError;
  String get landlordName => throw _privateConstructorUsedError;
  String get landlordPhone => throw _privateConstructorUsedError;
  DateTime get moveInDate => throw _privateConstructorUsedError;
  DateTime? get agreementEndDate => throw _privateConstructorUsedError;
  DateTime get statementDate => throw _privateConstructorUsedError;
  List<LedgerEntry> get entries => throw _privateConstructorUsedError;
  double get totalBilled => throw _privateConstructorUsedError;
  double get totalPaid => throw _privateConstructorUsedError;
  double get currentBalance => throw _privateConstructorUsedError;

  /// Serializes this LedgerStatement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LedgerStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LedgerStatementCopyWith<LedgerStatement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerStatementCopyWith<$Res> {
  factory $LedgerStatementCopyWith(
    LedgerStatement value,
    $Res Function(LedgerStatement) then,
  ) = _$LedgerStatementCopyWithImpl<$Res, LedgerStatement>;
  @useResult
  $Res call({
    int occupancyId,
    String tenantName,
    String tenantPhone,
    String roomNumber,
    String propertyName,
    String landlordName,
    String landlordPhone,
    DateTime moveInDate,
    DateTime? agreementEndDate,
    DateTime statementDate,
    List<LedgerEntry> entries,
    double totalBilled,
    double totalPaid,
    double currentBalance,
  });
}

/// @nodoc
class _$LedgerStatementCopyWithImpl<$Res, $Val extends LedgerStatement>
    implements $LedgerStatementCopyWith<$Res> {
  _$LedgerStatementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LedgerStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? occupancyId = null,
    Object? tenantName = null,
    Object? tenantPhone = null,
    Object? roomNumber = null,
    Object? propertyName = null,
    Object? landlordName = null,
    Object? landlordPhone = null,
    Object? moveInDate = null,
    Object? agreementEndDate = freezed,
    Object? statementDate = null,
    Object? entries = null,
    Object? totalBilled = null,
    Object? totalPaid = null,
    Object? currentBalance = null,
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
            tenantPhone: null == tenantPhone
                ? _value.tenantPhone
                : tenantPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            roomNumber: null == roomNumber
                ? _value.roomNumber
                : roomNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyName: null == propertyName
                ? _value.propertyName
                : propertyName // ignore: cast_nullable_to_non_nullable
                      as String,
            landlordName: null == landlordName
                ? _value.landlordName
                : landlordName // ignore: cast_nullable_to_non_nullable
                      as String,
            landlordPhone: null == landlordPhone
                ? _value.landlordPhone
                : landlordPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            moveInDate: null == moveInDate
                ? _value.moveInDate
                : moveInDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            agreementEndDate: freezed == agreementEndDate
                ? _value.agreementEndDate
                : agreementEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            statementDate: null == statementDate
                ? _value.statementDate
                : statementDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<LedgerEntry>,
            totalBilled: null == totalBilled
                ? _value.totalBilled
                : totalBilled // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPaid: null == totalPaid
                ? _value.totalPaid
                : totalPaid // ignore: cast_nullable_to_non_nullable
                      as double,
            currentBalance: null == currentBalance
                ? _value.currentBalance
                : currentBalance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LedgerStatementImplCopyWith<$Res>
    implements $LedgerStatementCopyWith<$Res> {
  factory _$$LedgerStatementImplCopyWith(
    _$LedgerStatementImpl value,
    $Res Function(_$LedgerStatementImpl) then,
  ) = __$$LedgerStatementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int occupancyId,
    String tenantName,
    String tenantPhone,
    String roomNumber,
    String propertyName,
    String landlordName,
    String landlordPhone,
    DateTime moveInDate,
    DateTime? agreementEndDate,
    DateTime statementDate,
    List<LedgerEntry> entries,
    double totalBilled,
    double totalPaid,
    double currentBalance,
  });
}

/// @nodoc
class __$$LedgerStatementImplCopyWithImpl<$Res>
    extends _$LedgerStatementCopyWithImpl<$Res, _$LedgerStatementImpl>
    implements _$$LedgerStatementImplCopyWith<$Res> {
  __$$LedgerStatementImplCopyWithImpl(
    _$LedgerStatementImpl _value,
    $Res Function(_$LedgerStatementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LedgerStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? occupancyId = null,
    Object? tenantName = null,
    Object? tenantPhone = null,
    Object? roomNumber = null,
    Object? propertyName = null,
    Object? landlordName = null,
    Object? landlordPhone = null,
    Object? moveInDate = null,
    Object? agreementEndDate = freezed,
    Object? statementDate = null,
    Object? entries = null,
    Object? totalBilled = null,
    Object? totalPaid = null,
    Object? currentBalance = null,
  }) {
    return _then(
      _$LedgerStatementImpl(
        occupancyId: null == occupancyId
            ? _value.occupancyId
            : occupancyId // ignore: cast_nullable_to_non_nullable
                  as int,
        tenantName: null == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantPhone: null == tenantPhone
            ? _value.tenantPhone
            : tenantPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        roomNumber: null == roomNumber
            ? _value.roomNumber
            : roomNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        landlordName: null == landlordName
            ? _value.landlordName
            : landlordName // ignore: cast_nullable_to_non_nullable
                  as String,
        landlordPhone: null == landlordPhone
            ? _value.landlordPhone
            : landlordPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        moveInDate: null == moveInDate
            ? _value.moveInDate
            : moveInDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        agreementEndDate: freezed == agreementEndDate
            ? _value.agreementEndDate
            : agreementEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        statementDate: null == statementDate
            ? _value.statementDate
            : statementDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<LedgerEntry>,
        totalBilled: null == totalBilled
            ? _value.totalBilled
            : totalBilled // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPaid: null == totalPaid
            ? _value.totalPaid
            : totalPaid // ignore: cast_nullable_to_non_nullable
                  as double,
        currentBalance: null == currentBalance
            ? _value.currentBalance
            : currentBalance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerStatementImpl implements _LedgerStatement {
  const _$LedgerStatementImpl({
    required this.occupancyId,
    required this.tenantName,
    required this.tenantPhone,
    required this.roomNumber,
    required this.propertyName,
    required this.landlordName,
    required this.landlordPhone,
    required this.moveInDate,
    this.agreementEndDate,
    required this.statementDate,
    required final List<LedgerEntry> entries,
    required this.totalBilled,
    required this.totalPaid,
    required this.currentBalance,
  }) : _entries = entries;

  factory _$LedgerStatementImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerStatementImplFromJson(json);

  @override
  final int occupancyId;
  @override
  final String tenantName;
  @override
  final String tenantPhone;
  @override
  final String roomNumber;
  @override
  final String propertyName;
  @override
  final String landlordName;
  @override
  final String landlordPhone;
  @override
  final DateTime moveInDate;
  @override
  final DateTime? agreementEndDate;
  @override
  final DateTime statementDate;
  final List<LedgerEntry> _entries;
  @override
  List<LedgerEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final double totalBilled;
  @override
  final double totalPaid;
  @override
  final double currentBalance;

  @override
  String toString() {
    return 'LedgerStatement(occupancyId: $occupancyId, tenantName: $tenantName, tenantPhone: $tenantPhone, roomNumber: $roomNumber, propertyName: $propertyName, landlordName: $landlordName, landlordPhone: $landlordPhone, moveInDate: $moveInDate, agreementEndDate: $agreementEndDate, statementDate: $statementDate, entries: $entries, totalBilled: $totalBilled, totalPaid: $totalPaid, currentBalance: $currentBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerStatementImpl &&
            (identical(other.occupancyId, occupancyId) ||
                other.occupancyId == occupancyId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.tenantPhone, tenantPhone) ||
                other.tenantPhone == tenantPhone) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.landlordName, landlordName) ||
                other.landlordName == landlordName) &&
            (identical(other.landlordPhone, landlordPhone) ||
                other.landlordPhone == landlordPhone) &&
            (identical(other.moveInDate, moveInDate) ||
                other.moveInDate == moveInDate) &&
            (identical(other.agreementEndDate, agreementEndDate) ||
                other.agreementEndDate == agreementEndDate) &&
            (identical(other.statementDate, statementDate) ||
                other.statementDate == statementDate) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.totalBilled, totalBilled) ||
                other.totalBilled == totalBilled) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    occupancyId,
    tenantName,
    tenantPhone,
    roomNumber,
    propertyName,
    landlordName,
    landlordPhone,
    moveInDate,
    agreementEndDate,
    statementDate,
    const DeepCollectionEquality().hash(_entries),
    totalBilled,
    totalPaid,
    currentBalance,
  );

  /// Create a copy of LedgerStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerStatementImplCopyWith<_$LedgerStatementImpl> get copyWith =>
      __$$LedgerStatementImplCopyWithImpl<_$LedgerStatementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerStatementImplToJson(this);
  }
}

abstract class _LedgerStatement implements LedgerStatement {
  const factory _LedgerStatement({
    required final int occupancyId,
    required final String tenantName,
    required final String tenantPhone,
    required final String roomNumber,
    required final String propertyName,
    required final String landlordName,
    required final String landlordPhone,
    required final DateTime moveInDate,
    final DateTime? agreementEndDate,
    required final DateTime statementDate,
    required final List<LedgerEntry> entries,
    required final double totalBilled,
    required final double totalPaid,
    required final double currentBalance,
  }) = _$LedgerStatementImpl;

  factory _LedgerStatement.fromJson(Map<String, dynamic> json) =
      _$LedgerStatementImpl.fromJson;

  @override
  int get occupancyId;
  @override
  String get tenantName;
  @override
  String get tenantPhone;
  @override
  String get roomNumber;
  @override
  String get propertyName;
  @override
  String get landlordName;
  @override
  String get landlordPhone;
  @override
  DateTime get moveInDate;
  @override
  DateTime? get agreementEndDate;
  @override
  DateTime get statementDate;
  @override
  List<LedgerEntry> get entries;
  @override
  double get totalBilled;
  @override
  double get totalPaid;
  @override
  double get currentBalance;

  /// Create a copy of LedgerStatement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LedgerStatementImplCopyWith<_$LedgerStatementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
