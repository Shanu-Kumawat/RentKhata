/// Deposit transaction table definition.
library;

import 'package:drift/drift.dart';
import 'occupancy_table.dart';

/// Deposit transaction types
enum DepositTransactionType { received, deduction, returned }

/// Table for tracking security deposit transactions.
@DataClassName('DepositTransactionEntity')
class DepositTransactions extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to occupancy
  IntColumn get occupancyId => integer().references(Occupancies, #id)();

  /// Type of transaction
  TextColumn get transactionType => textEnum<DepositTransactionType>()();

  /// Transaction amount
  RealColumn get amount => real()();

  /// Transaction date
  DateTimeColumn get transactionDate => dateTime()();

  /// Notes/reason for transaction
  TextColumn get notes => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
