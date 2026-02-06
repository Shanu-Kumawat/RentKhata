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

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
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
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Invoice details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Bill To:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(bill.tenantName ?? 'Tenant'),
                      if (bill.roomNumber != null)
                        pw.Text('Room ${bill.roomNumber}'),
                      if (bill.propertyName != null)
                        pw.Text(bill.propertyName!),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Invoice #: INV-${bill.id}'),
                      pw.Text('Date: ${_formatDate(bill.createdAt)}'),
                      if (bill.dueDate != null)
                        pw.Text('Due: ${_formatDate(bill.dueDate!)}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Bill table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _tableHeader('Description'),
                      _tableHeader('Period'),
                      _tableHeader('Amount'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _tableCell(bill.billType.name.toUpperCase()),
                      _tableCell(bill.billingPeriod),
                      _tableCell('₹${bill.amount.toStringAsFixed(2)}'),
                    ],
                  ),
                  // If electricity bill, show breakdown
                  if (bill.billType == BillType.electricity &&
                      bill.electricityPrevReading != null) ...[
                    pw.TableRow(
                      children: [
                        _tableCell('  Previous Reading'),
                        _tableCell(''),
                        _tableCell(
                          bill.electricityPrevReading!.toStringAsFixed(0),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        _tableCell('  Current Reading'),
                        _tableCell(''),
                        _tableCell(
                          bill.electricityCurrReading!.toStringAsFixed(0),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        _tableCell(
                          '  Units @ ₹${bill.electricityRateAtBilling}/unit',
                        ),
                        _tableCell(''),
                        _tableCell(
                          '${(bill.electricityCurrReading! - bill.electricityPrevReading!).toStringAsFixed(0)} units',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              pw.SizedBox(height: 20),

              // Totals
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('Total: '),
                        pw.Text(
                          '₹${bill.amount.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    if (bill.paidAmount > 0)
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Text('Paid: '),
                          pw.Text('₹${bill.paidAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                    if (bill.pendingAmount > 0)
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Text(
                            'Balance Due: ',
                            style: pw.TextStyle(color: PdfColors.red),
                          ),
                          pw.Text(
                            '₹${bill.pendingAmount.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),

              // Payment info with QR code
              if (landlordUpiId != null && bill.pendingAmount > 0) ...[
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Payment Information',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('UPI ID: $landlordUpiId'),
                          pw.SizedBox(height: 5),
                          pw.Text('Scan QR code to pay'),
                        ],
                      ),
                    ),
                    // QR Code placeholder - will be added via async method
                  ],
                ),
              ] else if (landlordUpiId != null) ...[
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Payment Information',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 5),
                pw.Text('UPI ID: $landlordUpiId'),
              ],

              pw.Expanded(child: pw.Container()),

              // Footer
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Generated by RentKhata',
                  style: const pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // If UPI ID is provided and there's pending amount, add QR code on a second pass
    if (landlordUpiId != null && bill.pendingAmount > 0) {
      final qrBytes = await UpiQrService.generateQrImageBytes(
        upiId: landlordUpiId,
        payeeName: landlordName,
        amount: bill.pendingAmount,
        transactionNote: '${bill.billType.name} - ${bill.billingPeriod}',
        size: 150,
      );

      if (qrBytes != null) {
        // Add a page with QR code at the bottom
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
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
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Image(pw.MemoryImage(qrBytes), width: 150, height: 150),
                    pw.SizedBox(height: 10),
                    pw.Text('UPI ID: $landlordUpiId'),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Amount: ₹${bill.pendingAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
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

  /// Generate receipt PDF for a payment.
  Future<File> generateReceipt({
    required Bill bill,
    required Payment payment,
    required String landlordName,
    required String landlordPhone,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
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
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('Phone: $landlordPhone'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Receipt title
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    'PAYMENT RECEIPT',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green900,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Receipt details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Receipt #: RCT-${payment.id}'),
                  pw.Text('Date: ${_formatDate(payment.paymentDate)}'),
                ],
              ),
              pw.SizedBox(height: 20),

              // Payment info
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Received From: ${bill.tenantName ?? "Tenant"}'),
                    if (bill.roomNumber != null)
                      pw.Text(
                        'Room: ${bill.roomNumber} (${bill.propertyName ?? ""})',
                      ),
                    pw.SizedBox(height: 10),
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'For: ${bill.billType.name.toUpperCase()} - ${bill.billingPeriod}',
                    ),
                    pw.Text(
                      'Payment Mode: ${payment.paymentMode.name.toUpperCase()}',
                    ),
                    if (payment.notes != null && payment.notes!.isNotEmpty)
                      pw.Text('Notes: ${payment.notes}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Amount
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    '₹${payment.amount.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green900,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Balance
              if (bill.pendingAmount > 0)
                pw.Center(
                  child: pw.Text(
                    'Balance Remaining: ₹${bill.pendingAmount.toStringAsFixed(2)}',
                    style: const pw.TextStyle(color: PdfColors.orange),
                  ),
                )
              else
                pw.Center(
                  child: pw.Text(
                    '✓ Bill Fully Paid',
                    style: pw.TextStyle(
                      color: PdfColors.green,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),

              pw.Expanded(child: pw.Container()),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Thank you for your payment!',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Generated by RentKhata',
                  style: const pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 10,
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

  pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    );
  }

  pw.Widget _tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text),
    );
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
