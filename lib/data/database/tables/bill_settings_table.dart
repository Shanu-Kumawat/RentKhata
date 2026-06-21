/// Bill settings table definition for configurable billing options.
library;

import 'package:drift/drift.dart';

/// Table for storing global bill settings.
/// This is a singleton table (only one row expected).
@DataClassName('BillSettingsEntity')
class BillSettings extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Bill number prefix (default: INV)
  TextColumn get billNumberPrefix =>
      text().withDefault(const Constant('INV'))();

  /// Days after period end for due date (default: 5)
  IntColumn get dueDateOffsetDays => integer().withDefault(const Constant(5))();

  /// Days before due date to show "due soon" alert (default: 5)
  IntColumn get dueSoonThresholdDays =>
      integer().withDefault(const Constant(5))();

  /// Auto-generate reminders for overdue bills
  BoolColumn get autoReminders => boolean().withDefault(const Constant(true))();

  // ========== Date-to-Date Billing Per Bill Type ==========

  /// Whether rent bills use date-to-date cycles (default: true)
  BoolColumn get rentUsesDateToDate =>
      boolean().withDefault(const Constant(true))();

  /// Whether electricity bills use date-to-date cycles (default: true)
  BoolColumn get electricityUsesDateToDate =>
      boolean().withDefault(const Constant(true))();

  /// Whether water bills use date-to-date cycles (default: true)
  BoolColumn get waterUsesDateToDate =>
      boolean().withDefault(const Constant(true))();

  /// Whether maintenance bills use date-to-date cycles (default: false)
  BoolColumn get maintenanceUsesDateToDate =>
      boolean().withDefault(const Constant(false))();

  /// Whether other bills use date-to-date cycles (default: false)
  BoolColumn get otherUsesDateToDate =>
      boolean().withDefault(const Constant(false))();

  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
