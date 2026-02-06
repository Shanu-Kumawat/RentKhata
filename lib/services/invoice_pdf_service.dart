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
  }) async {
    final pdf = pw.Document();

    // Load fonts
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final theme = pw.ThemeData.withFont(base: fontRegular, bold: fontBold);

    // Load meter photo if available
    pw.MemoryImage? meterImage;
    if (bill.meterPhotoPath != null) {
      final file = File(bill.meterPhotoPath!);
      if (await file.exists()) {
        final imageBytes = await file.readAsBytes();
        meterImage = pw.MemoryImage(imageBytes);
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
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        landlordName,
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (landlordPhone.isNotEmpty)
                        pw.Text('Phone: $landlordPhone'),
                      if (landlordAddress != null) pw.Text(landlordAddress),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blueGrey900,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 40),

              // Info Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'BILL TO',
                        style: pw.TextStyle(
                          color: PdfColors.grey600,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        bill.tenantName ?? 'Tenant',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (bill.roomNumber != null)
                        pw.Text('Room: ${bill.roomNumber}'),
                      if (bill.propertyName != null)
                        pw.Text(bill.propertyName!),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildInfoRow('Invoice No:', 'INV-${bill.id}'),
                      _buildInfoRow('Date:', _formatDate(bill.createdAt)),
                      if (bill.dueDate != null)
                        _buildInfoRow(
                          'Due Date:',
                          _formatDate(bill.dueDate!),
                          isBold: true,
                        ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Item Table
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    // Header
                    pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey100,
                        borderRadius: pw.BorderRadius.vertical(
                          top: pw.Radius.circular(8),
                        ),
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              'Description',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              'Period',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              'Amount',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Item
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  bill.billType.name.toUpperCase(),
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                if (bill.billType == BillType.electricity &&
                                    bill.electricityPrevReading != null)
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          'Prev Reading: ${bill.electricityPrevReading!.toStringAsFixed(0)}',
                                          style: const pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColors.grey700,
                                          ),
                                        ),
                                        pw.Text(
                                          'Curr Reading: ${bill.electricityCurrReading!.toStringAsFixed(0)}',
                                          style: const pw.TextStyle(
                                            fontSize: 10,
                                            color: PdfColors.grey700,
                                          ),
                                        ),
                                        pw.Text(
                                          'Units: ${(bill.electricityCurrReading! - bill.electricityPrevReading!).toStringAsFixed(0)} @ ₹${bill.electricityRateAtBilling}/unit',
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
                            child: pw.Text(bill.billingPeriod),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              '₹${bill.amount.toStringAsFixed(2)}',
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildTotalRow(
                        'Total Amount:',
                        '₹${bill.amount.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                      if (bill.paidAmount > 0)
                        _buildTotalRow(
                          'Amount Paid:',
                          '₹${bill.paidAmount.toStringAsFixed(2)}',
                          color: PdfColors.green700,
                        ),
                      if (bill.pendingAmount > 0)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 8),
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(8),
                            color: PdfColors.red50,
                            child: _buildTotalRow(
                              'Balance Due:',
                              '₹${bill.pendingAmount.toStringAsFixed(2)}',
                              isBold: true,
                              color: PdfColors.red700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Meter Photo Section
              if (meterImage != null) ...[
                pw.Text(
                  'Meter Reading Proof',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Container(
                  height: 150,
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Image(meterImage, fit: pw.BoxFit.contain),
                ),
                pw.SizedBox(height: 20),
              ],

              pw.Expanded(child: pw.Container()),

              // Payment Info Footer
              if (landlordUpiId != null && bill.pendingAmount > 0)
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text(
                              'PAYMENT INFO',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'UPI ID: $landlordUpiId',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.grey300),
              pw.Center(
                child: pw.Text(
                  'Generated by RentKhata',
                  style: const pw.TextStyle(
                    color: PdfColors.grey500,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // QR Code Page (Optional)
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
                      'Scan to Pay via UPI',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Image(pw.MemoryImage(qrBytes), width: 200, height: 200),
                    pw.SizedBox(height: 10),
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
    String value, {
    bool isBold = false,
    PdfColor? color,
  }) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text('$label   ', style: const pw.TextStyle(fontSize: 12)),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
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
