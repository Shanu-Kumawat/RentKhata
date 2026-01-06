/// Tenant table definition.
library;

import 'package:drift/drift.dart';

/// Table for storing tenant information.
/// This is a master table - tenants can be linked to multiple rooms over time.
@DataClassName('TenantEntity')
class Tenants extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Tenant's full name
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Phone number
  TextColumn get phone => text().nullable()();

  /// Aadhar number (12 digits)
  TextColumn get aadharNumber => text().nullable()();

  /// Profile photo path
  TextColumn get photoPath => text().nullable()();

  /// Whether police verification is complete
  BoolColumn get isPoliceVerified =>
      boolean().withDefault(const Constant(false))();

  /// Path to police verification document
  TextColumn get policeVerificationDocPath => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
