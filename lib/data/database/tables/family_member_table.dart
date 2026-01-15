/// Family member table definition.
library;

import 'package:drift/drift.dart';
import 'tenant_table.dart';

/// Relationship types for family members
enum FamilyRelationship { spouse, child, parent, sibling, other }

/// Table for storing tenant family members.
@DataClassName('FamilyMemberEntity')
class FamilyMembers extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to tenant
  IntColumn get tenantId => integer().references(Tenants, #id)();

  /// Family member's name
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Relationship to tenant
  TextColumn get relationship => textEnum<FamilyRelationship>()();

  /// Phone number (optional)
  TextColumn get phone => text().nullable()();

  /// Aadhar number (optional)
  TextColumn get aadharNumber => text().nullable()();

  /// Age of the family member
  IntColumn get age => integer().nullable()();

  /// Gender: 'male', 'female', 'other'
  TextColumn get gender => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
