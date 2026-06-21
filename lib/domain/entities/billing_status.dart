/// Billing status entities for cycle-based billing tracking.
library;

import 'package:rent_khata/l10n/app_localizations.dart';
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
    int? daysUntilDueDate,

    /// The agreed rent amount for pre-filling bill
    required double agreedRent,

    /// Property name for context
    String? propertyName,
  }) = _BillingAttentionItem;

  factory BillingAttentionItem.fromJson(Map<String, dynamic> json) =>
      _$BillingAttentionItemFromJson(json);

  /// Human-readable status label
  String statusLabel(AppLocalizations l10n) {
    switch (status) {
      case BillingCycleStatus.upToDate:
        return l10n.statusUpToDate;
      case BillingCycleStatus.pending:
        return l10n.statusPending;
      case BillingCycleStatus.dueSoon:
        return l10n.statusDueSoon;
      case BillingCycleStatus.overdue:
        return l10n.statusOverdue;
    }
  }

  /// Human-readable due description
  String dueDescription(AppLocalizations l10n) {
    final days = daysUntilDueDate;
    if (days == null) {
      return statusLabel(l10n);
    }
    if (days == 0) {
      return l10n.dueToday;
    } else if (days == 1) {
      return l10n.dueTomorrow;
    } else if (days > 0) {
      return l10n.dueInDays(days);
    } else if (days == -1) {
      return l10n.overdueOneDay;
    } else {
      return l10n.overdueDays(-days);
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
