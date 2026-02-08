/// Document domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';
part 'document.g.dart';

/// Represents a generic document attached to a tenant.
@freezed
class Document with _$Document {
  const factory Document({
    required int id,
    required int tenantId,
    required String title,
    required String filePath,

    /// Type of file (e.g., 'pdf', 'image', 'other')
    String? fileType,
    required DateTime createdAt,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}
