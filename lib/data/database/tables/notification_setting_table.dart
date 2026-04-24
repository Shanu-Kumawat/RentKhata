/// Notification settings table definition.
library;

import 'package:drift/drift.dart';

/// Notification types organized by category.
enum NotificationType {
  // Billing reminders
  cycleEndingSoon,
  billDueSoon,
  monthlySummary,

  // Payment notifications
  paymentReceived,
  billFullyPaid,

  // Overdue escalation
  overdue1Day,
  overdue3Days,
  overdue7Days,
  overdue14Days,

  // Smart alerts
  agreementExpiringSoon,
  agreementExpired,
  billNotGenerated,
  partialPaymentPause,
  depositSettlementDue,
  utilityUsageAnomaly,

  // Legacy (kept for backwards compatibility)
  dueSoon,
  overdue,
  rentCollectionDay,
  depositPending,
  billsReadyToGenerate,
}

/// Table for storing notification preferences.
@DataClassName('NotificationSettingEntity')
class NotificationSettings extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Type of notification
  TextColumn get notificationType => textEnum<NotificationType>()();

  /// Whether this notification is enabled
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  /// Days before/after to trigger (positive = before due, negative = after)
  IntColumn get daysBefore => integer().withDefault(const Constant(3))();

  /// Quiet hours start (0-23)
  IntColumn get quietHoursStart => integer().nullable()();

  /// Quiet hours end (0-23)
  IntColumn get quietHoursEnd => integer().nullable()();

  /// Preferred notification time (hour, 0-23)
  IntColumn get notificationHour => integer().withDefault(const Constant(9))();
}
