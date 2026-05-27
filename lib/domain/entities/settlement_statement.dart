import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement_statement.freezed.dart';
part 'settlement_statement.g.dart';

@freezed
class SettlementBillDeduction with _$SettlementBillDeduction {
  const factory SettlementBillDeduction({
    required String billTypeLabel,
    required String period,
    required double amount,
  }) = _SettlementBillDeduction;

  factory SettlementBillDeduction.fromJson(Map<String, dynamic> json) =>
      _$SettlementBillDeductionFromJson(json);
}

@freezed
class SettlementStatement with _$SettlementStatement {
  const factory SettlementStatement({
    required int occupancyId,
    required String tenantName,
    required String landlordName,
    required String propertyName,
    required String roomNumber,
    required DateTime moveInDate,
    required DateTime moveOutDate,

    // Financials
    required double securityDeposit,
    @Default([]) List<SettlementBillDeduction> billDeductions,
    required double manualDeduction,
    String? manualDeductionReason,

    // Totals
    required double totalDeductions,
    required double refundAmount, // Negative means tenant owes
  }) = _SettlementStatement;

  factory SettlementStatement.fromJson(Map<String, dynamic> json) =>
      _$SettlementStatementFromJson(json);
}
