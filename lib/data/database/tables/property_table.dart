/// Property table definition.
library;

import 'package:drift/drift.dart';

/// Table for storing property information.
@DataClassName('PropertyEntity')
class Properties extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Property name (e.g., "Sunrise Apartments")
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Full address
  TextColumn get address => text().nullable()();

  /// Photo path for property image
  TextColumn get photoPath => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Archived status
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}
