/// Meter photo table definition.
library;

import 'package:drift/drift.dart';
import 'bill_table.dart';

/// Table for storing electricity meter photos for bills.
@DataClassName('MeterPhotoEntity')
class MeterPhotos extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to bill
  IntColumn get billId => integer().references(Bills, #id)();

  /// Local file path to photo
  TextColumn get photoPath => text()();

  /// Photo order (1 or 2)
  IntColumn get photoOrder => integer().withDefault(const Constant(1))();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
