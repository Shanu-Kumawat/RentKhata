/// Bill domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill.freezed.dart';
part 'bill.g.dart';

/// Bill type enumeration.
enum BillType {
  rent,
  electricity,
  water,
  maintenance,
  other,
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
    double? electricityPrevReading,
    double? electricityCurrReading,
    double? electricityRateAtBilling,
    double? electricityCharges,
    String? meterPhotoPath,
    String? notes,
    required DateTime createdAt,
    DateTime? dueDate,
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
  bool get isFullyPaid => pendingAmount <= 0;

  /// Check if bill is overdue
  bool get isOverdue =>
      !isFullyPaid && dueDate != null && DateTime.now().isAfter(dueDate!);

  /// Get billing period as readable string
  String get billingPeriod {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[billingMonth - 1]} $billingYear';
  }
}
