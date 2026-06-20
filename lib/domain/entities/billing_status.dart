/// Billing status entities for cycle-based billing tracking.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'bill.dart';

part 'billing_status.freezed.dart';
part 'billing_status.g.dart';

/// Billing cycle status for an occupancy.
///
/// Represents whether a tenant needs billing attention:
/// - [upToDate]: Bill exists for current or upcoming cycle
/// - [dueSoon]: Cycle ending within threshold days, no bill yet
/// - [overdue]: Cycle ended without a bill being created
enum BillingCycleStatus {
  /// Bill exists for current cycle - no action needed
  upToDate,

  /// Cycle has ended, waiting for bill creation
  pending,

  /// Bill is due soon
  dueSoon,

  /// Cycle already ended without bill - action overdue
  overdue,
}

/// Represents a bill type that needs attention for an occupancy.
///
/// Used by the Dashboard's "Attention Needed" section to show
/// which tenants need bills created and for which bill types.
@freezed
class BillingAttentionItem with _$BillingAttentionItem {
  const BillingAttentionItem._();

  const factory BillingAttentionItem({
    required int occupancyId,
    required int roomId,
    required String roomNumber,
    required String tenantName,
    required DateTime cycleStart,
    required DateTime cycleEnd,
    required BillingCycleStatus status,

    /// The bill type that needs attention
    required BillType billType,

    /// Days until bill is due. Negative values mean cycle is overdue.
    required int daysUntilDueDate,

    /// The agreed rent amount for pre-filling bill
    required double agreedRent,

    /// Property name for context
    String? propertyName,
  }) = _BillingAttentionItem;

  factory BillingAttentionItem.fromJson(Map<String, dynamic> json) =>
      _$BillingAttentionItemFromJson(json);

  /// Human-readable status label
  String get statusLabel {
    switch (status) {
      case BillingCycleStatus.upToDate:
        return 'Up to date';
      case BillingCycleStatus.pending:
        return 'Pending';
      case BillingCycleStatus.dueSoon:
        return 'Due soon';
      case BillingCycleStatus.overdue:
        return 'Overdue';
    }
  }

  /// Human-readable due description
  String get dueDescription {
    if (daysUntilDueDate == 0) {
      return 'Due today';
    } else if (daysUntilDueDate == 1) {
      return 'Due tomorrow';
    } else if (daysUntilDueDate > 0) {
      return 'Due: in $daysUntilDueDate days';
    } else if (daysUntilDueDate == -1) {
      return 'Overdue: 1 day';
    } else {
      return 'Overdue: ${-daysUntilDueDate} days';
    }
  }

  /// Whether this item needs urgent attention (overdue)
  bool get isUrgent => status == BillingCycleStatus.overdue;
}

/// Configuration for billing attention thresholds.
class BillingAttentionConfig {
  /// Days before cycle end to show "due soon" warning
  final int dueSoonThresholdDays;

  const BillingAttentionConfig({this.dueSoonThresholdDays = 5});

  static const BillingAttentionConfig defaultConfig = BillingAttentionConfig();
}
