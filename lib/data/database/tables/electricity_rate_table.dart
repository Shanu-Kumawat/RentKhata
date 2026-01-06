/// Electricity rate history table definition.
library;

import 'package:drift/drift.dart';

/// Table for storing electricity rate changes over time.
@DataClassName('ElectricityRateEntity')
class ElectricityRates extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Rate per unit
  RealColumn get ratePerUnit => real()();

  /// When this rate became effective
  DateTimeColumn get effectiveFrom => dateTime()();
}
