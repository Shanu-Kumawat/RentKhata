/// Payment table definition.
library;

import 'package:drift/drift.dart';
import 'bill_table.dart';

/// Payment modes enumeration
enum PaymentMode { cash, upi, bankTransfer, cheque, other }

/// Table for storing payments.
/// Multiple payments can be made against a single bill (partial payments).
@DataClassName('PaymentEntity')
class Payments extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to bill
  IntColumn get billId => integer().references(Bills, #id)();

  /// Payment amount
  RealColumn get amount => real()();

  /// Mode of payment
  TextColumn get paymentMode => textEnum<PaymentMode>()();

  /// Additional notes
  TextColumn get notes => text().nullable()();

  /// Payment date
  DateTimeColumn get paymentDate =>
      dateTime().withDefault(currentDateAndTime)();

  /// Created timestamp (for audit)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last updated timestamp (null if never edited)
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// Original amount before edit (for audit trail, JSON string)
  TextColumn get originalAmount => text().nullable()();
}
