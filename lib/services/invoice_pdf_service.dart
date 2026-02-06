/// PDF generation service for invoices and receipts.
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import '../domain/entities/bill.dart';
import '../domain/entities/payment.dart';
import 'upi_qr_service.dart';

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
    String? signaturePath,
  }) async {
    final pdf = pw.Document();

    // Load fonts
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontMedium = await PdfGoogleFonts.robotoMedium();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontLight = await PdfGoogleFonts.robotoLight();

    // Define Colors
    const primaryColor = PdfColor.fromInt(0xFF1A237E); // Deep Navy
    const accentColor = PdfColor.fromInt(0xFF607D8B); // Slate Grey
    const dividerColor = PdfColor.fromInt(0xFFECEFF1); // Light Grey

    // Clean Theme
    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      fontFallback: [fontRegular],
    );

    // Load meter photo if available
    pw.MemoryImage? meterImage;
    if (bill.meterPhotoPath != null) {
      final file = File(bill.meterPhotoPath!);
      if (await file.exists()) {
        final imageBytes = await file.readAsBytes();
        meterImage = pw.MemoryImage(imageBytes);
      }
    }

    // Load signature image if available
    pw.MemoryImage? signatureImage;
    if (signaturePath != null) {
      final file = File(signaturePath);
      if (await file.exists()) {
        final imageBytes = await file.readAsBytes();
        signatureImage = pw.MemoryImage(imageBytes);
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. BRAND HEADER
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        landlordName.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      if (landlordPhone.isNotEmpty)
                        pw.Text(
                          landlordPhone,
                          style: pw.TextStyle(fontSize: 10, color: accentColor),
                        ),
                      if (landlordAddress != null)
                        pw.Text(
                          landlordAddress,
                          style: pw.TextStyle(fontSize: 10, color: accentColor),
                        ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey200, // Watermark style
                          letterSpacing: 2.0,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        '# INV-${bill.id.toString().padLeft(6, '0')}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),

              // 2. CONTEXT GRID (FROM / TO / DATES)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border.symmetric(
                    horizontal: pw.BorderSide(color: dividerColor),
                  ),
                ),
                child: pw.Row(
                  children: [
                    // BILL TO
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'BILL TO',
                            style: pw.TextStyle(
                              color: accentColor,
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            bill.tenantName ?? 'Tenant',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          if (bill.roomNumber != null)
                            pw.Text(
                              'Room ${bill.roomNumber} • ${bill.propertyName ?? ""}',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // DATE DETAILS
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            mainAxisSize: pw.MainAxisSize.min,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'ISSUED',
                                    style: pw.TextStyle(
                                      color: accentColor,
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    _formatDate(bill.createdAt),
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                              pw.SizedBox(width: 30),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'DUE DATE',
                                    style: pw.TextStyle(
                                      color: accentColor,
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    bill.dueDate != null
                                        ? _formatDate(bill.dueDate!)
                                        : '-',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      color: bill.isOverdue
                                          ? PdfColors.red900
                                          : PdfColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // 3. CLEAN TABLE
              pw.Column(
                children: [
                  // Headers
                  pw.Container(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(color: dividerColor, width: 2),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            'DESCRIPTION',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            'PERIOD',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            'AMOUNT',
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  // Row
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              bill.billType.name.toUpperCase(),
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            if (bill.billType == BillType.electricity &&
                                bill.electricityPrevReading != null)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                  top: 4,
                                  left: 0,
                                ),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'Readings: ${bill.electricityPrevReading!.toStringAsFixed(0)} → ${bill.electricityCurrReading!.toStringAsFixed(0)}',
                                      style: const pw.TextStyle(
                                        fontSize: 9,
                                        color: PdfColors.grey700,
                                      ),
                                    ),
                                    pw.Text(
                                      'Consumption: ${(bill.electricityCurrReading! - bill.electricityPrevReading!).toStringAsFixed(0)} units @ ₹${bill.electricityRateAtBilling}',
                                      style: const pw.TextStyle(
                                        fontSize: 9,
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
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          '₹${bill.amount.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontSize: 11, font: fontMedium),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(color: dividerColor),
                ],
              ),

              // 4. TOTALS
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.SizedBox(height: 8),
                    _buildTotalRow(
                      'Total Amount',
                      '₹${bill.amount.toStringAsFixed(2)}',
                      fontBold,
                      isBold: true,
                    ),
                    if (bill.paidAmount > 0) ...[
                      pw.SizedBox(height: 4),
                      _buildTotalRow(
                        'Amount Paid',
                        '- ₹${bill.paidAmount.toStringAsFixed(2)}',
                        fontRegular,
                        color: PdfColors.green700,
                      ),
                    ],
                    pw.SizedBox(height: 8),
                    if (bill.pendingAmount > 0)
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 0,
                        ),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: dividerColor),
                          ),
                        ),
                        child: _buildTotalRow(
                          'Balance Due',
                          '₹${bill.pendingAmount.toStringAsFixed(2)}',
                          fontBold,
                          isBold: true,
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      )
                    else
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 8),
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.green50,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          "PAID IN FULL",
                          style: pw.TextStyle(
                            color: PdfColors.green800,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // 5. METER PROOF (Attachment Style)
              if (meterImage != null) ...[
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: dividerColor),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text(
                            'PROOF OF READING',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Container(
                        height: 120,
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Image(meterImage, fit: pw.BoxFit.contain),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
              ],

              // 6. PAYMENT HISTORY
              if (paymentHistory.isNotEmpty) ...[
                pw.Text(
                  'PAYMENT HISTORY',
                  style: pw.TextStyle(
                    fontSize: 8,
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
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(color: dividerColor),
                        ),
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Text(
                            'Date',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Text(
                            'Mode',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ),

                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Text(
                            'Amount',
                            textAlign: pw.TextAlign.right,
                            style: const pw.TextStyle(
                              fontSize: 8,
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
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Text(
                              payment.paymentMode.name.toUpperCase(),
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ),

                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Text(
                              '₹${payment.amount.toStringAsFixed(2)}',
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],

              pw.Expanded(child: pw.Container()),

              // 7. PAYMENT DETAILS & SIGNATURE
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Bank / UPI Details
                  if (landlordUpiId != null)
                    pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey50,
                        borderRadius: pw.BorderRadius.circular(4),
                        border: pw.Border.all(color: dividerColor),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'PAYMENT DETAILS',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: accentColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'UPI ID',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            landlordUpiId,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Authorized Signatory
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      if (signatureImage != null)
                        pw.Container(
                          height: 40,
                          child: pw.Image(
                            signatureImage,
                            fit: pw.BoxFit.contain,
                          ),
                        ),
                      if (signatureImage != null) pw.SizedBox(height: 4),
                      pw.Container(
                        width: 150,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: PdfColors.grey400),
                          ),
                        ),
                        padding: const pw.EdgeInsets.only(top: 4),
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          'Authorized Signatory',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // 8. TERMS & CONDITIONS
              pw.Container(
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'TERMS & CONDITIONS',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey500,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '1. Please pay the bill before the due date to avoid late fees.\n2. This is a computer-generated invoice and no signature is required unless specified.\n3. Make payments via UPI to the details mentioned above.',
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: PdfColors.grey500,
                        lineSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),
              pw.Divider(color: dividerColor),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Thank you for your business',
                    style: pw.TextStyle(
                      fontSize: 8,
                      color: accentColor,
                      font: fontLight,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                  pw.Text(
                    'Generated by RentKhata',
                    style: const pw.TextStyle(
                      color: PdfColors.grey400,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // QR Code Page (Standardized)
    if (landlordUpiId != null && bill.pendingAmount > 0) {
      final qrBytes = await UpiQrService.generateQrImageBytes(
        upiId: landlordUpiId,
        payeeName: landlordName,
        amount: bill.pendingAmount,
        transactionNote: '${bill.billType.name} - ${bill.billingPeriod}',
        size: 200,
      );

      if (qrBytes != null) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            theme: theme,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Scan to Pay',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: dividerColor, width: 2),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Image(
                        pw.MemoryImage(qrBytes),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      landlordName,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      'Amount: ₹${bill.pendingAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    }

    return _savePdf(pdf, 'invoice_${bill.id}');
  }

  pw.Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            '$label  ',
            style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 10),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : null,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTotalRow(
    String label,
    String value,
    pw.Font font, {
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
            font: font,
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
  }) async {
    final pdf = pw.Document();

    // Load fonts
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final theme = pw.ThemeData.withFont(base: fontRegular, bold: fontBold);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      landlordName,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Phone: $landlordPhone',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Badge
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(16),
                    border: pw.Border.all(color: PdfColors.green200),
                  ),
                  child: pw.Text(
                    'PAYMENT RECEIPT',
                    style: pw.TextStyle(
                      color: PdfColors.green900,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              // Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoRow('Receipt #', 'RCT-${payment.id}'),
                  _buildInfoRow('Date', _formatDate(payment.paymentDate)),
                ],
              ),
              pw.Divider(color: PdfColors.grey300),

              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Received From',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      '${bill.tenantName} (Room ${bill.roomNumber})',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),

                    pw.Text(
                      'Payment For',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      '${bill.billType.name.toUpperCase()} - ${bill.billingPeriod}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),

                    pw.SizedBox(height: 10),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Payment Mode',
                                style: const pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.grey600,
                                ),
                              ),
                              pw.Text(
                                payment.paymentMode.name.toUpperCase(),
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (payment.notes != null && payment.notes!.isNotEmpty)
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Notes',
                                  style: const pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.grey600,
                                  ),
                                ),
                                pw.Text(
                                  payment.notes!,
                                  style: const pw.TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Amount
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Amount Received',
                      style: const pw.TextStyle(
                        color: PdfColors.grey600,
                        fontSize: 10,
                      ),
                    ),
                    pw.Text(
                      '₹${payment.amount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green800,
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              pw.Center(
                child: pw.Text(
                  'Thank you!',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  'Generated by RentKhata',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey500,
                  ),
                ),
              ),
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
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}
