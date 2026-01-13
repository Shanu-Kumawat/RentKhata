/// Deposit transaction entity for tracking deposit history.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_transaction.freezed.dart';
part 'deposit_transaction.g.dart';

/// Deposit transaction types.
enum DepositTransactionType { received, deduction, returned }

/// Represents a deposit transaction.
@freezed
class DepositTransaction with _$DepositTransaction {
  const factory DepositTransaction({
    required int id,
    required int occupancyId,
    required DepositTransactionType transactionType,
    required double amount,
    required DateTime transactionDate,
    String? notes,
    required DateTime createdAt,
  }) = _DepositTransaction;

  factory DepositTransaction.fromJson(Map<String, dynamic> json) =>
      _$DepositTransactionFromJson(json);
}
