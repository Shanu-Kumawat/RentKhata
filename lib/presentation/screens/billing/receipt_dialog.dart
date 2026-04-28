/// Receipt dialog shown after bill is fully paid.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/payment.dart';
import '../../../services/invoice_pdf_service.dart';
import '../../../services/share_service.dart';
import '../pdf/pdf_preview_screen.dart';
import '../../widgets/share_bottom_sheet.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Dialog to show payment receipt after successful payment.
class ReceiptDialog extends StatelessWidget {
  final Bill bill;
  final Payment? latestPayment;
  final String? landlordName;
  final String? landlordPhone;

  const ReceiptDialog({
    super.key,
    required this.bill,
    this.latestPayment,
    this.landlordName,
    this.landlordPhone,
  });

  /// Show the receipt dialog.
  static Future<void> show({
    required BuildContext context,
    required Bill bill,
    Payment? latestPayment,
    String? landlordName,
    String? landlordPhone,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ReceiptDialog(
        bill: bill,
        latestPayment: latestPayment,
        landlordName: landlordName,
        landlordPhone: landlordPhone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFullyPaid = bill.isFullyPaid;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isFullyPaid
                      ? [AppColors.success, const Color(0xFF059669)]
                      : [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFullyPaid ? Icons.check_circle : Icons.receipt_long,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isFullyPaid
                            ? AppLocalizations.of(context)!.paymentComplete
                            : AppLocalizations.of(context)!.paymentRecorded,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFullyPaid
                            ? AppLocalizations.of(context)!.billFullyPaidLabel
                            : AppLocalizations.of(
                                context,
                              )!.partialPaymentRecorded,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Receipt details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Bill info
                  if (bill.billNumber != null)
                    _ReceiptRow(
                      label: AppLocalizations.of(context)!.invoiceLabel,
                      value: bill.billNumber!,
                    ),
                  _ReceiptRow(
                    label: AppLocalizations.of(context)!.type,
                    value: _getBillTypeLabel(context, bill.billType),
                  ),
                  _ReceiptRow(
                    label: AppLocalizations.of(context)!.periodLabel,
                    value: bill.billingPeriod,
                  ),
                  if (bill.roomNumber != null)
                    _ReceiptRow(
                      label: AppLocalizations.of(context)!.roomLabel,
                      value: AppLocalizations.of(
                        context,
                      )!.roomNumber(bill.roomNumber!),
                    ),

                  const Divider(height: 24),

                  // Payment info
                  if (latestPayment != null) ...[
                    _ReceiptRow(
                      label: AppLocalizations.of(context)!.paymentAmountLabel,
                      value: formatCurrency(latestPayment!.amount),
                      isHighlighted: true,
                    ),
                    _ReceiptRow(
                      label: AppLocalizations.of(context)!.paymentModeLabel,
                      value: _getPaymentModeLabel(
                        context,
                        latestPayment!.paymentMode,
                      ),
                    ),
                    _ReceiptRow(
                      label: AppLocalizations.of(context)!.date,
                      value: _formatDate(latestPayment!.paymentDate),
                    ),
                    const Divider(height: 24),
                  ],

                  // Summary
                  _ReceiptRow(
                    label: AppLocalizations.of(context)!.billTotalLabel,
                    value: formatCurrency(bill.amount),
                  ),
                  _ReceiptRow(
                    label: AppLocalizations.of(context)!.paidLabel,
                    value: formatCurrency(bill.paidAmount),
                    valueColor: AppColors.success,
                  ),
                  if (bill.pendingAmount > 0)
                    _ReceiptRow(
                      label: AppLocalizations.of(context)!.balanceLabel,
                      value: formatCurrency(bill.pendingAmount),
                      valueColor: AppColors.moneyPending,
                      isHighlighted: true,
                    ),

                  const SizedBox(height: 24),

                  // Actions
                  if (latestPayment != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _openReceiptPdf(context),
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: Text(AppLocalizations.of(context)!.viewPdf),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.closeLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _openReceiptPdf(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final payment = latestPayment;
    if (payment == null) return;

    try {
      final pdfService = InvoicePdfService();
      final file = await pdfService.generateReceipt(
        bill: bill,
        payment: payment,
        landlordName: landlordName ?? l10n.landlord,
        landlordPhone: landlordPhone ?? '',
      );

      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (innerContext) => PdfPreviewScreen(
            pdfFile: file,
            title: AppLocalizations.of(context)!.paymentReceipt,
            shareSubject: AppLocalizations.of(context)!.paymentReceipt,
            suggestedFileName: file.path.split('/').last,
            shareContentType: ShareContentType.receipt,
            onShareAsMessage: () => _shareReceiptAsMessage(context, payment),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorGeneratingPdf(e.toString())), 
        ),
      );
    }
  }

  Future<void> _shareReceiptAsMessage(
    BuildContext context,
    Payment payment,
  ) async {
    final shareService = ShareService();
    await shareService.shareReceipt(
      bill: bill,
      payment: payment,
      landlordName: landlordName ?? AppLocalizations.of(context)!.landlord,
    );
  }

  String _getBillTypeLabel(BuildContext context, BillType type) {
    switch (type) {
      case BillType.rent:
        return AppLocalizations.of(context)!.monthlyRent;
      case BillType.electricity:
        return AppLocalizations.of(context)!.electricity;
      case BillType.water:
        return AppLocalizations.of(context)!.water;
      case BillType.maintenance:
        return AppLocalizations.of(context)!.maintenance;
      case BillType.other:
        return AppLocalizations.of(context)!.other;
    }
  }

  String _getPaymentModeLabel(BuildContext context, PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash:
        return AppLocalizations.of(context)!.cash;
      case PaymentMode.upi:
        return AppLocalizations.of(context)!.upi;
      case PaymentMode.bankTransfer:
        return AppLocalizations.of(context)!.bankTransfer;
      case PaymentMode.cheque:
        return AppLocalizations.of(context)!.cheque;
      case PaymentMode.other:
        return AppLocalizations.of(context)!.other;
    }
  }
}

/// A row in the receipt showing label and value.
class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;
  final Color? valueColor;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: isHighlighted
                  ? theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    )
                  : theme.textTheme.bodyMedium?.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
