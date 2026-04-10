/// Ledger domain entities.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'bill.dart';
import 'payment.dart';

part 'ledger.freezed.dart';
part 'ledger.g.dart';

/// Type of ledger entry.
enum LedgerEntryType {
  openingBalance,
  billGenerated,
  paymentReceived,
  discount,
}

/// A single entry in the tenant ledger.
@freezed
class LedgerEntry with _$LedgerEntry {
  const factory LedgerEntry({
    required DateTime date,
    required LedgerEntryType type,
    required String description,
    required double debit, // Amount charged to the tenant
    required double credit, // Amount received from the tenant
    required double balance, // Running balance at this point
    // Optional references back to the original entities
    int? billId,
    BillType? billType,
    int? paymentId,
    PaymentMode? paymentMode,
  }) = _LedgerEntry;

  factory LedgerEntry.fromJson(Map<String, dynamic> json) =>
      _$LedgerEntryFromJson(json);
}

/// A comprehensive statement for a tenant's occupancy.
@freezed
class LedgerStatement with _$LedgerStatement {
  const factory LedgerStatement({
    required int occupancyId,
    required String tenantName,
    required String tenantPhone,
    required String roomNumber,
    required String propertyName,
    required String landlordName,
    required String landlordPhone,
    required DateTime moveInDate,
    DateTime? agreementEndDate,
    required DateTime statementDate,
    required List<LedgerEntry> entries,
    required double totalBilled,
    required double totalPaid,
    required double currentBalance, // Final outstanding amount
  }) = _LedgerStatement;

  factory LedgerStatement.fromJson(Map<String, dynamic> json) =>
      _$LedgerStatementFromJson(json);
}
