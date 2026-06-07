/// Message template table definition for customizable invoice/receipt messages.
library;

import 'package:drift/drift.dart';

/// Types of message templates.
enum TemplateType { invoice, receipt }

/// Table for storing customizable message templates.
@DataClassName('MessageTemplateEntity')
class MessageTemplates extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Template type
  TextColumn get templateType => textEnum<TemplateType>()();

  /// Template name (user-defined)
  TextColumn get name => text()();

  /// Template body with placeholders
  /// Supported placeholders:
  /// {tenantName}, {landlordName}, {billType}, {period},
  /// {amount}, {dueDate}, {billNumber}, {roomNumber}, {propertyName}
  TextColumn get body => text()();

  /// Is this the default template?
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
