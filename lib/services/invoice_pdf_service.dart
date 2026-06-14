/// PDF generation service for invoices and receipts.
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../domain/entities/bill.dart';
import '../domain/entities/payment.dart';
import 'upi_qr_service.dart';
import 'image_service.dart';
import 'pdf/pdf_template.dart';

/// Helper to sanitize filenames
String _sanitizeFilename(String name) {
  return name
      .replaceAll(RegExp(r'[^\w\s\-]'), '')
      .replaceAll(RegExp(r'\s+'), '_');
}

/// Service for generating PDF invoices and receipts.
class InvoicePdfService {
  // ... existing methods

  /// Open PDF file in external viewer
  Future<void> openPdf(File file) async {
    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      throw Exception('Could not open file: ${result.message}');
    }
  }

  Future<void> previewPdf(Uint8List pdfBytes, String title) async {
    await Printing.layoutPdf(onLayout: (format) => pdfBytes, name: title);
  }

  /// Share PDF file
  Future<void> sharePdf(File pdf, String subject) async {
    await Printing.sharePdf(bytes: await pdf.readAsBytes(), filename: subject);
  }

  /// Generate invoice PDF for a bill.
  Future<File> generateInvoice({
    required Bill bill,
    required String landlordName,
    required String landlordPhone,
    String? landlordAddress,
    String? landlordUpiId,
    List<Payment> paymentHistory = const [],
    AppLocalizations? l10n,
  }) async {
    final pdf = pw.Document();

    // Load meter photo if available
    pw.MemoryImage? meterImage;
    if (bill.meterPhotoPath != null) {
      final absolutePath = ImageService.resolveImagePathSync(bill.meterPhotoPath!);
      final file = File(absolutePath);
      if (await file.exists()) {
        final imageBytes = await file.readAsBytes();
        meterImage = pw.MemoryImage(imageBytes);
      }
    }

    final logoBytes = await PdfTemplate.loadTransparentLogo();
    final theme = await PdfTemplate.loadTheme();

    Uint8List? qrBytes;
    if (landlordUpiId != null && landlordUpiId.isNotEmpty && bill.pendingAmount > 0) {
      qrBytes = await UpiQrService.generateQrImageBytes(
        upiId: landlordUpiId,
        payeeName: landlordName,
        amount: bill.pendingAmount,
        transactionNote: 'INV-${bill.id}',
        size: 150,
      );
    }

    final primaryColor = PdfTemplate.primaryColor;
    final accentColor = PdfTemplate.accentColor;
    final dividerColor = PdfTemplate.dividerColor;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (pw.Context context) {
          final content = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. MODERN HEADER
              PdfTemplate.buildModernHeader(
                title: l10n?.pdfInvoiceTitle ?? 'INVOICE',
                subtitle: '# INV-${bill.id.toString().padLeft(6, '0')}',
                landlordName: landlordName,
                landlordPhone: landlordPhone,
                landlordAddress: landlordAddress,
                logoBytes: logoBytes,
              ),
              
              pw.SizedBox(height: 40),

              // 2. HERO: BALANCE DUE
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      l10n?.pdfBalanceDue ?? 'Balance Due',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Rs. ${bill.pendingAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 48,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 40),

              // 3. CONTEXT GRID (FROM / TO / DATES)
              pw.Container(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // BILL TO
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            l10n?.pdfBillTo ?? 'BILL TO',
                            style: pw.TextStyle(
                              color: accentColor,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            bill.tenantName ?? (l10n?.unknownTenant ?? 'Unknown Tenant'),
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          if (bill.roomNumber != null)
                            pw.Text(
                              '${l10n?.pdfRoom ?? "Room"}: ${bill.roomNumber} | ${bill.propertyName ?? ""}',
                              style: const pw.TextStyle(
                                fontSize: 12,
                                color: PdfColors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // ISSUED
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            l10n?.pdfIssued ?? 'ISSUED',
                            style: pw.TextStyle(
                              color: accentColor,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            _formatDate(bill.createdAt),
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // DUE DATE
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            l10n?.pdfDueDate ?? 'DUE DATE',
                            style: pw.TextStyle(
                              color: accentColor,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            bill.dueDate != null
                                ? _formatDate(bill.dueDate!)
                                : '-',
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: bill.isOverdue
                                  ? PdfColors.red900
                                  : PdfColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // 4. CLEAN TABLE
              pw.Column(
                children: [
                  // Headers
                  pw.Container(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(color: dividerColor, width: 1),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            l10n?.pdfDescription ?? 'DESCRIPTION',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            l10n?.pdfPeriod ?? 'PERIOD',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            l10n?.pdfAmount ?? 'AMOUNT',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Line Items
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(color: dividerColor, width: 1),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                bill.billType.name.toUpperCase(),
                                style: const pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.black,
                                ),
                              ),
                              if (bill.billType == BillType.electricity &&
                                  bill.electricityPrevReading != null &&
                                  bill.electricityCurrReading != null)
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 4),
                                  child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        l10n?.invoiceReadings(bill.electricityPrevReading!.toStringAsFixed(0), bill.electricityCurrReading!.toStringAsFixed(0)) ?? 'Readings: ${bill.electricityPrevReading!.toStringAsFixed(0)} - ${bill.electricityCurrReading!.toStringAsFixed(0)}',
                                        style: const pw.TextStyle(
                                          fontSize: 10,
                                          color: PdfColors.grey700,
                                        ),
                                      ),
                                      pw.Text(
                                        l10n?.invoiceConsumption((bill.electricityCurrReading! - bill.electricityPrevReading!).toStringAsFixed(0), (bill.electricityRateAtBilling ?? 0).toString()) ?? 'Consumption: ${(bill.electricityCurrReading! - bill.electricityPrevReading!).toStringAsFixed(0)} units @ Rs. ${bill.electricityRateAtBilling ?? 0}',
                                        style: const pw.TextStyle(
                                          fontSize: 10,
                                          color: PdfColors.grey700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            bill.billingPeriod,
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Rs. ${bill.amount.toStringAsFixed(2)}',
                            textAlign: pw.TextAlign.right,
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 5. TOTALS
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      // Subtotal / Total Amount
                      _buildTotalRow(
                        l10n?.pdfTotalAmount ?? 'Total Amount',
                        'Rs. ${bill.amount.toStringAsFixed(2)}',
                      ),
                      if (bill.paidAmount > 0) ...[
                        pw.SizedBox(height: 4),
                        _buildTotalRow(
                          l10n?.pdfAmountPaid ?? 'Amount Paid',
                          '- Rs. ${bill.paidAmount.toStringAsFixed(2)}',
                          color: PdfColors.green700,
                        ),
                      ],
                    ],
                  ),
                ],
              ),



              // 7. PAYMENT HISTORY
              if (paymentHistory.isNotEmpty) ...[
                pw.SizedBox(height: 30),
                pw.Text(
                  l10n?.pdfPaymentHistory ?? 'PAYMENT HISTORY',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 1.0,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Table(
                  border: pw.TableBorder(
                    horizontalInside: pw.BorderSide(
                      color: dividerColor,
                      width: 0.5,
                    ),
                  ),
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(color: dividerColor),
                        ),
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Text(
                            l10n?.pdfDate ?? 'Date',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Text(
                            l10n?.pdfMode ?? 'Mode',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Text(
                            l10n?.pdfAmount ?? 'Amount',
                            textAlign: pw.TextAlign.right,
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...paymentHistory.map((payment) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Text(
                              _formatDate(payment.paymentDate),
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Text(
                              payment.paymentMode.name.toUpperCase(),
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Text(
                              'Rs. ${payment.amount.toStringAsFixed(2)}',
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],

              pw.Expanded(child: pw.Container()),

              // 8 & 9. PAYMENT DETAILS AND TERMS
              pw.SizedBox(height: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Payment Details Box
                  if (landlordUpiId != null && landlordUpiId.isNotEmpty) ...[
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(8),
                          border: pw.Border.all(color: dividerColor),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: double.infinity,
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey100,
                                borderRadius: const pw.BorderRadius.only(
                                  topLeft: pw.Radius.circular(7),
                                  topRight: pw.Radius.circular(7),
                                ),
                              ),
                              child: pw.Text(
                                l10n?.pdfPaymentDetails ?? 'PAYMENT DETAILS',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.grey800,
                                ),
                              ),
                            ),
                            pw.Divider(color: dividerColor, height: 1, thickness: 1),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(16),
                              child: pw.Row(
                                children: [
                                  if (qrBytes != null)
                                    pw.Stack(
                                      alignment: pw.Alignment.center,
                                      children: [
                                        pw.Image(
                                          pw.MemoryImage(qrBytes),
                                          width: 80,
                                          height: 80,
                                        ),
                                        pw.Container(
                                          width: 20,
                                          height: 20,
                                          decoration: pw.BoxDecoration(
                                            color: PdfColors.white,
                                            borderRadius: pw.BorderRadius.circular(4),
                                          ),
                                          child: pw.Center(
                                            child: pw.ClipRRect(
                                              horizontalRadius: 3,
                                              verticalRadius: 3,
                                              child: pw.Image(
                                                pw.MemoryImage(logoBytes),
                                                width: 16,
                                                height: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (qrBytes != null) pw.SizedBox(width: 20),
                                  pw.Expanded(
                                    child: pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          l10n?.pdfUpiId ?? 'UPI ID',
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                            fontWeight: pw.FontWeight.bold,
                                            color: accentColor,
                                          ),
                                        ),
                                        pw.SizedBox(height: 4),
                                        pw.Text(
                                          landlordUpiId,
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        pw.SizedBox(height: 4),
                                        pw.Text(
                                          l10n?.pdfScanToPay ?? 'Scan to Pay',
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 20),
                  ],
                  // Terms & Conditions
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            l10n?.pdfTermsAndConditions ?? 'TERMS & CONDITIONS',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey600,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            [
                              l10n?.pdfTerm1 ?? '1. Please pay the bill before the due date to avoid late fees.',
                              l10n?.pdfTerm2 ?? '2. This is a computer-generated invoice and no signature is required unless specified.',
                              if (landlordUpiId != null && landlordUpiId.isNotEmpty)
                                l10n?.invoiceUpiTerms ?? '3. Make payments via UPI to the details mentioned above.',
                            ].join('\n'),
                            style: pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey600,
                              lineSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              PdfTemplate.buildMarketingFooter(),
            ],
          );

          // Watermark Logic
          if (bill.status == BillStatus.voided) {
            return pw.Stack(
              children: [
                pw.Center(
                  child: pw.Transform.rotate(
                    angle: -0.5,
                    child: pw.Text(
                      l10n?.pdfVoid ?? 'VOID',
                      style: pw.TextStyle(
                        fontSize: 100,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red100,
                      ),
                    ),
                  ),
                ),
                content,
              ],
            );
          } else if (bill.status == BillStatus.paid) {
            return pw.Stack(
              children: [
                content,
                pw.Positioned(
                  bottom: 150,
                  right: 50,
                  child: pw.Transform.rotate(
                    angle: -0.2,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.green800,
                          width: 4,
                        ),
                        borderRadius: pw.BorderRadius.circular(10),
                      ),
                      child: pw.Text(
                        l10n?.pdfPaid ?? 'PAID',
                        style: pw.TextStyle(
                          fontSize: 50,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return content;
        },
      ),
    );

    // Add Attachment Page for Meter Photo
    if (meterImage != null) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 1,
                  child: pw.Text(
                    l10n?.invoiceAttachmentMeterProof ?? 'ATTACHMENT: METER READING PROOF',
                    style: pw.TextStyle(
                      color: accentColor,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  l10n?.invoiceReference(bill.id.toString().padLeft(6, '0')) ?? 'Invoice Reference: # INV-${bill.id.toString().padLeft(6, '0')}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Image(meterImage!, fit: pw.BoxFit.contain),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    // Generate smart filename: Invoice_Rent_Sep2023_JohnDoe.pdf
    final safePeriod = _sanitizeFilename(bill.billingPeriod);
    final safeTenant = _sanitizeFilename(bill.tenantName ?? 'Tenant');
    final safeType = _sanitizeFilename(
      bill.billType.name,
    ); // e.g., 'rent', 'electricity'

    // Capitalize first letter of bill type for nicer filename
    final niceType = safeType.isEmpty
        ? 'Bill'
        : '${safeType[0].toUpperCase()}${safeType.substring(1)}';

    final filename = 'Invoice_${niceType}_${safePeriod}_$safeTenant';

    return _savePdf(pdf, filename);
  }

  pw.Widget _buildTotalRow(
    String label,
    String value, {
    bool isBold = false,
    PdfColor? color,
    double fontSize = 12,
  }) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          '$label    ',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? pw.FontWeight.bold : null,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Generate receipt PDF for a payment.
  Future<File> generateReceipt({
    required Bill bill,
    required Payment payment,
    required String landlordName,
    required String landlordPhone,
    AppLocalizations? l10n,
  }) async {
    final pdf = pw.Document();

    final logoBytes = await PdfTemplate.loadTransparentLogo();
    final theme = await PdfTemplate.loadTheme();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. MODERN HEADER
              PdfTemplate.buildModernHeader(
                title: l10n?.pdfReceiptTitle ?? 'RECEIPT',
                subtitle: '# RCT-${payment.id.toString().padLeft(6, '0')}',
                landlordName: landlordName,
                landlordPhone: landlordPhone,
                logoBytes: logoBytes,
                isSmallPage: true,
              ),
              
              pw.SizedBox(height: 20),

              // 2. HERO: AMOUNT RECEIVED
              pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      l10n?.pdfAmountPaid ?? 'Amount Received',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Rs. ${payment.amount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 40,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green700,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    // SUCCESS BADGE
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.green50,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Text(
                        l10n?.pdfPaid ?? 'SUCCESS',
                        style: pw.TextStyle(
                          color: PdfColors.green900,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // 3. CONSOLIDATED DETAILS CARD
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
                    bottom: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
                  ),
                ),
                child: pw.Column(
                  children: [
                    // ROW 1: Tenant & Date
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(l10n?.pdfReceivedFrom ?? 'RECEIVED FROM', style: pw.TextStyle(color: PdfColors.grey500, fontSize: 8, fontWeight: pw.FontWeight.bold, letterSpacing: 1.0)),
                              pw.SizedBox(height: 4),
                              pw.Text(bill.tenantName ?? 'Tenant', style: pw.TextStyle(fontSize: 12)),
                              if (bill.roomNumber != null)
                                pw.Text('Room ${bill.roomNumber}', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(l10n?.pdfDate ?? 'DATE', style: pw.TextStyle(color: PdfColors.grey500, fontSize: 8, fontWeight: pw.FontWeight.bold, letterSpacing: 1.0)),
                              pw.SizedBox(height: 4),
                              pw.Text(_formatDate(payment.paymentDate), style: pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    // ROW 2: Payment For & Mode
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(l10n?.pdfDescription ?? 'PAYMENT FOR', style: pw.TextStyle(color: PdfColors.grey500, fontSize: 8, fontWeight: pw.FontWeight.bold, letterSpacing: 1.0)),
                              pw.SizedBox(height: 4),
                              pw.Text('${bill.billType.name.toUpperCase()} - ${bill.billingPeriod}', style: pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(l10n?.pdfMode ?? 'MODE', style: pw.TextStyle(color: PdfColors.grey500, fontSize: 8, fontWeight: pw.FontWeight.bold, letterSpacing: 1.0)),
                              pw.SizedBox(height: 4),
                              pw.Text(payment.paymentMode.name.toUpperCase(), style: pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (payment.notes != null && payment.notes!.isNotEmpty) ...[
                      pw.SizedBox(height: 16),
                      pw.Container(
                        width: double.infinity,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text((l10n?.notes ?? 'NOTES').toUpperCase(), style: pw.TextStyle(color: PdfColors.grey500, fontSize: 8, fontWeight: pw.FontWeight.bold, letterSpacing: 1.0)),
                            pw.SizedBox(height: 4),
                            pw.Text(payment.notes!, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              pw.SizedBox(height: 40),

              PdfTemplate.buildMarketingFooter(),
            ],
          );
        },
      ),
    );

    return _savePdf(pdf, 'receipt_${payment.id}');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<File> _savePdf(pw.Document pdf, String filename) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}
