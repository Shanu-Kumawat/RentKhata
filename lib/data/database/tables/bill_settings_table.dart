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

  /// Days after period start for due date (default: 10)
  IntColumn get dueDateOffsetDays =>
      integer().withDefault(const Constant(10))();

  /// Auto-generate reminders for overdue bills
  BoolColumn get autoReminders => boolean().withDefault(const Constant(true))();

  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
