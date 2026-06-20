/// Bill domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'billing_status.dart';

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
  bool get isFullyPaid =>
      status != BillStatus.voided &&
      (pendingAmount <= 0 || status == BillStatus.paid);

  /// Check if bill is an advance bill (billing period hasn't started)
  bool get isAdvance {
    if (isFullyPaid || periodStartDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final periodStart = DateTime(periodStartDate!.year, periodStartDate!.month, periodStartDate!.day);
    return today.isBefore(periodStart);
  }

  /// Check if bill is overdue (past due date)
  bool get isOverdue {
    if (isFullyPaid || dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return today.isAfter(due);
  }

  /// Check if bill is due soon (within threshold days of due date)
  bool get isDueSoon {
    if (isFullyPaid || dueDate == null || isOverdue || isAdvance) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    final difference = due.difference(today).inDays;
    return difference >= 0 && difference <= BillingAttentionConfig.defaultConfig.dueSoonThresholdDays;
  }

  /// Check if bill is currently pending (cycle started, but not due soon yet)
  bool get isPending {
    return !isFullyPaid && !isAdvance && !isDueSoon && !isOverdue;
  }

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

  /// Get billing period as readable string.
  /// Uses anniversary-based dates when available, falls back to month format.
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

    // Use anniversary-based dates if available
    if (periodStartDate != null && periodEndDate != null) {
      final startMonth = months[periodStartDate!.month - 1];
      final endMonth = months[periodEndDate!.month - 1];

      // Same year: "Dec 13 - Jan 12, 2026"
      if (periodStartDate!.year == periodEndDate!.year) {
        return '$startMonth ${periodStartDate!.day} - $endMonth ${periodEndDate!.day}, ${periodEndDate!.year}';
      } else {
        // Different years: "Dec 13, 2025 - Jan 12, 2026"
        return '$startMonth ${periodStartDate!.day}, ${periodStartDate!.year} - $endMonth ${periodEndDate!.day}, ${periodEndDate!.year}';
      }
    }

    // Fallback to month-based format
    int safeMonth = billingMonth;
    if (safeMonth < 1) safeMonth = 1;
    if (safeMonth > 12) safeMonth = 12;
    return '${months[safeMonth - 1]} $billingYear';
  }
}
