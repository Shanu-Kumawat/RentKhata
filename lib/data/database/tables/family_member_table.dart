/// Family member table definition.
library;

import 'package:drift/drift.dart';
import 'occupancy_table.dart';

/// Relationship types for family members
enum FamilyRelationship { spouse, child, parent, sibling, other }

/// Table for storing family members during a specific occupancy period.
/// This allows historical tracking of who lived in a room during each stay.
@DataClassName('FamilyMemberEntity')
class FamilyMembers extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to occupancy (links family to a specific stay period)
  IntColumn get occupancyId => integer().references(Occupancies, #id)();

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
