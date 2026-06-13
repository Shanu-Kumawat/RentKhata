/// Share service for WhatsApp and other sharing.
library;

import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../domain/entities/bill.dart';
import '../domain/entities/payment.dart';
import '../domain/entities/message_template.dart';
import '../domain/repositories/billing_repository.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import 'upi_qr_service.dart';
import 'template_service.dart';

/// Service for sharing content via WhatsApp and other apps.
class ShareService {
  final BillingRepository? _repository;

  ShareService([this._repository]);

  /// Share files with optional text.
  Future<void> shareFiles({
    required List<File> files,
    String? text,
    String? subject,
  }) async {
    final xFiles = files.map((f) => XFile(f.path)).toList();
    await Share.shareXFiles(xFiles, text: text, subject: subject);
  }

  /// Share a generated PDF Statement.
  Future<void> sharePdfStatement(File pdfFile, {String? tenantName, AppLocalizations? l10n}) async {
    final name = tenantName ?? 'Tenant';
    await shareFiles(
      files: [pdfFile],
      text: l10n?.shareStatementBody(name) ?? 'Dear $name,\n\nPlease find your generated Khata Statement attached.',
      subject: l10n?.shareStatementSubject ?? 'Khata Statement',
    );
  }

  /// Share a generated PDF Settlement Receipt.
  Future<void> shareSettlementPdf(File pdfFile, {String? tenantName, AppLocalizations? l10n}) async {
    final name = tenantName ?? 'Tenant';
    await shareFiles(
      files: [pdfFile],
      text: l10n?.shareSettlementBody(name) ?? 'Dear $name,\n\nYour Move-Out Settlement is complete. Please find the detailed Settlement Receipt attached.',
      subject: l10n?.shareSettlementSubject ?? 'Move-Out Settlement Receipt',
    );
  }

  /// Share text only.
  Future<void> shareText({required String text, String? subject}) async {
    await Share.share(text, subject: subject);
  }

  /// Share invoice using native share dialog.
  /// Uses template from database if repository is available.
  Future<void> shareInvoice({
    required Bill bill,
    required String landlordName,
    String? landlordUpi,
    AppLocalizations? l10n,
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

    // If meter photo exists, share it with text using native share
    if (bill.meterPhotoPath != null && bill.meterPhotoPath!.isNotEmpty) {
      final file = File(bill.meterPhotoPath!);
      if (await file.exists()) {
        await shareFiles(
          files: [file],
          text: message,
          subject: l10n?.shareInvoiceSubject(bill.billNumber ?? bill.billingPeriod) ?? 'Invoice - ${bill.billNumber ?? bill.billingPeriod}',
        );
        return;
      }
    }

    await Share.share(
      message,
      subject: l10n?.shareInvoiceSubject(bill.billNumber ?? bill.billingPeriod) ?? 'Invoice - ${bill.billNumber ?? bill.billingPeriod}',
    );
  }

  /// Share payment receipt using native share dialog.
  Future<void> shareReceipt({
    required Bill bill,
    required Payment payment,
    required String landlordName,
    AppLocalizations? l10n,
  }) async {
    String message;

    if (_repository != null) {
      final template = await _repository.getDefaultTemplate(
        TemplateType.receipt,
      );
      if (template != null) {
        message = _substituteReceiptPlaceholders(
          template.body,
          bill: bill,
          payment: payment,
          landlordName: landlordName,
        );
      } else {
        message = _substituteReceiptPlaceholders(
          TemplateService.getDefaultBody(TemplateType.receipt),
          bill: bill,
          payment: payment,
          landlordName: landlordName,
        );
      }
    } else {
      message = generateReceiptMessage(
        bill: bill,
        payment: payment,
        landlordName: landlordName,
      );
    }

    await Share.share(
      message,
      subject: l10n?.shareReceiptSubject(bill.billNumber ?? bill.billingPeriod) ?? 'Payment Receipt - ${bill.billNumber ?? bill.billingPeriod}',
    );
  }

  /// Generate invoice message from bill.
  static String generateInvoiceMessage({
    required Bill bill,
    required String landlordName,
    String? landlordUpi,
    AppLocalizations? l10n,
  }) {
    final tenantName = bill.tenantName ?? 'Tenant';
    final dueDate = bill.dueDate;
    final dueDateStr = dueDate != null
        ? '${dueDate.day}/${dueDate.month}/${dueDate.year}'
        : 'N/A';

    final billTypeLabel = _getBillTypeLabel(bill.billType);

    final buffer = StringBuffer();
    buffer.writeln(l10n?.shareDear(tenantName) ?? 'Dear $tenantName,');
    buffer.writeln();
    buffer.writeln(l10n?.shareInvoiceHeader ?? '📋 *INVOICE*');
    if (bill.billNumber != null) {
      buffer.writeln(l10n?.shareInvoiceNumber(bill.billNumber!) ?? 'Invoice #: ${bill.billNumber}');
    }
    buffer.writeln();
    buffer.writeln(l10n?.shareBillDetails ?? '*Bill Details:*');
    buffer.writeln(l10n?.shareType(billTypeLabel) ?? 'Type: $billTypeLabel');
    buffer.writeln(l10n?.sharePeriod(bill.billingPeriod) ?? 'Period: ${bill.billingPeriod}');
    if (bill.roomNumber != null) {
      buffer.writeln(l10n?.shareRoom(bill.roomNumber!) ?? 'Room: ${bill.roomNumber}');
    }
    buffer.writeln();

    // Electricity details
    if (bill.billType == BillType.electricity &&
        bill.electricityPrevReading != null &&
        bill.electricityCurrReading != null) {
      final units = bill.electricityCurrReading! - bill.electricityPrevReading!;
      buffer.writeln(l10n?.shareMeterReadings ?? '*Meter Readings:*');
      buffer.writeln(
        l10n?.sharePrevious(bill.electricityPrevReading!.toStringAsFixed(0)) ?? 'Previous: ${bill.electricityPrevReading!.toStringAsFixed(0)} units',
      );
      buffer.writeln(
        l10n?.shareCurrent(bill.electricityCurrReading!.toStringAsFixed(0)) ?? 'Current: ${bill.electricityCurrReading!.toStringAsFixed(0)} units',
      );
      buffer.writeln(l10n?.shareUnitsUsed(units.toStringAsFixed(0)) ?? 'Units Used: ${units.toStringAsFixed(0)} units');
      if (bill.electricityRateAtBilling != null) {
        buffer.writeln(
          l10n?.shareRate(bill.electricityRateAtBilling!.toStringAsFixed(2)) ?? 'Rate: ₹${bill.electricityRateAtBilling!.toStringAsFixed(2)}/unit',
        );
      }
      buffer.writeln();
    }

    buffer.writeln(l10n?.shareAmountHeader ?? '*Amount:*');
    buffer.writeln(l10n?.shareTotal(bill.amount.toStringAsFixed(0)) ?? 'Total: ₹${bill.amount.toStringAsFixed(0)}');
    if (bill.paidAmount > 0) {
      buffer.writeln(l10n?.sharePaid(bill.paidAmount.toStringAsFixed(0)) ?? 'Paid: ₹${bill.paidAmount.toStringAsFixed(0)}');
      buffer.writeln(l10n?.sharePending(bill.pendingAmount.toStringAsFixed(0)) ?? '*Pending: ₹${bill.pendingAmount.toStringAsFixed(0)}*');
    }
    buffer.writeln(l10n?.shareDueDate(dueDateStr) ?? 'Due Date: $dueDateStr');
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
      buffer.writeln(l10n?.sharePayViaUpi ?? '📱 *Pay via UPI:*');
      buffer.writeln(upiLink);
      buffer.writeln();
    }

    buffer.writeln(l10n?.shareThankYou ?? 'Thank you,');
    buffer.writeln(landlordName);

    return buffer.toString().trim();
  }

  /// Generate receipt message from payment.
  static String generateReceiptMessage({
    required Bill bill,
    required Payment payment,
    required String landlordName,
    AppLocalizations? l10n,
  }) {
    final tenantName = bill.tenantName ?? 'Tenant';
    final paymentDateStr =
        '${payment.paymentDate.day}/${payment.paymentDate.month}/${payment.paymentDate.year}';
    final billTypeLabel = _getBillTypeLabel(bill.billType);

    final buffer = StringBuffer();
    buffer.writeln(l10n?.shareDear(tenantName) ?? 'Dear $tenantName,');
    buffer.writeln();
    buffer.writeln(l10n?.sharePaymentReceived ?? '✅ *PAYMENT RECEIVED*');
    buffer.writeln();
    buffer.writeln(l10n?.sharePaymentDetails ?? '*Payment Details:*');
    buffer.writeln(l10n?.shareAmount(payment.amount.toStringAsFixed(0)) ?? 'Amount: ₹${payment.amount.toStringAsFixed(0)}');
    buffer.writeln(l10n?.shareMode(_getPaymentModeLabel(payment.paymentMode)) ?? 'Mode: ${_getPaymentModeLabel(payment.paymentMode)}');
    buffer.writeln(l10n?.shareDate(paymentDateStr) ?? 'Date: $paymentDateStr');
    buffer.writeln();
    buffer.writeln(l10n?.shareBillDetails ?? '*Bill Details:*');
    buffer.writeln(l10n?.shareType(billTypeLabel) ?? 'Type: $billTypeLabel');
    buffer.writeln(l10n?.sharePeriod(bill.billingPeriod) ?? 'Period: ${bill.billingPeriod}');
    if (bill.billNumber != null) {
      buffer.writeln(l10n?.shareInvoiceNumber(bill.billNumber!) ?? 'Invoice #: ${bill.billNumber}');
    }
    buffer.writeln();
    buffer.writeln(l10n?.shareBillStatus ?? '*Bill Status:*');
    buffer.writeln(l10n?.shareTotalBill(bill.amount.toStringAsFixed(0)) ?? 'Total Bill: ₹${bill.amount.toStringAsFixed(0)}');
    buffer.writeln(l10n?.shareTotalPaid(bill.paidAmount.toStringAsFixed(0)) ?? 'Total Paid: ₹${bill.paidAmount.toStringAsFixed(0)}');
    if (bill.pendingAmount > 0) {
      buffer.writeln(l10n?.shareRemaining(bill.pendingAmount.toStringAsFixed(0)) ?? '*Remaining: ₹${bill.pendingAmount.toStringAsFixed(0)}*');
    } else {
      buffer.writeln(l10n?.shareStatusFullyPaid ?? '*Status: FULLY PAID ✅*');
    }
    buffer.writeln();
    buffer.writeln(l10n?.shareThankYouPayment ?? 'Thank you for your payment!');
    buffer.writeln(landlordName);

    return buffer.toString().trim();
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

  /// Substitute placeholders in receipt template.
  String _substituteReceiptPlaceholders(
    String template, {
    required Bill bill,
    required Payment payment,
    required String landlordName,
  }) {
    final paymentDateStr =
        '${payment.paymentDate.day}/${payment.paymentDate.month}/${payment.paymentDate.year}';
        
    return template
        .replaceAll('{tenant_name}', bill.tenantName ?? 'Tenant')
        .replaceAll('{tenantName}', bill.tenantName ?? 'Tenant')
        .replaceAll('{landlord_name}', landlordName)
        .replaceAll('{landlordName}', landlordName)
        .replaceAll('{bill_type}', _getBillTypeLabel(bill.billType))
        .replaceAll('{billType}', _getBillTypeLabel(bill.billType))
        .replaceAll('{period}', bill.billingPeriod)
        .replaceAll('{amount}', payment.amount.toStringAsFixed(0))
        .replaceAll('{bill_number}', bill.billNumber ?? '')
        .replaceAll('{billNumber}', bill.billNumber ?? '')
        .replaceAll('{payment_date}', paymentDateStr)
        .replaceAll('{payment_mode}', _getPaymentModeLabel(payment.paymentMode));
  }
}
