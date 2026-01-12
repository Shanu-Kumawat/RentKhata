/// Reports screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
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
        children: [
          _UnpaidBillsTab(),
          _AllBillsTab(),
        ],
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
          ? _buildEmptyState(context, 'No unpaid bills', Icons.check_circle_outline)
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
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
          ? _buildEmptyState(context, 'No bills yet', Icons.receipt_long_outlined)
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
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
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

class _BillCard extends StatelessWidget {
  final Bill bill;

  const _BillCard({required this.bill});

  @override
  Widget build(BuildContext context) {
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
                    color: _getBillTypeColor(bill.billType).withOpacity(0.1),
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
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      if (bill.roomNumber != null)
                        Text(
                          '${bill.propertyName ?? ''} - Room ${bill.roomNumber}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showBillDetails(context, bill),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View'),
                ),
                if (!bill.isFullyPaid) ...[
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _showRecordPayment(context, bill),
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

  void _showBillDetails(BuildContext context, Bill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${bill.billType.name.toUpperCase()} Bill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Period: ${bill.billingPeriod}'),
            if (bill.roomNumber != null)
              Text('Room: ${bill.roomNumber}'),
            const SizedBox(height: 8),
            Text('Amount: ${formatCurrency(bill.amount)}'),
            Text('Paid: ${formatCurrency(bill.paidAmount)}'),
            Text('Pending: ${formatCurrency(bill.pendingAmount)}'),
            if (bill.electricityPrevReading != null) ...[
              const SizedBox(height: 8),
              Text('Previous Reading: ${bill.electricityPrevReading}'),
              Text('Current Reading: ${bill.electricityCurrReading}'),
              Text('Units: ${(bill.electricityCurrReading ?? 0) - (bill.electricityPrevReading ?? 0)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRecordPayment(BuildContext context, Bill bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RecordPaymentSheet(bill: bill),
    );
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
