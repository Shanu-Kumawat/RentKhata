/// Bill domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill.freezed.dart';
part 'bill.g.dart';

/// Bill type enumeration.
/// Note: rentPlusElectricity was deprecated in v6 - use separate bills instead.
enum BillType { rent, electricity, water, maintenance, other }

/// Bill status for workflow tracking.
enum BillStatus {
  draft, // Just created, fully editable
  sent, // Invoice shared to tenant
  partial, // Has partial payments
  paid, // Fully paid
  overdue, // Past due date, not fully paid
  voided, // Cancelled/voided
}

/// Represents a bill for a tenant.
@freezed
class Bill with _$Bill {
  const Bill._();

  const factory Bill({
    required int id,
    required int occupancyId,
    required BillType billType,
    required int billingMonth,
    required int billingYear,
    required double amount,
    // Bill number (format: INV-YYYYMM-XXXX)
    String? billNumber,
    // Bill status
    @Default(BillStatus.draft) BillStatus status,
    double? electricityPrevReading,
    double? electricityCurrReading,
    double? electricityRateAtBilling,
    double? electricityCharges,
    String? meterPhotoPath,
    String? notes,
    required DateTime createdAt,
    DateTime? dueDate,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    // Calculated fields
    @Default(0.0) double paidAmount,
    @Default(0.0) double pendingAmount,
    // Denormalized fields
    String? roomNumber,
    String? tenantName,
    String? propertyName,
  }) = _Bill;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  /// Check if bill is fully paid
  bool get isFullyPaid => pendingAmount <= 0 || status == BillStatus.paid;

  /// Check if bill is overdue
  bool get isOverdue =>
      !isFullyPaid && dueDate != null && DateTime.now().isAfter(dueDate!);

  /// Check if bill can be fully edited (unpaid only)
  bool get canEdit =>
      status != BillStatus.paid &&
      status != BillStatus.voided &&
      paidAmount == 0;

  /// Check if bill allows limited editing (partial bills: notes, due date, increase amount)
  bool get canEditLimited =>
      status != BillStatus.paid &&
      status != BillStatus.voided &&
      paidAmount > 0 &&
      !isFullyPaid;

  /// Check if bill amount can be edited (only unpaid bills)
  bool get canEditAmount => paidAmount == 0;

  /// Check if bill can be deleted (only unpaid bills)
  bool get canDelete => paidAmount == 0 && status != BillStatus.voided;

  /// Check if bill can record payments
  bool get canRecordPayment => !isFullyPaid && status != BillStatus.voided;

  /// Get billing period as readable string
  String get billingPeriod {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[billingMonth - 1]} $billingYear';
  }
}
