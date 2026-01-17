/// Audit log domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

/// Types of entities that can be audited.
enum AuditEntityType { bill, payment, electricityRate }

/// Actions that can be logged.
enum AuditAction { create, update, delete, void_ }

/// Represents an audit log entry for tracking changes.
@freezed
class AuditLog with _$AuditLog {
  const factory AuditLog({
    required int id,
    required AuditEntityType entityType,
    required int entityId,
    required AuditAction action,
    String? fieldName,
    String? oldValue,
    String? newValue,
    String? notes,
    required DateTime createdAt,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}
