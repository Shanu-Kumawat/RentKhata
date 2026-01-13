// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deposit_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DepositTransaction _$DepositTransactionFromJson(Map<String, dynamic> json) {
  return _DepositTransaction.fromJson(json);
}

/// @nodoc
mixin _$DepositTransaction {
  int get id => throw _privateConstructorUsedError;
  int get occupancyId => throw _privateConstructorUsedError;
  DepositTransactionType get transactionType =>
      throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get transactionDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DepositTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DepositTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DepositTransactionCopyWith<DepositTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepositTransactionCopyWith<$Res> {
  factory $DepositTransactionCopyWith(
    DepositTransaction value,
    $Res Function(DepositTransaction) then,
  ) = _$DepositTransactionCopyWithImpl<$Res, DepositTransaction>;
  @useResult
  $Res call({
    int id,
    int occupancyId,
    DepositTransactionType transactionType,
    double amount,
    DateTime transactionDate,
    String? notes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$DepositTransactionCopyWithImpl<$Res, $Val extends DepositTransaction>
    implements $DepositTransactionCopyWith<$Res> {
  _$DepositTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DepositTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? occupancyId = null,
    Object? transactionType = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? notes = freezed,
    Object? createdAt = null,
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
            transactionType: null == transactionType
                ? _value.transactionType
                : transactionType // ignore: cast_nullable_to_non_nullable
                      as DepositTransactionType,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$DepositTransactionImplCopyWith<$Res>
    implements $DepositTransactionCopyWith<$Res> {
  factory _$$DepositTransactionImplCopyWith(
    _$DepositTransactionImpl value,
    $Res Function(_$DepositTransactionImpl) then,
  ) = __$$DepositTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int occupancyId,
    DepositTransactionType transactionType,
    double amount,
    DateTime transactionDate,
    String? notes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$DepositTransactionImplCopyWithImpl<$Res>
    extends _$DepositTransactionCopyWithImpl<$Res, _$DepositTransactionImpl>
    implements _$$DepositTransactionImplCopyWith<$Res> {
  __$$DepositTransactionImplCopyWithImpl(
    _$DepositTransactionImpl _value,
    $Res Function(_$DepositTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DepositTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? occupancyId = null,
    Object? transactionType = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$DepositTransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        occupancyId: null == occupancyId
            ? _value.occupancyId
            : occupancyId // ignore: cast_nullable_to_non_nullable
                  as int,
        transactionType: null == transactionType
            ? _value.transactionType
            : transactionType // ignore: cast_nullable_to_non_nullable
                  as DepositTransactionType,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$DepositTransactionImpl implements _DepositTransaction {
  const _$DepositTransactionImpl({
    required this.id,
    required this.occupancyId,
    required this.transactionType,
    required this.amount,
    required this.transactionDate,
    this.notes,
    required this.createdAt,
  });

  factory _$DepositTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepositTransactionImplFromJson(json);

  @override
  final int id;
  @override
  final int occupancyId;
  @override
  final DepositTransactionType transactionType;
  @override
  final double amount;
  @override
  final DateTime transactionDate;
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'DepositTransaction(id: $id, occupancyId: $occupancyId, transactionType: $transactionType, amount: $amount, transactionDate: $transactionDate, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepositTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.occupancyId, occupancyId) ||
                other.occupancyId == occupancyId) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    occupancyId,
    transactionType,
    amount,
    transactionDate,
    notes,
    createdAt,
  );

  /// Create a copy of DepositTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DepositTransactionImplCopyWith<_$DepositTransactionImpl> get copyWith =>
      __$$DepositTransactionImplCopyWithImpl<_$DepositTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DepositTransactionImplToJson(this);
  }
}

abstract class _DepositTransaction implements DepositTransaction {
  const factory _DepositTransaction({
    required final int id,
    required final int occupancyId,
    required final DepositTransactionType transactionType,
    required final double amount,
    required final DateTime transactionDate,
    final String? notes,
    required final DateTime createdAt,
  }) = _$DepositTransactionImpl;

  factory _DepositTransaction.fromJson(Map<String, dynamic> json) =
      _$DepositTransactionImpl.fromJson;

  @override
  int get id;
  @override
  int get occupancyId;
  @override
  DepositTransactionType get transactionType;
  @override
  double get amount;
  @override
  DateTime get transactionDate;
  @override
  String? get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of DepositTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DepositTransactionImplCopyWith<_$DepositTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
