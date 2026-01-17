/// Dashboard screen - main home screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';

/// Main dashboard screen showing financial overview and actionable items.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(unpaidBillsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final unpaidBillsAsync = ref.watch(unpaidBillsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RentKhata'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment_outlined),
            tooltip: 'Reports',
            onPressed: () => context.push('/reports'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh(ref);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financial Overview
              summaryAsync.when(
                data: (summary) => _FinancialOverviewCard(summary: summary),
                loading: () => _buildLoadingCard(140),
                error: (_, __) => _buildErrorCard('Error loading summary'),
              ),
              const SizedBox(height: 16),

              // Stats Row
              summaryAsync.when(
                data: (summary) => Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Properties',
                        value: '${summary.totalProperties}',
                        icon: Icons.home_work_outlined,
                        color: AppColors.primary,
                        onTap: () => context.go('/properties'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Occupancy',
                        value: '${summary.occupancyRate.toStringAsFixed(0)}%',
                        subtitle:
                            '${summary.occupiedRooms}/${summary.totalRooms} rooms',
                        icon: Icons.people_outline,
                        color: AppColors.secondary,
                        onTap: () => context.go('/tenants'),
                      ),
                    ),
                  ],
                ),
                loading: () => Row(
                  children: [
                    Expanded(child: _buildLoadingCard(100)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildLoadingCard(100)),
                  ],
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // Unpaid Bills Section
              _SectionHeader(
                icon: Icons.receipt_long_outlined,
                title: 'Pending Bills',
                count: unpaidBillsAsync.whenData((b) => b.length).value,
              ),
              const SizedBox(height: 12),
              unpaidBillsAsync.when(
                data: (bills) => bills.isEmpty
                    ? _EmptyState(
                        icon: Icons.check_circle_outline,
                        message: 'All bills are paid!',
                        color: AppColors.success,
                      )
                    : Column(
                        children: bills
                            .take(5) // Show top 5 unpaid bills
                            .map((bill) => _BillCard(bill: bill))
                            .toList(),
                      ),
                loading: () => _buildLoadingCard(200),
                error: (e, _) => _buildErrorCard('Error loading bills'),
              ),

              // See all link if more than 5 bills
              unpaidBillsAsync.when(
                data: (bills) => bills.length > 5
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: TextButton(
                            onPressed: () => context.push('/reports'),
                            child: Text(
                              'See all ${bills.length} pending bills →',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _showQuickActions(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
      ),
    );
  }

  Widget _buildLoadingCard(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(message, style: TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: const Text('Add Property'),
              onTap: () {
                Navigator.pop(context);
                context.push('/properties/add');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_add_outlined,
                  color: AppColors.secondary,
                ),
              ),
              title: const Text('Add Tenant'),
              onTap: () {
                Navigator.pop(context);
                context.push('/tenants/add');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.warning,
                ),
              ),
              title: const Text('Create Bill'),
              subtitle: const Text('Go to a room to create bills'),
              onTap: () {
                Navigator.pop(context);
                context.push('/properties');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ============ Components ============

class _FinancialOverviewCard extends StatelessWidget {
  final DashboardSummary summary;

  const _FinancialOverviewCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This Month',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getCollectionColor(
                      summary.collectionRate,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${summary.collectionRate.toStringAsFixed(0)}% collected',
                    style: TextStyle(
                      color: _getCollectionColor(summary.collectionRate),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _AmountDisplay(
                    label: 'Collected',
                    amount: summary.totalCollected,
                    color: AppColors.moneyReceived,
                    icon: Icons.arrow_downward,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.surfaceVariant,
                ),
                Expanded(
                  child: _AmountDisplay(
                    label: 'Pending',
                    amount: summary.totalDue,
                    color: summary.overdueBillCount > 0
                        ? AppColors.moneyOverdue
                        : AppColors.moneyPending,
                    icon: Icons.schedule,
                  ),
                ),
              ],
            ),
            if (summary.overdueBillCount > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      size: 18,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${summary.overdueBillCount} overdue bill${summary.overdueBillCount > 1 ? 's' : ''} need attention',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCollectionColor(double rate) {
    if (rate >= 80) return AppColors.success;
    if (rate >= 50) return AppColors.warning;
    return AppColors.error;
  }
}

class _AmountDisplay extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _AmountDisplay({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatCurrency(amount),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 24),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;

  const _SectionHeader({required this.icon, required this.title, this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (count != null && count! > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _BillCard extends ConsumerWidget {
  final Bill bill;

  const _BillCard({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd MMM');
    final isOverdue = bill.isOverdue;
    final statusColor = isOverdue ? AppColors.error : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.push('/rooms/${bill.occupancyId}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Bill info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bill.tenantName ?? 'Tenant',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isOverdue)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'OVERDUE',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_billTypeLabel(bill.billType)} • ${bill.billingPeriod}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Room ${bill.roomNumber ?? 'N/A'} • ${bill.propertyName ?? 'Property'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(bill.pendingAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  if (bill.dueDate != null)
                    Text(
                      'Due ${dateFormat.format(bill.dueDate!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _billTypeLabel(BillType type) {
    switch (type) {
      case BillType.rent:
        return 'Rent';
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
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(icon, size: 48, color: color.withValues(alpha: 0.7)),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
