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

  // ========== Identity Fields ==========

  /// Father's name (important for legal agreements)
  TextColumn get fatherName => text().nullable()();

  /// Age of the tenant
  IntColumn get age => integer().nullable()();

  /// Gender: 'male', 'female', 'other'
  TextColumn get gender => text().nullable()();

  // ========== Additional Contact ==========

  /// Secondary/emergency phone number
  TextColumn get secondaryPhone => text().nullable()();

  // ========== Permanent Address ==========

  /// Permanent address line
  TextColumn get permanentAddressLine => text().nullable()();

  /// City
  TextColumn get permanentCity => text().nullable()();

  /// State
  TextColumn get permanentState => text().nullable()();

  /// Pincode
  TextColumn get permanentPincode => text().nullable()();

  // ========== Work Details ==========

  /// Company name
  TextColumn get companyName => text().nullable()();

  /// Office address
  TextColumn get officeAddress => text().nullable()();

  // ========== ID Document Photos ==========

  /// Aadhaar card front photo path
  TextColumn get aadhaarFrontPhotoPath => text().nullable()();

  /// Aadhaar card back photo path
  TextColumn get aadhaarBackPhotoPath => text().nullable()();

  // ========== Introducer/Reference ==========

  /// Introducer's name (person who vouched for tenant)
  TextColumn get introducerName => text().nullable()();

  /// Introducer's address
  TextColumn get introducerAddress => text().nullable()();

  /// Introducer's phone number
  TextColumn get introducerPhone => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
