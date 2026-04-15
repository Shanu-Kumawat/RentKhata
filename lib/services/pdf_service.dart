import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/entities/ledger.dart';
import '../domain/entities/settlement_statement.dart';
import '../core/utils/currency_formatter.dart';

class PdfService {
  /// Generates a PDF Ledger statement and returns the saved File.
  static Future<File> generateTenantLedgerPdf(LedgerStatement statement) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      fontFallback: [fontRegular],
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
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
    final sanitizedTenantName = statement.tenantName.replaceAll(
      RegExp(r'\W+'),
      '_',
    );
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
                  pw.Text(
                    'From:',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Text(
                    statement.landlordName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  if (statement.landlordPhone.isNotEmpty)
                    pw.Text(statement.landlordPhone),
                  pw.Text(statement.propertyName),
                ],
              ),
            ),
            // Tenant info
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'To:',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Text(
                    statement.tenantName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  if (statement.tenantPhone.isNotEmpty)
                    pw.Text(statement.tenantPhone),
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
          _buildSummaryItem(
            'Total Billed',
            formatCurrency(statement.totalBilled),
            PdfColors.black,
          ),
          _buildSummaryItem(
            'Total Paid',
            formatCurrency(statement.totalPaid),
            PdfColors.green700,
          ),
          _buildSummaryItem(
            'Balance Due',
            formatCurrency(statement.currentBalance),
            PdfColors.red700,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    String value,
    PdfColor color,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildLedgerTable(List<LedgerEntry> entries) {
    final headers = ['Date', 'Description', 'Billed', 'Paid', 'Balance'];

    final data = entries.map((e) {
      final dateStr = '${e.date.day}/${e.date.month}/${e.date.year}';
      final debitStr = e.debit > 0 ? formatCurrency(e.debit) : '';
      final creditStr = e.credit > 0 ? formatCurrency(e.credit) : '';

      // Format balance specifically so it's perfectly clear
      String balanceStr;
      if (e.balance == 0) {
        balanceStr = '₹0';
      } else if (e.balance < 0) {
        // Negative balance means tenant overpaid / has advance
        balanceStr = '${formatCurrency(e.balance.abs())} (Adv)';
      } else {
        balanceStr = formatCurrency(e.balance);
      }

      return [dateStr, e.description, debitStr, creditStr, balanceStr];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      cellAlignment: pw.Alignment.centerLeft,
      headerAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5), // Date
        1: const pw.FlexColumnWidth(2.5), // Description
        2: const pw.FlexColumnWidth(2), // Billed
        3: const pw.FlexColumnWidth(2), // Paid
        4: const pw.FlexColumnWidth(2), // Balance
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
          style: pw.TextStyle(
            fontSize: 9,
            color: PdfColors.grey600,
            fontStyle: pw.FontStyle.italic,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  /// Generates a PDF Settlement statement and returns the saved File.
  static Future<File> generateSettlementPdf(SettlementStatement statement) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      fontFallback: [fontRegular],
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildSettlementHeader(statement),
            pw.SizedBox(height: 20),
            _buildSettlementDepositSummary(statement),
            pw.SizedBox(height: 20),
            if (statement.billDeductions.isNotEmpty || statement.manualDeduction > 0)
              _buildSettlementDeductions(statement),
            pw.SizedBox(height: 30),
            _buildSettlementFooter(statement),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final sanitizedTenantName = statement.tenantName.replaceAll(
      RegExp(r'\W+'),
      '_',
    );
    final file = File('${output.path}/Settlement_$sanitizedTenantName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildSettlementHeader(SettlementStatement statement) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'MOVE-OUT SETTLEMENT',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blueGrey900,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Move Out Date: ${statement.moveOutDate.day}/${statement.moveOutDate.month}/${statement.moveOutDate.year}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Landlord:', style: pw.TextStyle(color: PdfColors.grey600)),
                  pw.Text(statement.landlordName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(statement.propertyName),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Tenant:', style: pw.TextStyle(color: PdfColors.grey600)),
                  pw.Text(statement.tenantName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Room No: ${statement.roomNumber}'),
                  pw.Text('Move In: ${statement.moveInDate.day}/${statement.moveInDate.month}/${statement.moveInDate.year}'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSettlementDepositSummary(SettlementStatement statement) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.green200),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Initial Security Deposit',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.green900),
          ),
          pw.Text(
            formatCurrency(statement.securityDeposit),
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green900),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSettlementDeductions(SettlementStatement statement) {
    final List<List<String>> data = [];
    
    for (final b in statement.billDeductions) {
      data.add(['${b.billTypeLabel} (${b.period})', '- ${formatCurrency(b.amount)}']);
    }
    
    if (statement.manualDeduction > 0) {
      data.add([statement.manualDeductionReason ?? 'Other Deductions', '- ${formatCurrency(statement.manualDeduction)}']);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Deductions', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Description', 'Amount Deducted'],
          data: data,
          border: null,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.red800),
          rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
          cellAlignment: pw.Alignment.centerLeft,
          headerAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
          },
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
          },
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(1),
          },
          cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
      ],
    );
  }

  static pw.Widget _buildSettlementFooter(SettlementStatement statement) {
    final bool isRefund = statement.refundAmount >= 0;
    
    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: isRefund ? PdfColors.blue50 : PdfColors.red50,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            border: pw.Border.all(color: isRefund ? PdfColors.blue300 : PdfColors.red300),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                isRefund ? 'Final Refund Amount' : 'Amount Tenant Owes',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                formatCurrency(statement.refundAmount.abs()),
                style: pw.TextStyle(
                  fontSize: 22, 
                  fontWeight: pw.FontWeight.bold, 
                  color: isRefund ? PdfColors.blue900 : PdfColors.red900
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        if (statement.refundAmount == 0)
          pw.Text('ACCOUNT SETTLED - NO CURRENT DUES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
        pw.SizedBox(height: 50),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                pw.Container(width: 150, height: 1, color: PdfColors.grey500),
                pw.SizedBox(height: 4),
                pw.Text('Tenant Signature', style: pw.TextStyle(color: PdfColors.grey700)),
              ],
            ),
            pw.Column(
              children: [
                pw.Container(width: 150, height: 1, color: PdfColors.grey500),
                pw.SizedBox(height: 4),
                pw.Text('Landlord Signature', style: pw.TextStyle(color: PdfColors.grey700)),
              ],
            ),
          ]
        ),
        pw.SizedBox(height: 32),
        pw.Center(
          child: pw.Text(
            'This is a computer-generated statement and does not require a physical signature.',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
