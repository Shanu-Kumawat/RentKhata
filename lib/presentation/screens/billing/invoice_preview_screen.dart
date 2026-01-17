/// Invoice preview screen for viewing and sharing bills.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../services/share_service.dart';
import '../../../services/upi_qr_service.dart';

/// Screen to preview an invoice before sharing.
class InvoicePreviewScreen extends ConsumerWidget {
  final Bill bill;
  final String? landlordName;
  final String? landlordPhone;
  final String? landlordUpi;

  const InvoicePreviewScreen({
    super.key,
    required this.bill,
    this.landlordName,
    this.landlordPhone,
    this.landlordUpi,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Invoice Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share via WhatsApp',
            onPressed: () => _shareInvoice(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _InvoiceCard(
              bill: bill,
              landlordName: landlordName,
              landlordPhone: landlordPhone,
              landlordUpi: landlordUpi,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _shareInvoice(context),
                  icon: const Icon(Icons.send),
                  label: const Text('Share Invoice'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareInvoice(BuildContext context) async {
    final shareService = ShareService();
    final success = await shareService.shareInvoiceToWhatsApp(
      bill: bill,
      landlordName: landlordName ?? 'Landlord',
      landlordUpi: landlordUpi,
      tenantPhone: null, // Will open WhatsApp to select contact
    );

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open WhatsApp. Is it installed?'),
        ),
      );
    }
  }
}

/// The invoice card widget with all billing details.
class _InvoiceCard extends StatelessWidget {
  final Bill bill;
  final String? landlordName;
  final String? landlordPhone;
  final String? landlordUpi;

  const _InvoiceCard({
    required this.bill,
    this.landlordName,
    this.landlordPhone,
    this.landlordUpi,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INVOICE',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        if (bill.billNumber != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            bill.billNumber!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                    _StatusBadge(status: bill.status),
                  ],
                ),
              ],
            ),
          ),

          // Bill details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tenant & Property info
                if (bill.tenantName != null || bill.roomNumber != null) ...[
                  _DetailRow(
                    label: 'Bill To',
                    value: bill.tenantName ?? 'Tenant',
                    valueStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bill.roomNumber != null)
                    _DetailRow(label: 'Room', value: 'Room ${bill.roomNumber}'),
                  if (bill.propertyName != null)
                    _DetailRow(label: 'Property', value: bill.propertyName!),
                  const Divider(height: 32),
                ],

                // Billing period & dates
                _DetailRow(
                  label: 'Billing Period',
                  value: bill.billingPeriod,
                  valueStyle: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (bill.periodStartDate != null && bill.periodEndDate != null)
                  _DetailRow(
                    label: 'Period',
                    value:
                        '${_formatDate(bill.periodStartDate!)} - ${_formatDate(bill.periodEndDate!)}',
                  ),
                if (bill.dueDate != null)
                  _DetailRow(
                    label: 'Due Date',
                    value: _formatDate(bill.dueDate!),
                    valueStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: bill.isOverdue ? AppColors.error : null,
                      fontWeight: bill.isOverdue ? FontWeight.bold : null,
                    ),
                  ),
                const Divider(height: 32),

                // Bill type & description
                _DetailRow(
                  label: 'Type',
                  value: _getBillTypeLabel(bill.billType),
                ),

                // Electricity-specific details
                if (bill.billType == BillType.electricity) ...[
                  if (bill.electricityPrevReading != null &&
                      bill.electricityCurrReading != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Previous Reading',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${bill.electricityPrevReading!.toStringAsFixed(0)} units',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Current Reading',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${bill.electricityCurrReading!.toStringAsFixed(0)} units',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Units Consumed',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${(bill.electricityCurrReading! - bill.electricityPrevReading!).toStringAsFixed(0)} units @ ${formatCurrency(bill.electricityRateAtBilling ?? 0)}/unit',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],

                if (bill.notes != null && bill.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Notes', value: bill.notes!),
                ],

                const SizedBox(height: 24),

                // Amount section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            formatCurrency(bill.amount),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      if (bill.paidAmount > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Paid',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                            Text(
                              '- ${formatCurrency(bill.paidAmount)}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance Due',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency(bill.pendingAmount),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: bill.pendingAmount > 0
                                    ? AppColors.moneyPending
                                    : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // UPI QR Code
                if (landlordUpi != null && bill.pendingAmount > 0) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Scan to Pay',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: UpiQrService.generateQrWidget(
                            upiId: landlordUpi!,
                            payeeName: landlordName ?? 'Landlord',
                            amount: bill.pendingAmount,
                            transactionNote:
                                '${bill.billType.name} - ${bill.billingPeriod}',
                            size: 120,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'UPI: $landlordUpi',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Footer
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Generated on ${_formatDate(DateTime.now())}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        return 'Electricity Bill';
      case BillType.water:
        return 'Water Bill';
      case BillType.maintenance:
        return 'Maintenance';
      case BillType.other:
        return 'Other Charges';
    }
  }
}

/// Status badge widget to show bill status.
class _StatusBadge extends StatelessWidget {
  final BillStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      BillStatus.draft => (Colors.grey, 'DRAFT'),
      BillStatus.sent => (Colors.blue.shade300, 'SENT'),
      BillStatus.partial => (Colors.orange, 'PARTIAL'),
      BillStatus.paid => (Colors.green, 'PAID'),
      BillStatus.overdue => (Colors.red, 'OVERDUE'),
      BillStatus.voided => (Colors.grey.shade600, 'VOIDED'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// A simple detail row for label-value pairs.
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
