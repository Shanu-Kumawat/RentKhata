/// Auto billing settings table definition.
library;

import 'package:drift/drift.dart';
import 'room_table.dart';

/// Table for storing auto-billing settings per room.
@DataClassName('AutoBillSettingEntity')
class AutoBillSettings extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to room
  IntColumn get roomId => integer().references(Rooms, #id)();

  /// Whether auto-billing is enabled
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();

  /// Generate rent bills automatically
  BoolColumn get generateRent => boolean().withDefault(const Constant(true))();

  /// Generate electricity bills automatically
  BoolColumn get generateElectricity =>
      boolean().withDefault(const Constant(false))();

  /// Day of month to generate bills (1-28)
  IntColumn get generationDay => integer().withDefault(const Constant(1))();

  /// Number of days after generation for due date
  IntColumn get dueDayOffset => integer().withDefault(const Constant(10))();

  /// Last date bills were generated
  DateTimeColumn get lastGeneratedAt => dateTime().nullable()();
}
