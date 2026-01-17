/// Audit log table definition for tracking all billing/payment changes.
library;

import 'package:drift/drift.dart';

/// Entity types that can be audited.
enum AuditEntityType { bill, payment, electricityRate }

/// Actions that can be audited.
enum AuditAction { create, update, delete, void_ }

/// Table for storing comprehensive audit logs.
@DataClassName('AuditLogEntity')
class AuditLogs extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Type of entity audited
  TextColumn get entityType => textEnum<AuditEntityType>()();

  /// ID of the entity
  IntColumn get entityId => integer()();

  /// Action performed
  TextColumn get action => textEnum<AuditAction>()();

  /// Field that changed (null for create/delete)
  TextColumn get fieldName => text().nullable()();

  /// Previous value (JSON stringified)
  TextColumn get oldValue => text().nullable()();

  /// New value (JSON stringified)
  TextColumn get newValue => text().nullable()();

  /// Additional context/notes
  TextColumn get notes => text().nullable()();

  /// Timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
