/// Bill detail screen with comprehensive bill information.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/payment.dart';
import 'invoice_preview_screen.dart';
import 'record_payment_sheet.dart';

/// Screen to view detailed bill information including payments.
class BillDetailScreen extends ConsumerWidget {
  final Bill bill;

  const BillDetailScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for real-time updates to this bill
    final billAsync = ref.watch(billByIdProvider(bill.id));

    return billAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Bill Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Bill Details')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (currentBill) {
        final activeBill = currentBill ?? bill;
        return _BillDetailContent(bill: activeBill);
      },
    );
  }
}

class _BillDetailContent extends ConsumerWidget {
  final Bill bill;

  const _BillDetailContent({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final paymentsAsync = ref.watch(paymentsForBillProvider(bill.id));
    final landlordAsync = ref.watch(landlordProvider);

    // Extract landlord info
    final landlord = landlordAsync.valueOrNull;
    final landlordName = landlord?.name;
    final landlordUpi = landlord?.upiId;

    return Scaffold(
      appBar: AppBar(
        title: Text(bill.billNumber ?? 'Bill Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'View Invoice',
            onPressed: () => _viewInvoice(context, landlordName, landlordUpi),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(
              context,
              ref,
              value,
              landlordName,
              landlordUpi,
            ),
            itemBuilder: (context) => [
              if (bill.canEdit)
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Edit Bill'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              if (bill.canDelete)
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(
                      'Delete Bill',
                      style: TextStyle(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share_outlined),
                  title: Text('Share Invoice'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Amount Card
            _StatusCard(bill: bill),
            const SizedBox(height: 16),

            // Bill Details Card
            _BillInfoCard(bill: bill),
            const SizedBox(height: 16),

            // Electricity Details (if applicable)
            if (bill.billType == BillType.electricity &&
                bill.electricityPrevReading != null) ...[
              _ElectricityDetailsCard(bill: bill),
              const SizedBox(height: 16),
            ],

            // Payments Section
            Text(
              'Payment History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            paymentsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error loading payments: $e'),
                ),
              ),
              data: (payments) => payments.isEmpty
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.payment_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No payments recorded',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: payments
                          .map((p) => _PaymentTile(payment: p))
                          .toList(),
                    ),
            ),

            // Notes (if any)
            if (bill.notes != null && bill.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(bill.notes!, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: bill.canRecordPayment
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () => _recordPayment(context),
                  icon: const Icon(Icons.payment),
                  label: Text(
                    'Record Payment (${formatCurrency(bill.pendingAmount)} due)',
                  ),
                ),
              ),
            )
          : null,
    );
  }

  void _viewInvoice(
    BuildContext context,
    String? landlordName,
    String? landlordUpi,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoicePreviewScreen(
          bill: bill,
          landlordName: landlordName,
          landlordUpi: landlordUpi,
        ),
      ),
    );
  }

  void _recordPayment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RecordPaymentSheet(bill: bill),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    String? landlordName,
    String? landlordUpi,
  ) {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit bill screen
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Edit bill coming soon')));
        break;
      case 'delete':
        _confirmDeleteBill(context, ref);
        break;
      case 'share':
        _viewInvoice(context, landlordName, landlordUpi);
        break;
    }
  }

  void _confirmDeleteBill(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bill?'),
        content: Text(
          'Are you sure you want to delete this ${bill.billType.name} bill for ${bill.billingPeriod}?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete bill coming soon')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Card showing bill status and amounts.
class _StatusCard extends StatelessWidget {
  final Bill bill;

  const _StatusCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusLabel, statusIcon) = _getStatusDetails(
      bill.status,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Status header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: statusColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  statusLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (bill.isOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'OVERDUE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Amount breakdown
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _AmountColumn(
                      label: 'Total',
                      amount: bill.amount,
                      color: AppColors.primary,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _AmountColumn(
                      label: 'Paid',
                      amount: bill.paidAmount,
                      color: AppColors.success,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _AmountColumn(
                      label: 'Pending',
                      amount: bill.pendingAmount,
                      color: bill.pendingAmount > 0
                          ? AppColors.moneyPending
                          : AppColors.success,
                    ),
                  ],
                ),
                if (bill.paidAmount > 0 && bill.pendingAmount > 0) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: bill.paidAmount / bill.amount,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.success,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, String, IconData) _getStatusDetails(BillStatus status) {
    return switch (status) {
      BillStatus.draft => (Colors.grey, 'Draft', Icons.edit_note),
      BillStatus.sent => (Colors.blue, 'Sent', Icons.send),
      BillStatus.partial => (Colors.orange, 'Partially Paid', Icons.timelapse),
      BillStatus.paid => (AppColors.success, 'Paid', Icons.check_circle),
      BillStatus.overdue => (AppColors.error, 'Overdue', Icons.warning),
      BillStatus.voided => (Colors.grey.shade600, 'Voided', Icons.cancel),
    };
  }
}

/// Column showing amount with label.
class _AmountColumn extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _AmountColumn({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          formatCurrency(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Card showing bill info (type, period, dates).
class _BillInfoCard extends StatelessWidget {
  final Bill bill;

  const _BillInfoCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.receipt_outlined,
              label: 'Bill Number',
              value: bill.billNumber ?? 'Not assigned',
            ),
            _InfoRow(
              icon: Icons.category_outlined,
              label: 'Type',
              value: _getBillTypeLabel(bill.billType),
            ),
            _InfoRow(
              icon: Icons.calendar_month_outlined,
              label: 'Billing Period',
              value: bill.billingPeriod,
            ),
            if (bill.periodStartDate != null && bill.periodEndDate != null)
              _InfoRow(
                icon: Icons.date_range_outlined,
                label: 'Period Dates',
                value:
                    '${_formatDate(bill.periodStartDate!)} - ${_formatDate(bill.periodEndDate!)}',
              ),
            if (bill.dueDate != null)
              _InfoRow(
                icon: Icons.event_outlined,
                label: 'Due Date',
                value: _formatDate(bill.dueDate!),
                valueColor: bill.isOverdue ? AppColors.error : null,
              ),
            if (bill.roomNumber != null)
              _InfoRow(
                icon: Icons.door_front_door_outlined,
                label: 'Room',
                value: 'Room ${bill.roomNumber}',
              ),
            if (bill.tenantName != null)
              _InfoRow(
                icon: Icons.person_outlined,
                label: 'Tenant',
                value: bill.tenantName!,
              ),
            _InfoRow(
              icon: Icons.access_time_outlined,
              label: 'Created',
              value: _formatDateTime(bill.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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

/// Electricity details card.
class _ElectricityDetailsCard extends StatelessWidget {
  final Bill bill;

  const _ElectricityDetailsCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final units =
        (bill.electricityCurrReading ?? 0) - (bill.electricityPrevReading ?? 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: Colors.amber.shade600),
                const SizedBox(width: 8),
                Text(
                  'Electricity Details',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ReadingBox(
                    label: 'Previous',
                    value: bill.electricityPrevReading!.toStringAsFixed(0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, size: 20),
                ),
                Expanded(
                  child: _ReadingBox(
                    label: 'Current',
                    value: bill.electricityCurrReading!.toStringAsFixed(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${units.toStringAsFixed(0)} units @ ${formatCurrency(bill.electricityRateAtBilling ?? 0)}/unit',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.amber.shade900,
                    ),
                  ),
                  Text(
                    formatCurrency(bill.electricityCharges ?? 0),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            // Meter Photo (if present)
            if (bill.meterPhotoPath != null &&
                bill.meterPhotoPath!.isNotEmpty) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  // Show full screen image
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppBar(
                            title: const Text('Meter Photo'),
                            automaticallyImplyLeading: false,
                            actions: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          Image.file(
                            File(bill.meterPhotoPath!),
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(7),
                        ),
                        child: Image.file(
                          File(bill.meterPhotoPath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Meter Photo',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Tap to view full size',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A box showing meter reading value.
class _ReadingBox extends StatelessWidget {
  final String label;
  final String value;

  const _ReadingBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// An info row with icon, label, and value.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tile showing a single payment.
class _PaymentTile extends StatelessWidget {
  final Payment payment;

  const _PaymentTile({required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
          child: Icon(
            _getPaymentModeIcon(payment.paymentMode),
            color: AppColors.success,
            size: 20,
          ),
        ),
        title: Text(
          formatCurrency(payment.amount),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
        subtitle: Text(
          '${_getPaymentModeLabel(payment.paymentMode)} • ${_formatDate(payment.paymentDate)}',
        ),
        trailing: payment.notes != null && payment.notes!.isNotEmpty
            ? Tooltip(
                message: payment.notes!,
                child: const Icon(Icons.note_outlined, size: 18),
              )
            : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData _getPaymentModeIcon(PaymentMode mode) {
    return switch (mode) {
      PaymentMode.cash => Icons.money,
      PaymentMode.upi => Icons.qr_code,
      PaymentMode.bankTransfer => Icons.account_balance,
      PaymentMode.cheque => Icons.edit_note,
      PaymentMode.other => Icons.more_horiz,
    };
  }

  String _getPaymentModeLabel(PaymentMode mode) {
    return switch (mode) {
      PaymentMode.cash => 'Cash',
      PaymentMode.upi => 'UPI',
      PaymentMode.bankTransfer => 'Bank Transfer',
      PaymentMode.cheque => 'Cheque',
      PaymentMode.other => 'Other',
    };
  }
}
