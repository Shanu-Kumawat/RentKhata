/// Reports screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

/// Reports screen showing financial overview and bill management.
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
    _tabController = TabController(length: 3, vsync: this);
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
            Tab(text: 'Overview'),
            Tab(text: 'Pending'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_OverviewTab(), _PendingBillsTab(), _HistoryTab()],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Overview Tab
// ═══════════════════════════════════════════════════════════════════════════

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financialsAsync = ref.watch(filteredFinancialsProvider);
    final unpaidAsync = ref.watch(unpaidBillsProvider);
    final billsAsync = ref.watch(billsProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial Summary Header
          Text(
            'Financial Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Summary Cards Grid
          financialsAsync.when(
            data: (data) => unpaidAsync.when(
              data: (unpaidBills) {
                final overdueAmount = unpaidBills
                    .where((b) => b.isOverdue)
                    .fold(0.0, (sum, b) => sum + b.pendingAmount);
                final overdueCount = unpaidBills
                    .where((b) => b.isOverdue)
                    .length;

                return Column(
                  children: [
                    // Row 1: Outstanding & Overdue
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Outstanding',
                            value: formatCurrency(data.pending),
                            icon: Icons.schedule_rounded,
                            accentColor: AppColors.warning,
                            subtitle:
                                '${unpaidBills.length} ${unpaidBills.length == 1 ? 'bill' : 'bills'}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Overdue',
                            value: formatCurrency(overdueAmount),
                            icon: Icons.warning_amber_rounded,
                            accentColor: AppColors.error,
                            subtitle: overdueCount > 0
                                ? '$overdueCount urgent'
                                : 'All on time',
                            isUrgent: overdueCount > 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Row 2: Collected & Rate
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Collected',
                            value: formatCurrency(data.collected),
                            icon: Icons.arrow_downward_rounded,
                            accentColor: AppColors.success,
                            subtitle: 'This month',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Collection Rate',
                            value: (data.collected + data.pending) > 0
                                ? '${((data.collected / (data.collected + data.pending)) * 100).toStringAsFixed(0)}%'
                                : '—',
                            icon: Icons.trending_up_rounded,
                            accentColor: AppColors.info,
                            subtitle: 'This month',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => _buildLoadingCards(),
              error: (_, __) => _buildErrorCard('Error loading bills'),
            ),
            loading: () => _buildLoadingCards(),
            error: (_, __) => _buildErrorCard('Error loading financials'),
          ),

          const SizedBox(height: 24),

          // Bills by Type
          Text(
            'Bills by Type',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          billsAsync.when(
            data: (bills) {
              final typeBreakdown = <BillType, ({int count, double amount})>{};
              for (final bill in bills) {
                final current = typeBreakdown[bill.billType];
                typeBreakdown[bill.billType] = (
                  count: (current?.count ?? 0) + 1,
                  amount: (current?.amount ?? 0) + bill.amount,
                );
              }

              if (typeBreakdown.isEmpty) {
                return _buildEmptyCard(
                  context,
                  'No bills created yet',
                  Icons.receipt_long_outlined,
                );
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: BillType.values
                        .where((type) => typeBreakdown.containsKey(type))
                        .map((type) {
                          final data = typeBreakdown[type]!;
                          return _BillTypeRow(
                            type: type,
                            count: data.count,
                            amount: data.amount,
                          );
                        })
                        .toList(),
                  ),
                ),
              );
            },
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, __) => _buildErrorCard('Error loading bills'),
          ),

          const SizedBox(height: 24),

          // Overdue Bills Quick List
          Text(
            'Needs Attention',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          unpaidAsync.when(
            data: (bills) {
              final overdueBills = bills.where((b) => b.isOverdue).toList();
              if (overdueBills.isEmpty) {
                return _buildEmptyCard(
                  context,
                  'No overdue bills! 🎉',
                  Icons.check_circle_outline,
                  color: AppColors.success,
                );
              }

              return Column(
                children: overdueBills.take(3).map((bill) {
                  return _CompactBillTile(bill: bill);
                }).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _SummaryCard.loading()),
            const SizedBox(width: 12),
            Expanded(child: _SummaryCard.loading()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _SummaryCard.loading()),
            const SizedBox(width: 12),
            Expanded(child: _SummaryCard.loading()),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(
    BuildContext context,
    String message,
    IconData icon, {
    Color? color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}

/// Premium summary card with accent border.
class _SummaryCard extends StatelessWidget {
  final String? label;
  final String? value;
  final IconData? icon;
  final Color? accentColor;
  final String? subtitle;
  final bool isUrgent;
  final bool isLoading;

  const _SummaryCard({
    required String this.label,
    required String this.value,
    required IconData this.icon,
    required Color this.accentColor,
    this.subtitle,
    this.isUrgent = false,
  }) : isLoading = false;

  const _SummaryCard.loading()
    : label = null,
      value = null,
      icon = null,
      accentColor = null,
      subtitle = null,
      isUrgent = false,
      isLoading = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 80,
              height: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: accentColor!, width: 4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      label!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onSurface.withAlpha(150),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor!.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 14, color: accentColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isUrgent ? accentColor : theme.colorScheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Bill type breakdown row.
class _BillTypeRow extends StatelessWidget {
  final BillType type;
  final int count;
  final double amount;

  const _BillTypeRow({
    required this.type,
    required this.count,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(type);
    final icon = _getTypeIcon(type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.name[0].toUpperCase() + type.name.substring(1),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '$count ${count == 1 ? 'bill' : 'bills'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatCurrency(amount),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(BillType type) => switch (type) {
    BillType.rent => Icons.home_outlined,
    BillType.electricity => Icons.bolt_outlined,
    BillType.water => Icons.water_drop_outlined,
    BillType.maintenance => Icons.build_outlined,
    BillType.other => Icons.receipt_long_outlined,
  };

  Color _getTypeColor(BillType type) => switch (type) {
    BillType.rent => AppColors.primary,
    BillType.electricity => Colors.amber.shade700,
    BillType.water => Colors.blue,
    BillType.maintenance => Colors.orange,
    BillType.other => AppColors.secondary,
  };
}

/// Compact bill tile for overview.
class _CompactBillTile extends StatelessWidget {
  final Bill bill;

  const _CompactBillTile({required this.bill});

  @override
  Widget build(BuildContext context) {
    final daysOverdue = bill.dueDate != null
        ? DateTime.now().difference(bill.dueDate!).inDays
        : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          bill.tenantName ?? 'Room ${bill.roomNumber}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          daysOverdue > 0
              ? '$daysOverdue days overdue • ${bill.billType.name}'
              : bill.billType.name,
          style: TextStyle(color: AppColors.errorText, fontSize: 12),
        ),
        trailing: Text(
          formatCurrency(bill.pendingAmount),
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Pending Bills Tab
// ═══════════════════════════════════════════════════════════════════════════

class _PendingBillsTab extends ConsumerWidget {
  const _PendingBillsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpaidAsync = ref.watch(unpaidBillsProvider);

    return unpaidAsync.when(
      data: (bills) => bills.isEmpty
          ? _buildEmptyState(
              context,
              'All bills are paid! 🎉',
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
    // Sort: overdue first, then by due date
    final sorted = List<Bill>.from(bills)
      ..sort((a, b) {
        if (a.isOverdue && !b.isOverdue) return -1;
        if (!a.isOverdue && b.isOverdue) return 1;
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }
        return 0;
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) => _PremiumBillCard(bill: sorted[index]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// History Tab (Paid Bills)
// ═══════════════════════════════════════════════════════════════════════════

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsProvider);

    return billsAsync.when(
      data: (bills) {
        final paidBills = bills.where((b) => b.isFullyPaid).toList();
        if (paidBills.isEmpty) {
          return _buildEmptyState(
            context,
            'No paid bills yet',
            Icons.history_outlined,
          );
        }
        return _buildBillsList(context, paidBills);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildBillsList(BuildContext context, List<Bill> bills) {
    // Sort by most recent first
    final sorted = List<Bill>.from(bills)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) => _PremiumBillCard(bill: sorted[index]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Premium Bill Card (Redesigned)
// ═══════════════════════════════════════════════════════════════════════════

class _PremiumBillCard extends ConsumerWidget {
  final Bill bill;

  const _PremiumBillCard({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusColor = bill.isFullyPaid
        ? AppColors.success
        : bill.isOverdue
        ? AppColors.error
        : AppColors.warning;

    final dateFormat = DateFormat('dd MMM yyyy');

    // Calculate days until due or overdue
    String? dueInfo;
    if (bill.dueDate != null && !bill.isFullyPaid) {
      final daysUntil = bill.dueDate!.difference(DateTime.now()).inDays;
      if (daysUntil < 0) {
        dueInfo = '${-daysUntil} days overdue';
      } else if (daysUntil == 0) {
        dueInfo = 'Due today';
      } else if (daysUntil == 1) {
        dueInfo = 'Due tomorrow';
      } else if (daysUntil <= 7) {
        dueInfo = 'Due in $daysUntil days';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: statusColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bill type icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getBillTypeColor(bill.billType).withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getBillTypeIcon(bill.billType),
                        color: _getBillTypeColor(bill.billType),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title and info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tenant name as title
                          Text(
                            bill.tenantName ?? 'Unknown Tenant',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Room and property
                          Text(
                            '${bill.propertyName ?? 'Property'} • Room ${bill.roomNumber ?? '—'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Bill type chip and bill number
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getBillTypeColor(
                                    bill.billType,
                                  ).withAlpha(20),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  bill.billType.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _getBillTypeColor(bill.billType),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '#${bill.billNumber ?? bill.id}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bill.isFullyPaid
                            ? 'Paid'
                            : bill.isOverdue
                            ? 'Overdue'
                            : 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Period and Due Date row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoColumn(label: 'Period', value: bill.billingPeriod),
                      Container(
                        width: 1,
                        height: 30,
                        color: theme.colorScheme.outline,
                      ),
                      _InfoColumn(
                        label: 'Due Date',
                        value: bill.dueDate != null
                            ? dateFormat.format(bill.dueDate!)
                            : '—',
                        highlight: dueInfo,
                        highlightColor: bill.isOverdue
                            ? AppColors.error
                            : AppColors.warning,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Amount row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            formatCurrency(bill.amount),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration:
                                  bill.paidAmount > 0 && !bill.isFullyPaid
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: bill.paidAmount > 0 && !bill.isFullyPaid
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!bill.isFullyPaid) ...[
                      if (bill.paidAmount > 0)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Paid',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.successText,
                                ),
                              ),
                              Text(
                                formatCurrency(bill.paidAmount),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Pending',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              formatCurrency(bill.pendingAmount),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Fully Paid',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.successText,
                              ),
                            ),
                            Text(
                              formatCurrency(bill.paidAmount),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
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
                              Text('WhatsApp'),
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
                              Text('PDF Invoice'),
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
                      label: const Text('Details'),
                    ),
                    if (!bill.isFullyPaid) ...[
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          _showRecordPayment(context, bill);
                        },
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text('Pay'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
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
    final amount = formatCurrency(bill.pendingAmount);
    final period = bill.billingPeriod;
    final shareService = ShareService();

    if (action == 'whatsapp') {
      final message = bill.isFullyPaid
          ? 'Payment received! Receipt for $period - ${formatCurrency(bill.paidAmount)}. Thank you!'
          : 'Rent Due: $amount for $period. Room ${bill.roomNumber ?? ""}. Please pay at your earliest convenience.';

      final success = await shareService.shareToWhatsApp(message: message);
      if (!success && context.mounted) {
        Clipboard.setData(ClipboardData(text: message));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message copied to clipboard!')),
        );
      }
    } else if (action == 'pdf') {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Generating PDF...')));
      }

      try {
        final landlord = await ref.read(landlordProvider.future);
        final pdfService = InvoicePdfService();
        final pdfFile = await pdfService.generateInvoice(
          bill: bill,
          landlordName: landlord?.name ?? 'Landlord',
          landlordPhone: landlord?.phone ?? '',
          landlordUpiId: landlord?.upiId,
        );
        if (context.mounted) {
          await pdfService.sharePdf(pdfFile, 'Invoice - $period');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  IconData _getBillTypeIcon(BillType type) => switch (type) {
    BillType.rent => Icons.home_outlined,
    BillType.electricity => Icons.bolt_outlined,
    BillType.water => Icons.water_drop_outlined,
    BillType.maintenance => Icons.build_outlined,
    BillType.other => Icons.receipt_long_outlined,
  };

  Color _getBillTypeColor(BillType type) => switch (type) {
    BillType.rent => AppColors.primary,
    BillType.electricity => Colors.amber.shade700,
    BillType.water => Colors.blue,
    BillType.maintenance => Colors.orange,
    BillType.other => AppColors.secondary,
  };
}

/// Info column for period/due date.
class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final String? highlight;
  final Color? highlightColor;

  const _InfoColumn({
    required this.label,
    required this.value,
    this.highlight,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (highlight != null) ...[
          const SizedBox(height: 2),
          Text(
            highlight!,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: highlightColor,
            ),
          ),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Bill Details Sheet (existing, unchanged)
// ═══════════════════════════════════════════════════════════════════════════

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
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
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
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
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
                          _InfoRow('Bill #', bill.billNumber ?? '${bill.id}'),
                          _InfoRow('Period', bill.billingPeriod),
                          if (bill.roomNumber != null)
                            _InfoRow('Room', bill.roomNumber!),
                          if (bill.tenantName != null)
                            _InfoRow('Tenant', bill.tenantName!),
                          if (bill.dueDate != null)
                            _InfoRow(
                              'Due Date',
                              DateFormat('dd MMM yyyy').format(bill.dueDate!),
                            ),
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
                              ((bill.electricityCurrReading ?? 0) -
                                      (bill.electricityPrevReading ?? 0))
                                  .toStringAsFixed(0),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('No payments recorded yet'),
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
                                        .withAlpha(25),
                                    child: const Icon(
                                      Icons.check,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  title: Text(formatCurrency(payment.amount)),
                                  subtitle: Text(
                                    '${payment.paymentMode.name.toUpperCase()} • ${DateFormat('dd MMM yyyy').format(payment.paymentDate)}',
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
        content: Text('Delete ${formatCurrency(payment.amount)} payment?'),
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
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Edit Payment Sheet (existing)
// ═══════════════════════════════════════════════════════════════════════════

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
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<PaymentMode>(
            initialValue: _selectedMode,
            decoration: const InputDecoration(labelText: 'Payment Mode'),
            items: PaymentMode.values
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: Text(mode.name.toUpperCase()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedMode = value);
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Payment Date'),
            subtitle: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(billingRepositoryProvider);
      await repo.updatePayment(
        paymentId: widget.payment.id,
        amount: amount,
        paymentDate: _selectedDate,
        paymentMode: _selectedMode,
      );

      ref.invalidate(paymentsForBillProvider(widget.billId));
      ref.invalidate(billsStreamProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
