/// Bill table definition.
library;

import 'package:drift/drift.dart';
import 'occupancy_table.dart';

/// Bill types enumeration.
/// Note: rentPlusElectricity was deprecated in v6 - use separate bills instead.
enum BillType { rent, electricity, water, maintenance, other }

/// Bill status for workflow tracking.
enum BillStatus {
  draft, // Just created, fully editable
  sent, // Invoice shared to tenant
  partial, // Has partial payments
  paid, // Fully paid
  overdue, // Past due date, not fully paid
  voided, // Cancelled/voided (renamed from void_ for Dart compatibility)
}

/// Table for storing bills.
@DataClassName('BillEntity')
class Bills extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to occupancy
  IntColumn get occupancyId => integer().references(Occupancies, #id)();

  /// Auto-generated bill number (format: INV-YYYYMM-XXXX)
  TextColumn get billNumber => text().nullable()();

  /// Bill status for workflow
  TextColumn get status =>
      textEnum<BillStatus>().withDefault(Constant(BillStatus.draft.name))();

  /// Type of bill
  TextColumn get billType => textEnum<BillType>()();

  /// Billing month (1-12)
  IntColumn get billingMonth => integer()();

  /// Billing year
  IntColumn get billingYear => integer()();

  /// Period start date (for pro-rating)
  DateTimeColumn get periodStartDate => dateTime().nullable()();

  /// Period end date (for pro-rating)
  DateTimeColumn get periodEndDate => dateTime().nullable()();

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
