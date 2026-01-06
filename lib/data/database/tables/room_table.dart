/// Room table definition.
library;

import 'package:drift/drift.dart';
import 'property_table.dart';

/// Table for storing room information.
@DataClassName('RoomEntity')
class Rooms extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to property
  IntColumn get propertyId => integer().references(Properties, #id)();

  /// Room number/name (e.g., "101", "Ground Floor Left")
  TextColumn get roomNumber => text().withLength(min: 1, max: 50)();

  /// Base rent amount
  RealColumn get baseRent => real().withDefault(const Constant(0.0))();

  /// Whether the room has an electricity meter
  BoolColumn get hasElectricityMeter =>
      boolean().withDefault(const Constant(false))();

  /// Current electricity rate for this room
  RealColumn get currentElectricityRate =>
      real().withDefault(const Constant(7.0))();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
