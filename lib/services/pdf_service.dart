import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../domain/entities/ledger.dart';
import '../domain/entities/settlement_statement.dart';
import '../core/utils/currency_formatter.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import 'pdf/pdf_template.dart';

class PdfService {
  /// Generates a PDF Ledger statement and returns the saved File.
  static Future<File> generateTenantLedgerPdf(
    LedgerStatement statement,
    AppLocalizations l10n,
  ) async {
    final pdf = pw.Document();

    final theme = await PdfTemplate.loadTheme();
    final logoBytes = await PdfTemplate.loadTransparentLogo();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (pw.Context context) {
          return [
            PdfTemplate.buildModernHeader(
              title: l10n.khataStatement,
              subtitle: l10n.generatedOn(
                '${statement.statementDate.day}/${statement.statementDate.month}/${statement.statementDate.year}',
              ),
              landlordName: statement.landlordName,
              landlordPhone: statement.landlordPhone,
              logoBytes: logoBytes,
              titleFontSize: 20,
            ),
            pw.SizedBox(height: 20),
            _buildSummary(statement, l10n),
            pw.SizedBox(height: 20),
            _buildLedgerTable(statement.entries, l10n),
            pw.SizedBox(height: 30),
            PdfTemplate.buildMarketingFooter(),
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
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  // Removed _buildHeader

  static pw.Widget _buildSummary(
    LedgerStatement statement,
    AppLocalizations l10n,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 16),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
          bottom: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            l10n.totalBilledLabel,
            formatCurrency(statement.totalBilled),
            PdfColors.grey800,
          ),
          _buildSummaryItem(
            l10n.totalPaidLabel,
            formatCurrency(statement.totalPaid),
            PdfColors.green700,
          ),
          _buildSummaryItem(
            l10n.balanceDueLabel,
            formatCurrency(statement.currentBalance),
            PdfTemplate.accentColor,
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
          label.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey500,
            letterSpacing: 1.0,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildLedgerTable(
    List<LedgerEntry> entries,
    AppLocalizations l10n,
  ) {
    final headers = [
      l10n.dateLabel,
      l10n.descriptionLabel,
      l10n.billedLabel,
      l10n.paidLabel,
      l10n.balanceLabel,
    ];

    if (entries.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(32),
        alignment: pw.Alignment.center,
        child: pw.Text(
          'No transactions found.',
          style: pw.TextStyle(
            fontSize: 14,
            color: PdfColors.grey600,
            fontStyle: pw.FontStyle.italic,
          ),
        ),
      );
    }

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
        balanceStr = l10n.advanceLabel(formatCurrency(e.balance.abs()));
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
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.black,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
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
        0: const pw.FlexColumnWidth(1.4), // Date
        1: const pw.FlexColumnWidth(3.8), // Description
        2: const pw.FlexColumnWidth(1.6), // Billed
        3: const pw.FlexColumnWidth(1.6), // Paid
        4: const pw.FlexColumnWidth(1.6), // Balance
      },
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      headerPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    );
  }

  // Removed _buildFooter

  /// Generates a PDF Settlement statement and returns the saved File.
  static Future<File> generateSettlementPdf(
    SettlementStatement statement,
    AppLocalizations l10n,
  ) async {
    final pdf = pw.Document();

    final theme = await PdfTemplate.loadTheme();
    final logoBytes = await PdfTemplate.loadTransparentLogo();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (pw.Context context) {
          return [
            PdfTemplate.buildModernHeader(
              title: l10n.moveOutSettlementTitle,
              subtitle: l10n.moveOutDateLabel(
                '${statement.moveOutDate.day}/${statement.moveOutDate.month}/${statement.moveOutDate.year}',
              ),
              landlordName: statement.landlordName,
              logoBytes: logoBytes,
              titleFontSize: 20,
            ),
            pw.SizedBox(height: 20),
            _buildSettlementDepositSummary(statement, l10n),
            pw.SizedBox(height: 20),
            if (statement.billDeductions.isNotEmpty ||
                statement.manualDeduction > 0)
              _buildSettlementDeductions(statement, l10n),
            pw.SizedBox(height: 30),
            _buildSettlementFooter(statement, l10n),
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
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  // Removed _buildSettlementHeader

  static pw.Widget _buildSettlementDepositSummary(
    SettlementStatement statement,
    AppLocalizations l10n,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 16),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
          bottom: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            l10n.initialSecurityDeposit.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey500,
              letterSpacing: 1.0,
            ),
          ),
          pw.Text(
            formatCurrency(statement.securityDeposit),
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSettlementDeductions(
    SettlementStatement statement,
    AppLocalizations l10n,
  ) {
    final List<List<String>> data = [];

    for (final b in statement.billDeductions) {
      data.add([
        '${b.billTypeLabel} (${b.period})',
        '- ${formatCurrency(b.amount)}',
      ]);
    }

    if (statement.manualDeduction > 0) {
      data.add([
        statement.manualDeductionReason ?? l10n.otherDeductionsTitle,
        '- ${formatCurrency(statement.manualDeduction)}',
      ]);
    }

    if (data.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.deductionsLabel,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.red900,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: [l10n.descriptionLabel, l10n.amountDeductedLabel],
          data: data,
          border: null,
          headerStyle: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          rowDecoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            ),
          ),
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
          cellPadding: const pw.EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSettlementFooter(
    SettlementStatement statement,
    AppLocalizations l10n,
  ) {
    final bool isRefund = statement.refundAmount >= 0;

    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 20),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
              bottom: pw.BorderSide(color: PdfTemplate.dividerColor, width: 0.5),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                isRefund ? l10n.finalRefundAmount.toUpperCase() : l10n.amountTenantOwes.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                  letterSpacing: 1.0,
                ),
              ),
              pw.Text(
                formatCurrency(statement.refundAmount.abs()),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: isRefund ? PdfColors.green700 : PdfColors.red700,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        if (statement.refundAmount == 0)
          pw.Text(
            l10n.accountSettledMsg,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green700,
            ),
          ),
        pw.SizedBox(height: 50),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                pw.Text(
                  l10n.tenantSignature,
                  style: pw.TextStyle(
                    color: PdfColors.grey500,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Column(
              children: [
                pw.Text(
                  l10n.landlordSignature,
                  style: pw.TextStyle(
                    color: PdfColors.grey500,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 32),
        PdfTemplate.buildMarketingFooter(),
        pw.SizedBox(height: 8),
        pw.Center(
          child: pw.Text(
            l10n.computerGeneratedMsg,
            style: pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
