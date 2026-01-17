/// Message template domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_template.freezed.dart';
part 'message_template.g.dart';

/// Types of message templates.
enum TemplateType { invoice, receipt, reminder }

/// Represents a customizable message template.
@freezed
class MessageTemplate with _$MessageTemplate {
  const MessageTemplate._();

  const factory MessageTemplate({
    required int id,
    required TemplateType templateType,
    required String name,
    required String body,
    @Default(false) bool isDefault,
    required DateTime createdAt,
  }) = _MessageTemplate;

  factory MessageTemplate.fromJson(Map<String, dynamic> json) =>
      _$MessageTemplateFromJson(json);

  /// Apply template with placeholder values.
  /// Supported placeholders:
  /// {tenantName}, {landlordName}, {billType}, {period},
  /// {amount}, {dueDate}, {billNumber}, {roomNumber}, {propertyName},
  /// {paymentMode}
  String applyPlaceholders(Map<String, String> values) {
    String result = body;
    for (final entry in values.entries) {
      result = result.replaceAll('{${entry.key}}', entry.value);
    }
    return result;
  }
}
