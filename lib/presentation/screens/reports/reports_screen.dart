/// Reports screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/payment.dart';
import '../../../services/share_service.dart';
import '../../../services/invoice_pdf_service.dart';
import '../billing/record_payment_sheet.dart';

/// Reports screen showing bills and payment history.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Unpaid Bills'),
            Tab(text: 'All Bills'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_UnpaidBillsTab(), _AllBillsTab()],
      ),
    );
  }
}

class _UnpaidBillsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpaidAsync = ref.watch(unpaidBillsProvider);

    return unpaidAsync.when(
      data: (bills) => bills.isEmpty
          ? _buildEmptyState(
              context,
              'No unpaid bills',
              Icons.check_circle_outline,
            )
          : _buildBillsList(context, bills),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.success),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildBillsList(BuildContext context, List<Bill> bills) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];
        return _BillCard(bill: bill);
      },
    );
  }
}

class _AllBillsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsProvider);

    return billsAsync.when(
      data: (bills) => bills.isEmpty
          ? _buildEmptyState(
              context,
              'No bills yet',
              Icons.receipt_long_outlined,
            )
          : _buildBillsList(context, bills),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildBillsList(BuildContext context, List<Bill> bills) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];
        return _BillCard(bill: bill);
      },
    );
  }
}

class _BillCard extends ConsumerWidget {
  final Bill bill;

  const _BillCard({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = bill.isFullyPaid
        ? AppColors.success
        : bill.isOverdue
        ? AppColors.error
        : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getBillTypeColor(
                      bill.billType,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getBillTypeIcon(bill.billType),
                    color: _getBillTypeColor(bill.billType),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bill.billType.name.toUpperCase()} - ${bill.billingPeriod}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (bill.tenantName != null)
                        Text(
                          bill.tenantName!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      if (bill.roomNumber != null)
                        Text(
                          '${bill.propertyName ?? ''} - Room ${bill.roomNumber}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.onSurfaceVariant.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                        ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bill.isFullyPaid
                        ? 'Paid'
                        : bill.isOverdue
                        ? 'Overdue'
                        : 'Pending',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            // Amount row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      formatCurrency(bill.amount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (!bill.isFullyPaid)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Pending',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        formatCurrency(bill.pendingAmount),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                // Share menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  tooltip: 'Share',
                  onSelected: (value) {
                    HapticFeedback.lightImpact();
                    _handleShare(context, ref, bill, value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'whatsapp',
                      child: Row(
                        children: [
                          Icon(Icons.chat, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text('Send via WhatsApp'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'pdf',
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Generate PDF'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showBillDetails(context, ref, bill);
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View'),
                ),
                if (!bill.isFullyPaid) ...[
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _showRecordPayment(context, bill);
                    },
                    icon: const Icon(Icons.payment, size: 18),
                    label: const Text('Record Payment'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBillDetails(BuildContext context, WidgetRef ref, Bill bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _BillDetailsSheet(bill: bill),
    );
  }

  void _showRecordPayment(BuildContext context, Bill bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RecordPaymentSheet(bill: bill),
    );
  }

  void _handleShare(
    BuildContext context,
    WidgetRef ref,
    Bill bill,
    String action,
  ) async {
    final tenantName = bill.tenantName ?? 'Tenant';
    final amount = formatCurrency(bill.pendingAmount);
    final period = bill.billingPeriod;
    final shareService = ShareService();

    if (action == 'whatsapp') {
      // Build WhatsApp message
      final message = bill.isFullyPaid
          ? 'Payment received! Receipt for $period - ${formatCurrency(bill.paidAmount)}. Thank you!'
          : 'Rent Due: $amount for $period. Room ${bill.roomNumber ?? ""}. Please pay at your earliest convenience.';

      // Try WhatsApp first, fall back to clipboard
      final success = await shareService.shareToWhatsApp(message: message);
      if (!success && context.mounted) {
        Clipboard.setData(ClipboardData(text: message));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'WhatsApp not available. Message copied to clipboard!',
            ),
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening WhatsApp for $tenantName...')),
        );
      }
    } else if (action == 'pdf') {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Generating PDF...')));
      }

      try {
        // Get landlord info
        final landlord = await ref.read(landlordProvider.future);
        final pdfService = InvoicePdfService();

        // Generate PDF
        final pdfFile = await pdfService.generateInvoice(
          bill: bill,
          landlordName: landlord?.name ?? 'Landlord',
          landlordPhone: landlord?.phone ?? '',
          landlordUpiId: landlord?.upiId,
        );

        // Share the PDF
        if (context.mounted) {
          await pdfService.sharePdf(pdfFile, 'Invoice - $period');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
        }
      }
    }
  }

  IconData _getBillTypeIcon(BillType type) {
    switch (type) {
      case BillType.rent:
        return Icons.home_outlined;
      case BillType.electricity:
        return Icons.bolt_outlined;
      case BillType.water:
        return Icons.water_drop_outlined;
      case BillType.maintenance:
        return Icons.build_outlined;
      case BillType.other:
        return Icons.receipt_long_outlined;
    }
  }

  Color _getBillTypeColor(BillType type) {
    switch (type) {
      case BillType.rent:
        return AppColors.primary;
      case BillType.electricity:
        return Colors.amber.shade700;
      case BillType.water:
        return Colors.blue;
      case BillType.maintenance:
        return Colors.orange;
      case BillType.other:
        return AppColors.secondary;
    }
  }
}

/// Bottom sheet showing bill details with payments list and edit/delete options
class _BillDetailsSheet extends ConsumerWidget {
  final Bill bill;

  const _BillDetailsSheet({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsForBillProvider(bill.id));

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${bill.billType.name.toUpperCase()} Bill',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Bill Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bill Details',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _InfoRow('Period', bill.billingPeriod),
                          if (bill.roomNumber != null)
                            _InfoRow('Room', bill.roomNumber!),
                          if (bill.tenantName != null)
                            _InfoRow('Tenant', bill.tenantName!),
                          const Divider(),
                          _InfoRow('Total Amount', formatCurrency(bill.amount)),
                          _InfoRow(
                            'Paid',
                            formatCurrency(bill.paidAmount),
                            color: AppColors.success,
                          ),
                          _InfoRow(
                            'Pending',
                            formatCurrency(bill.pendingAmount),
                            color: bill.pendingAmount > 0
                                ? AppColors.error
                                : AppColors.success,
                          ),
                          if (bill.electricityPrevReading != null) ...[
                            const Divider(),
                            _InfoRow(
                              'Previous Reading',
                              bill.electricityPrevReading!.toStringAsFixed(0),
                            ),
                            _InfoRow(
                              'Current Reading',
                              bill.electricityCurrReading?.toStringAsFixed(0) ??
                                  'N/A',
                            ),
                            _InfoRow(
                              'Units Consumed',
                              '${((bill.electricityCurrReading ?? 0) - (bill.electricityPrevReading ?? 0)).toStringAsFixed(0)}',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payments Section
                  Text(
                    'Payments',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  paymentsAsync.when(
                    data: (payments) {
                      if (payments.isEmpty) {
                        return Card(
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
                                    'No payments recorded yet',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: payments
                            .map(
                              (payment) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.success
                                        .withValues(alpha: 0.1),
                                    child: const Icon(
                                      Icons.check,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  title: Text(formatCurrency(payment.amount)),
                                  subtitle: Text(
                                    '${payment.paymentMode.name.toUpperCase()} • ${_formatDate(payment.paymentDate)}',
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (action) {
                                      if (action == 'edit') {
                                        _editPayment(context, ref, payment);
                                      } else if (action == 'delete') {
                                        _deletePayment(context, ref, payment);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 20),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
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

  void _editPayment(BuildContext context, WidgetRef ref, Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          _EditPaymentSheet(payment: payment, billId: bill.id),
    );
  }

  void _deletePayment(
    BuildContext context,
    WidgetRef ref,
    Payment payment,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment?'),
        content: Text(
          'Delete ${formatCurrency(payment.amount)} payment from ${_formatDate(payment.paymentDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repo = ref.read(billingRepositoryProvider);
      await repo.deletePayment(payment.id);
      ref.invalidate(paymentsForBillProvider(bill.id));
      ref.invalidate(billsStreamProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment deleted')));
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoRow(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for editing a payment
class _EditPaymentSheet extends ConsumerStatefulWidget {
  final Payment payment;
  final int billId;

  const _EditPaymentSheet({required this.payment, required this.billId});

  @override
  ConsumerState<_EditPaymentSheet> createState() => _EditPaymentSheetState();
}

class _EditPaymentSheetState extends ConsumerState<_EditPaymentSheet> {
  late final TextEditingController _amountController;
  late PaymentMode _selectedMode;
  late DateTime _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.payment.amount.toStringAsFixed(0),
    );
    _selectedMode = widget.payment.paymentMode;
    _selectedDate = widget.payment.paymentDate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Payment',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount (₹)',
              prefixIcon: Icon(Icons.currency_rupee),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<PaymentMode>(
            value: _selectedMode,
            decoration: const InputDecoration(
              labelText: 'Payment Mode',
              prefixIcon: Icon(Icons.payment),
            ),
            items: PaymentMode.values
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: Text(mode.name.toUpperCase()),
                  ),
                )
                .toList(),
            onChanged: (mode) => setState(() => _selectedMode = mode!),
          ),
          const SizedBox(height: 16),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: const Text('Payment Date'),
            subtitle: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _isLoading ? null : _savePayment,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _savePayment() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final repo = ref.read(billingRepositoryProvider);
    await repo.updatePayment(
      paymentId: widget.payment.id,
      amount: amount,
      paymentMode: _selectedMode,
      paymentDate: _selectedDate,
    );

    ref.invalidate(paymentsForBillProvider(widget.billId));
    ref.invalidate(billsStreamProvider);
    ref.invalidate(dashboardSummaryProvider);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment updated!')));
    }
  }
}
