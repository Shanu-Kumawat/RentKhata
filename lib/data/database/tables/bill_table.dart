/// Bill table definition.
library;

import 'package:drift/drift.dart';
import 'occupancy_table.dart';

/// Bill types enumeration
enum BillType {
  rent,
  electricity,
  water,
  maintenance,
  other,
}

/// Table for storing bills.
@DataClassName('BillEntity')
class Bills extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to occupancy
  IntColumn get occupancyId => integer().references(Occupancies, #id)();

  /// Type of bill
  TextColumn get billType => textEnum<BillType>()();

  /// Billing month (1-12)
  IntColumn get billingMonth => integer()();

  /// Billing year
  IntColumn get billingYear => integer()();

  /// Total bill amount
  RealColumn get amount => real()();

  /// Previous electricity meter reading
  RealColumn get electricityPrevReading => real().nullable()();

  /// Current electricity meter reading
  RealColumn get electricityCurrReading => real().nullable()();

  /// Electricity rate at time of billing (frozen)
  RealColumn get electricityRateAtBilling => real().nullable()();

  /// Calculated electricity charges
  RealColumn get electricityCharges => real().nullable()();

  /// Photo of the electricity meter reading
  TextColumn get meterPhotoPath => text().nullable()();

  /// Additional notes
  TextColumn get notes => text().nullable()();

  /// Bill creation date
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Due date for payment
  DateTimeColumn get dueDate => dateTime().nullable()();
}
