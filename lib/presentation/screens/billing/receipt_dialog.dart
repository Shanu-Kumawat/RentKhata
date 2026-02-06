/// Receipt dialog shown after bill is fully paid.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/payment.dart';

/// Dialog to show payment receipt after successful payment.
class ReceiptDialog extends StatelessWidget {
  final Bill bill;
  final Payment? latestPayment;
  final String? landlordName;

  const ReceiptDialog({
    super.key,
    required this.bill,
    this.latestPayment,
    this.landlordName,
  });

  /// Show the receipt dialog.
  static Future<void> show({
    required BuildContext context,
    required Bill bill,
    Payment? latestPayment,
    String? landlordName,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ReceiptDialog(
        bill: bill,
        latestPayment: latestPayment,
        landlordName: landlordName,
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
                        isFullyPaid ? 'Payment Complete!' : 'Payment Recorded',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFullyPaid
                            ? 'Bill has been fully paid'
                            : 'Partial payment recorded',
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
                    _ReceiptRow(label: 'Invoice', value: bill.billNumber!),
                  _ReceiptRow(
                    label: 'Type',
                    value: _getBillTypeLabel(bill.billType),
                  ),
                  _ReceiptRow(label: 'Period', value: bill.billingPeriod),
                  if (bill.roomNumber != null)
                    _ReceiptRow(
                      label: 'Room',
                      value: 'Room ${bill.roomNumber}',
                    ),

                  const Divider(height: 24),

                  // Payment info
                  if (latestPayment != null) ...[
                    _ReceiptRow(
                      label: 'Payment Amount',
                      value: formatCurrency(latestPayment!.amount),
                      isHighlighted: true,
                    ),
                    _ReceiptRow(
                      label: 'Payment Mode',
                      value: _getPaymentModeLabel(latestPayment!.paymentMode),
                    ),
                    _ReceiptRow(
                      label: 'Date',
                      value: _formatDate(latestPayment!.paymentDate),
                    ),
                    const Divider(height: 24),
                  ],

                  // Summary
                  _ReceiptRow(
                    label: 'Bill Total',
                    value: formatCurrency(bill.amount),
                  ),
                  _ReceiptRow(
                    label: 'Paid',
                    value: formatCurrency(bill.paidAmount),
                    valueColor: AppColors.success,
                  ),
                  if (bill.pendingAmount > 0)
                    _ReceiptRow(
                      label: 'Balance',
                      value: formatCurrency(bill.pendingAmount),
                      valueColor: AppColors.moneyPending,
                      isHighlighted: true,
                    ),

                  const SizedBox(height: 24),

                  // Actions - Close button only
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
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

  String _getBillTypeLabel(BillType type) {
    switch (type) {
      case BillType.rent:
        return 'Monthly Rent';
      case BillType.electricity:
        return 'Electricity';
      case BillType.water:
        return 'Water';
      case BillType.maintenance:
        return 'Maintenance';
      case BillType.other:
        return 'Other';
    }
  }

  String _getPaymentModeLabel(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.bankTransfer:
        return 'Bank Transfer';
      case PaymentMode.cheque:
        return 'Cheque';
      case PaymentMode.other:
        return 'Other';
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
