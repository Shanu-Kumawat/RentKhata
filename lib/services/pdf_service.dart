import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../domain/entities/ledger.dart';
import '../core/utils/currency_formatter.dart';

class PdfService {
  /// Generates a PDF Ledger statement and returns the saved File.
  static Future<File> generateTenantLedgerPdf(LedgerStatement statement) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(statement),
            pw.SizedBox(height: 20),
            _buildSummary(statement),
            pw.SizedBox(height: 20),
            _buildLedgerTable(statement.entries),
            pw.SizedBox(height: 30),
            _buildFooter(statement),
          ];
        },
      ),
    );

    // Save PDF to temp directory
    final output = await getTemporaryDirectory();
    final sanitizedTenantName = statement.tenantName.replaceAll(RegExp(r'\W+'), '_');
    final file = File('${output.path}/Ledger_$sanitizedTenantName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildHeader(LedgerStatement statement) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'KHATA STATEMENT',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Generated on: ${statement.statementDate.day}/${statement.statementDate.month}/${statement.statementDate.year}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Landlord info
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('From:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                  pw.Text(statement.landlordName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  if (statement.landlordPhone.isNotEmpty) pw.Text(statement.landlordPhone),
                  pw.Text(statement.propertyName),
                ],
              ),
            ),
            // Tenant info
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                  pw.Text(statement.tenantName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  if (statement.tenantPhone.isNotEmpty) pw.Text(statement.tenantPhone),
                  pw.Text('Room No: ${statement.roomNumber}'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSummary(LedgerStatement statement) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Total Billed', formatCurrency(statement.totalBilled), PdfColors.black),
          _buildSummaryItem('Total Paid', formatCurrency(statement.totalPaid), PdfColors.green700),
          _buildSummaryItem('Balance Due', formatCurrency(statement.currentBalance), PdfColors.red700),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }

  static pw.Widget _buildLedgerTable(List<LedgerEntry> entries) {
    final headers = ['Date', 'Description', 'Charge (Dr)', 'Payment (Cr)', 'Balance'];
    
    final data = entries.map((e) {
      final dateStr = '${e.date.day}/${e.date.month}/${e.date.year}';
      final debitStr = e.debit > 0 ? formatCurrency(e.debit) : '-';
      final creditStr = e.credit > 0 ? formatCurrency(e.credit) : '-';
      final balanceStr = formatCurrency(e.balance);

      return [dateStr, e.description, debitStr, creditStr, balanceStr];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      headerPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    );
  }

  static pw.Widget _buildFooter(LedgerStatement statement) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 8),
        pw.Text(
          'This is a system-generated statement and does not require a physical signature.',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600, fontStyle: pw.FontStyle.italic),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }
}
