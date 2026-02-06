/// Invoice preview screen for viewing and sharing bills.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../services/invoice_pdf_service.dart';
import '../../../services/share_service.dart';
import '../../../services/upi_qr_service.dart';
import '../../widgets/share_bottom_sheet.dart';

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
      appBar: AppBar(title: const Text('Invoice Preview')),
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
              // PDF Preview button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _previewPdf(context),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('PDF Preview'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Share button - opens bottom sheet
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _showShareOptions(context, ref),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context, WidgetRef ref) {
    ShareBottomSheet.show(
      context: context,
      contentType: ShareContentType.invoice,
      onShareAsMessage: () => _shareAsMessage(context, ref),
      onShareAsPdf: () => _shareAsPdf(context),
    );
  }

  Future<void> _shareAsMessage(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(billingRepositoryProvider);
    final shareService = ShareService(repo);
    await shareService.shareInvoice(
      bill: bill,
      landlordName: landlordName ?? 'Landlord',
      landlordUpi: landlordUpi,
    );
  }

  Future<void> _previewPdf(BuildContext context) async {
    try {
      final pdfService = InvoicePdfService();
      final file = await pdfService.generateInvoice(
        bill: bill,
        landlordName: landlordName ?? 'Landlord',
        landlordPhone: landlordPhone ?? '',
        landlordUpiId: landlordUpi,
      );

      await pdfService.openPdf(file);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error previewing PDF: $e')));
      }
    }
  }

  Future<void> _shareAsPdf(BuildContext context) async {
    try {
      final pdfService = InvoicePdfService();
      final file = await pdfService.generateInvoice(
        bill: bill,
        landlordName: landlordName ?? 'Landlord',
        landlordPhone: landlordPhone ?? '',
        landlordUpiId: landlordUpi,
      );

      final shareService = ShareService();
      await shareService.shareFiles(
        files: [file],
        subject: 'Invoice ${bill.billNumber ?? ""}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing PDF: $e')));
      }
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
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
                      color: bill.isOverdue
                          ? Theme.of(context).colorScheme.error
                          : null,
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Previous Reading',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '${bill.electricityPrevReading!.toStringAsFixed(0)} units',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Current Reading',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '${bill.electricityCurrReading!.toStringAsFixed(0)} units',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
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
                                  color: Colors.grey.shade900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${(bill.electricityCurrReading! - bill.electricityPrevReading!).toStringAsFixed(0)} units @ ${formatCurrency(bill.electricityRateAtBilling ?? 0)}/unit',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Meter Photo Section
                  if (bill.meterPhotoPath != null &&
                      bill.meterPhotoPath!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meter Photo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(bill.meterPhotoPath!),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(),
                          ),
                        ),
                      ],
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
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
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
                              color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              '- ${formatCurrency(bill.paidAmount)}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
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
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.tertiary,
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          color: color,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
