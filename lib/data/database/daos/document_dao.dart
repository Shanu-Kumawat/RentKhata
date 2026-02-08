/// Document DAO.
library;

import 'package:drift/drift.dart';
import '../app_database.dart' hide Document;
import '../tables/document_table.dart';
import '../../../domain/entities/document.dart';

part 'document_dao.g.dart';

/// Data Access Object for [Documents] table.
@DriftAccessor(tables: [Documents])
class DocumentDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentDaoMixin {
  DocumentDao(super.db);

  /// Get all documents for a tenant.
  Future<List<Document>> getDocumentsForTenant(int tenantId) {
    return (select(documents)
          ..where((t) => t.tenantId.equals(tenantId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Insert a new document.
  Future<int> insertDocument(DocumentsCompanion document) {
    return into(documents).insert(document);
  }

  /// Delete a document.
  Future<int> deleteDocument(int id) {
    return (delete(documents)..where((t) => t.id.equals(id))).go();
  }
}
