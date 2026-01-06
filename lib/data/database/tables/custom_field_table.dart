/// Custom field table definition.
library;

import 'package:drift/drift.dart';
import 'tenant_table.dart';

/// Table for storing custom key-value fields for tenants.
@DataClassName('CustomFieldEntity')
class CustomFields extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to tenant
  IntColumn get tenantId => integer().references(Tenants, #id)();

  /// Field name (e.g., "Bike Number", "WiFi Password")
  TextColumn get fieldName => text().withLength(min: 1, max: 50)();

  /// Field value
  TextColumn get fieldValue => text()();
}
