/// Template service for managing default message templates.
library;

import '../domain/entities/message_template.dart';
import '../domain/repositories/billing_repository.dart';

/// Service to manage message templates including default creation.
class TemplateService {
  final BillingRepository _repository;

  TemplateService(this._repository);

  /// Default templates for each type.
  static const Map<TemplateType, Map<String, String>> _defaults = {
    TemplateType.invoice: {
      'name': 'Payment Request / Invoice',
      'body': '''Dear {tenant_name},

This is a gentle reminder regarding your {bill_type} payment.

📋 *BILL DETAILS*
Invoice #: {bill_number}
Period: {period}
Room: {room_number}

*Amount Due: ₹{amount}*
Due Date: {due_date}

Kindly make the payment at your earliest convenience. Let us know once the payment is done.

Thank you,
{landlord_name}''',
    },
    TemplateType.receipt: {
      'name': 'Payment Receipt',
      'body': '''Dear {tenant_name},

✅ *PAYMENT RECEIVED*

Thank you for your payment! Here are the details of your transaction:

*Payment Details:*
Amount Received: ₹{amount}
Date: {payment_date}
Payment Mode: {payment_mode}

*Bill Details:*
Type: {bill_type}
Period: {period}

We have successfully updated your ledger.

Thank you,
{landlord_name}''',
    },
  };

  /// Ensure default templates exist for all types.
  /// Call this on app startup.
  Future<void> ensureDefaultTemplatesExist() async {
    for (final type in TemplateType.values) {
      final templates = await _repository.getTemplatesByType(type);
      if (templates.isEmpty) {
        final defaults = _defaults[type]!;
        await _repository.createMessageTemplate(
          templateType: type,
          name: defaults['name']!,
          body: defaults['body']!,
          isDefault: true,
        );
      }
    }
  }

  /// Reset a template type to its default.
  Future<void> resetToDefault(TemplateType type) async {
    final defaults = _defaults[type]!;
    final templates = await _repository.getTemplatesByType(type);

    // Delete all existing templates for this type
    for (final template in templates) {
      await _repository.deleteMessageTemplate(template.id);
    }

    // Create fresh default
    await _repository.createMessageTemplate(
      templateType: type,
      name: defaults['name']!,
      body: defaults['body']!,
      isDefault: true,
    );
  }

  /// Get default template body for a type.
  static String getDefaultBody(TemplateType type) {
    return _defaults[type]!['body']!;
  }

  /// Substitute placeholders in a template body.
  static String substituteplaceholders(
    String template, {
    String? tenantName,
    String? landlordName,
    String? billType,
    String? period,
    String? amount,
    String? dueDate,
    String? billNumber,
    String? roomNumber,
    String? propertyName,
    String? paymentDate,
    String? paymentMode,
  }) {
    return template
        .replaceAll('{tenant_name}', tenantName ?? '')
        .replaceAll('{landlord_name}', landlordName ?? '')
        .replaceAll('{bill_type}', billType ?? '')
        .replaceAll('{period}', period ?? '')
        .replaceAll('{amount}', amount ?? '')
        .replaceAll('{due_date}', dueDate ?? '')
        .replaceAll('{bill_number}', billNumber ?? '')
        .replaceAll('{room_number}', roomNumber ?? '')
        .replaceAll('{property_name}', propertyName ?? '')
        .replaceAll('{payment_date}', paymentDate ?? '')
        .replaceAll('{payment_mode}', paymentMode ?? '');
  }
}
