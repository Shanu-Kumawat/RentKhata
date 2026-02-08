/// Documents table definition.
library;

import 'package:drift/drift.dart';
import '../../../domain/entities/document.dart';
import 'tenant_table.dart';

/// Stores generic documents linked to tenants.
@UseRowClass(Document)
class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tenantId =>
      integer().references(Tenants, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get filePath => text()();
  TextColumn get fileType => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
