/// Billing status entities for cycle-based billing tracking.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

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

  /// Cycle ending soon (within threshold) - time to create bill
  dueSoon,

  /// Cycle already ended without bill - action overdue
  overdue,
}

/// Represents an occupancy that needs billing attention.
///
/// Used by the Dashboard's "Attention Needed" section to show
/// which tenants need bills created.
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

    /// Days until cycle ends. Negative values mean cycle is overdue.
    required int daysUntilCycleEnd,

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
      case BillingCycleStatus.dueSoon:
        return 'Due soon';
      case BillingCycleStatus.overdue:
        return 'Overdue';
    }
  }

  /// Human-readable cycle end description
  String get cycleEndDescription {
    if (daysUntilCycleEnd == 0) {
      return 'Ends today';
    } else if (daysUntilCycleEnd == 1) {
      return 'Ends tomorrow';
    } else if (daysUntilCycleEnd > 0) {
      return 'Ends in $daysUntilCycleEnd days';
    } else if (daysUntilCycleEnd == -1) {
      return 'Ended yesterday';
    } else {
      return 'Ended ${-daysUntilCycleEnd} days ago';
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
