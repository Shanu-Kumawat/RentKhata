/// Landlord profile table definition.
library;

import 'package:drift/drift.dart';

/// Table for storing landlord profile information.
@DataClassName('LandlordEntity')
class Landlords extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Landlord's name
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// UPI ID for receiving payments
  TextColumn get upiId => text().nullable()();

  /// Phone number
  TextColumn get phone => text().nullable()();

  /// Profile photo path
  TextColumn get photoPath => text().nullable()();

  /// Signature image path
  TextColumn get signaturePath => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
