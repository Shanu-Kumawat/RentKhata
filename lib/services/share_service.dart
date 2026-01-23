/// Share service for WhatsApp and other sharing.
library;

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../domain/entities/bill.dart';
import '../domain/entities/payment.dart';
import '../domain/entities/message_template.dart';
import '../domain/repositories/billing_repository.dart';
import 'upi_qr_service.dart';
import 'template_service.dart';

/// Service for sharing content via WhatsApp and other apps.
class ShareService {
  final BillingRepository? _repository;

  ShareService([this._repository]);

  /// Share text message to WhatsApp.
  /// If [phoneNumber] is provided, opens chat with that number.
  /// Otherwise opens WhatsApp to let user select a contact.
  Future<bool> shareToWhatsApp({
    required String message,
    String? phoneNumber,
  }) async {
    // Format phone number (remove spaces, ensure country code)
    String? formattedPhone;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      formattedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      // Add India country code if not present
      if (!formattedPhone.startsWith('+')) {
        if (formattedPhone.startsWith('0')) {
          formattedPhone = '+91${formattedPhone.substring(1)}';
        } else if (formattedPhone.length == 10) {
          formattedPhone = '+91$formattedPhone';
        }
      }
    }

    // Encode message for URL
    final encodedMessage = Uri.encodeComponent(message);

    // Build WhatsApp URL
    Uri uri;
    if (formattedPhone != null) {
      uri = Uri.parse(
        'whatsapp://send?phone=$formattedPhone&text=$encodedMessage',
      );
    } else {
      uri = Uri.parse('whatsapp://send?text=$encodedMessage');
    }

    // Try to launch WhatsApp
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Share files with optional text.
  Future<void> shareFiles({
    required List<File> files,
    String? text,
    String? subject,
  }) async {
    final xFiles = files.map((f) => XFile(f.path)).toList();
    await Share.shareXFiles(xFiles, text: text, subject: subject);
  }

  /// Share text only.
  Future<void> shareText({required String text, String? subject}) async {
    await Share.share(text, subject: subject);
  }

  /// Share invoice to WhatsApp with optional UPI link.
  Future<bool> shareInvoiceToWhatsApp({
    required Bill bill,
    required String landlordName,
    String? landlordUpi,
    String? tenantPhone,
  }) async {
    final message = generateInvoiceMessage(
      bill: bill,
      landlordName: landlordName,
      landlordUpi: landlordUpi,
    );

    return shareToWhatsApp(message: message, phoneNumber: tenantPhone);
  }

  /// Share invoice using native share dialog.
  /// Uses template from database if repository is available.
  Future<void> shareInvoice({
    required Bill bill,
    required String landlordName,
    String? landlordUpi,
  }) async {
    String message;

    if (_repository != null) {
      // Use template from database
      final template = await _repository.getDefaultTemplate(
        TemplateType.invoice,
      );
      if (template != null) {
        message = _substituteInvoicePlaceholders(
          template.body,
          bill: bill,
          landlordName: landlordName,
          landlordUpi: landlordUpi,
        );
      } else {
        // Fallback to default template
        message = _substituteInvoicePlaceholders(
          TemplateService.getDefaultBody(TemplateType.invoice),
          bill: bill,
          landlordName: landlordName,
          landlordUpi: landlordUpi,
        );
      }
    } else {
      // Legacy: use static method
      message = generateInvoiceMessage(
        bill: bill,
        landlordName: landlordName,
        landlordUpi: landlordUpi,
      );
    }

    await Share.share(
      message,
      subject: 'Invoice - ${bill.billNumber ?? bill.billingPeriod}',
    );
  }

  /// Share payment receipt to WhatsApp.
  Future<bool> shareReceiptToWhatsApp({
    required Bill bill,
    required Payment payment,
    required String landlordName,
    String? tenantPhone,
  }) async {
    final message = generateReceiptMessage(
      bill: bill,
      payment: payment,
      landlordName: landlordName,
    );

    return shareToWhatsApp(message: message, phoneNumber: tenantPhone);
  }

  /// Share payment receipt using native share dialog.
  Future<void> shareReceipt({
    required Bill bill,
    required Payment payment,
    required String landlordName,
  }) async {
    final message = generateReceiptMessage(
      bill: bill,
      payment: payment,
      landlordName: landlordName,
    );

    await Share.share(
      message,
      subject: 'Payment Receipt - ${bill.billNumber ?? bill.billingPeriod}',
    );
  }

  /// Generate invoice message from bill.
  static String generateInvoiceMessage({
    required Bill bill,
    required String landlordName,
    String? landlordUpi,
  }) {
    final tenantName = bill.tenantName ?? 'Tenant';
    final dueDate = bill.dueDate;
    final dueDateStr = dueDate != null
        ? '${dueDate.day}/${dueDate.month}/${dueDate.year}'
        : 'N/A';

    final billTypeLabel = _getBillTypeLabel(bill.billType);

    final buffer = StringBuffer();
    buffer.writeln('Dear $tenantName,');
    buffer.writeln();
    buffer.writeln('📋 *INVOICE*');
    if (bill.billNumber != null) {
      buffer.writeln('Invoice #: ${bill.billNumber}');
    }
    buffer.writeln();
    buffer.writeln('*Bill Details:*');
    buffer.writeln('Type: $billTypeLabel');
    buffer.writeln('Period: ${bill.billingPeriod}');
    if (bill.roomNumber != null) {
      buffer.writeln('Room: ${bill.roomNumber}');
    }
    buffer.writeln();

    // Electricity details
    if (bill.billType == BillType.electricity &&
        bill.electricityPrevReading != null &&
        bill.electricityCurrReading != null) {
      final units = bill.electricityCurrReading! - bill.electricityPrevReading!;
      buffer.writeln('*Meter Readings:*');
      buffer.writeln(
        'Previous: ${bill.electricityPrevReading!.toStringAsFixed(0)} units',
      );
      buffer.writeln(
        'Current: ${bill.electricityCurrReading!.toStringAsFixed(0)} units',
      );
      buffer.writeln('Units Used: ${units.toStringAsFixed(0)} units');
      if (bill.electricityRateAtBilling != null) {
        buffer.writeln(
          'Rate: ₹${bill.electricityRateAtBilling!.toStringAsFixed(2)}/unit',
        );
      }
      buffer.writeln();
    }

    buffer.writeln('*Amount:*');
    buffer.writeln('Total: ₹${bill.amount.toStringAsFixed(0)}');
    if (bill.paidAmount > 0) {
      buffer.writeln('Paid: ₹${bill.paidAmount.toStringAsFixed(0)}');
      buffer.writeln('*Pending: ₹${bill.pendingAmount.toStringAsFixed(0)}*');
    }
    buffer.writeln('Due Date: $dueDateStr');
    buffer.writeln();

    // UPI payment link
    if (landlordUpi != null &&
        landlordUpi.isNotEmpty &&
        bill.pendingAmount > 0) {
      final upiLink = UpiQrService.generateUpiLink(
        upiId: landlordUpi,
        payeeName: landlordName,
        amount: bill.pendingAmount,
        transactionNote: '${bill.billType.name} - ${bill.billingPeriod}',
      );
      buffer.writeln('📱 *Pay via UPI:*');
      buffer.writeln(upiLink);
      buffer.writeln();
    }

    buffer.writeln('Thank you,');
    buffer.writeln(landlordName);

    return buffer.toString().trim();
  }

  /// Generate receipt message from payment.
  static String generateReceiptMessage({
    required Bill bill,
    required Payment payment,
    required String landlordName,
  }) {
    final tenantName = bill.tenantName ?? 'Tenant';
    final paymentDateStr =
        '${payment.paymentDate.day}/${payment.paymentDate.month}/${payment.paymentDate.year}';
    final billTypeLabel = _getBillTypeLabel(bill.billType);

    final buffer = StringBuffer();
    buffer.writeln('Dear $tenantName,');
    buffer.writeln();
    buffer.writeln('✅ *PAYMENT RECEIVED*');
    buffer.writeln();
    buffer.writeln('*Payment Details:*');
    buffer.writeln('Amount: ₹${payment.amount.toStringAsFixed(0)}');
    buffer.writeln('Mode: ${_getPaymentModeLabel(payment.paymentMode)}');
    buffer.writeln('Date: $paymentDateStr');
    buffer.writeln();
    buffer.writeln('*Bill Details:*');
    buffer.writeln('Type: $billTypeLabel');
    buffer.writeln('Period: ${bill.billingPeriod}');
    if (bill.billNumber != null) {
      buffer.writeln('Invoice #: ${bill.billNumber}');
    }
    buffer.writeln();
    buffer.writeln('*Bill Status:*');
    buffer.writeln('Total Bill: ₹${bill.amount.toStringAsFixed(0)}');
    buffer.writeln('Total Paid: ₹${bill.paidAmount.toStringAsFixed(0)}');
    if (bill.pendingAmount > 0) {
      buffer.writeln('*Remaining: ₹${bill.pendingAmount.toStringAsFixed(0)}*');
    } else {
      buffer.writeln('*Status: FULLY PAID ✅*');
    }
    buffer.writeln();
    buffer.writeln('Thank you for your payment!');
    buffer.writeln(landlordName);

    return buffer.toString().trim();
  }

  /// Generate bill reminder message.
  static String billReminderMessage({
    required String tenantName,
    required String billType,
    required String period,
    required double amount,
    required DateTime dueDate,
    required String landlordName,
  }) {
    final dueDateStr = '${dueDate.day}/${dueDate.month}/${dueDate.year}';
    return '''
Dear $tenantName,

This is a reminder for your $billType bill for $period.

Amount Due: ₹${amount.toStringAsFixed(0)}
Due Date: $dueDateStr

Please make the payment at your earliest convenience.

Thank you,
$landlordName
'''
        .trim();
  }

  /// Generate payment receipt message (legacy method).
  static String paymentReceiptMessage({
    required String tenantName,
    required String billType,
    required String period,
    required double amount,
    required String paymentMode,
    required DateTime paymentDate,
    required String landlordName,
  }) {
    final dateStr =
        '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}';
    return '''
Dear $tenantName,

Payment Received!

Bill: $billType - $period
Amount: ₹${amount.toStringAsFixed(0)}
Mode: $paymentMode
Date: $dateStr

Thank you for your payment.

$landlordName
'''
        .trim();
  }

  static String _getBillTypeLabel(BillType type) {
    return switch (type) {
      BillType.rent => 'Monthly Rent',
      BillType.electricity => 'Electricity Bill',
      BillType.water => 'Water Bill',
      BillType.maintenance => 'Maintenance',
      BillType.other => 'Other Charges',
    };
  }

  static String _getPaymentModeLabel(PaymentMode mode) {
    return switch (mode) {
      PaymentMode.cash => 'Cash',
      PaymentMode.upi => 'UPI',
      PaymentMode.bankTransfer => 'Bank Transfer',
      PaymentMode.cheque => 'Cheque',
      PaymentMode.other => 'Other',
    };
  }

  /// Substitute placeholders in invoice template.
  String _substituteInvoicePlaceholders(
    String template, {
    required Bill bill,
    required String landlordName,
    String? landlordUpi,
  }) {
    final dueDate = bill.dueDate;
    final dueDateStr = dueDate != null
        ? '${dueDate.day}/${dueDate.month}/${dueDate.year}'
        : 'N/A';

    var result = template
        .replaceAll('{tenant_name}', bill.tenantName ?? 'Tenant')
        .replaceAll('{tenantName}', bill.tenantName ?? 'Tenant')
        .replaceAll('{landlord_name}', landlordName)
        .replaceAll('{landlordName}', landlordName)
        .replaceAll('{bill_type}', _getBillTypeLabel(bill.billType))
        .replaceAll('{billType}', _getBillTypeLabel(bill.billType))
        .replaceAll('{period}', bill.billingPeriod)
        .replaceAll('{amount}', bill.pendingAmount.toStringAsFixed(0))
        .replaceAll('{due_date}', dueDateStr)
        .replaceAll('{dueDate}', dueDateStr)
        .replaceAll('{bill_number}', bill.billNumber ?? '')
        .replaceAll('{billNumber}', bill.billNumber ?? '')
        .replaceAll('{room_number}', bill.roomNumber ?? '')
        .replaceAll('{roomNumber}', bill.roomNumber ?? '')
        .replaceAll('{property_name}', bill.propertyName ?? '')
        .replaceAll('{propertyName}', bill.propertyName ?? '');

    // Add UPI link if available
    if (landlordUpi != null &&
        landlordUpi.isNotEmpty &&
        bill.pendingAmount > 0) {
      final upiLink = UpiQrService.generateUpiLink(
        upiId: landlordUpi,
        payeeName: landlordName,
        amount: bill.pendingAmount,
        transactionNote: '${bill.billType.name} - ${bill.billingPeriod}',
      );
      result += '\n\n💳 *Pay Now:*\n$upiLink';
    }

    return result;
  }
}
