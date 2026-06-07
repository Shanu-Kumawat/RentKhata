/// Reports screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/animated_pending_graphic.dart';
import 'widgets/animated_history_graphic.dart';
import 'widgets/animated_expense_graphic.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/payment.dart';
import 'package:printing/printing.dart';
import '../../../services/share_service.dart';
import '../../../services/invoice_pdf_service.dart';
import '../../../core/utils/l10n_helpers.dart';
import '../billing/record_payment_sheet.dart';
import '../../widgets/bouncing_scale_wrapper.dart';
import '../../widgets/staggered_fade_in.dart';
import '../../widgets/animated_counter_text.dart';
import '../../../application/providers/expense_providers.dart';
import 'widgets/add_expense_sheet.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

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
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final year = ref.watch(reportsFinancialYearProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: year,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      ref
                          .read(reportsFinancialYearProvider.notifier)
                          .setYear(newValue);
                    }
                  },
                  items: List.generate(5, (index) {
                    final y = DateTime.now().year - 2 + index;
                    return DropdownMenuItem(
                      value: y,
                      child: Text('FY $y-${(y + 1).toString().substring(2)}'),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: TabBar(
            controller: _tabController,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            tabs: [
              Tab(
                text: l10n.overview,
                icon: const Icon(Icons.bar_chart_rounded, size: 16),
              ),
              Tab(
                text: l10n.pending,
                icon: const Icon(Icons.schedule_rounded, size: 16),
              ),
              Tab(
                text: l10n.history,
                icon: const Icon(Icons.history_rounded, size: 16),
              ),
              Tab(
                text: l10n.expenses,
                icon: const Icon(Icons.receipt_long_rounded, size: 16),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          (_tabController.index == 0 || _tabController.index == 3)
          ? FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.mediumImpact();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const AddExpenseSheet(),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addExpense),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OverviewTab(),
          _PendingBillsTab(),
          _HistoryTab(),
          _ExpensesTab(),
        ],
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
    final year = ref.watch(reportsFinancialYearProvider);
    final financialsAsync = ref.watch(yearlyFinancialsProvider);
    final billsAsync = ref.watch(billsByFinancialYearProvider);
    final unpaidAsync = ref.watch(unpaidBillsProvider);
    final expensesAsync = ref.watch(expensesProvider);

    final yearStr = '$year-${(year + 1).toString().substring(2)}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StaggeredFadeIn(
                delay: const Duration(milliseconds: 0),
                child: Text(
                  AppLocalizations.of(context)!.financialSummary,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Summary Cards Grid
          StaggeredFadeIn(
            delay: const Duration(milliseconds: 50),
            child: financialsAsync.when(
              data: (data) => expensesAsync.when(
                data: (allExpenses) => unpaidAsync.when(
                  data: (unpaidBills) {
                    final startDate = DateTime(year, 4, 1);
                    final endDate = DateTime(year + 1, 3, 31, 23, 59, 59);
                    final unpaidInYear = unpaidBills.where((b) {
                      final bStart = b.periodStartDate ?? b.createdAt;
                      final bEnd = b.periodEndDate ?? b.createdAt;
                      return bStart.isBefore(endDate) &&
                          bEnd.isAfter(startDate);
                    }).toList();

                    final overdueAmount = unpaidInYear
                        .where((b) => b.isOverdue)
                        .fold(0.0, (sum, b) => sum + b.pendingAmount);
                    final overdueCount = unpaidInYear
                        .where((b) => b.isOverdue)
                        .length;

                    final expensesInYear = allExpenses.where((e) {
                      return e.date.isBefore(endDate) &&
                          e.date.isAfter(startDate);
                    }).toList();
                    final totalExpenses = expensesInYear.fold(
                      0.0,
                      (sum, e) => sum + e.amount,
                    );
                    final netProfit = data.collected - totalExpenses;
                    final isProfitable = netProfit >= 0;

                    return Column(
                      children: [
                        // ── Net Profit Hero Card (full width) ──
                        _NetProfitCard(
                          netProfit: netProfit,
                          isProfitable: isProfitable,
                          yearStr: yearStr,
                        ),
                        const SizedBox(height: 12),
                        // Row 1: Outstanding & Overdue
                        Row(
                          children: [
                            Expanded(
                              child: _SummaryCard(
                                label: AppLocalizations.of(
                                  context,
                                )!.outstanding,
                                amount: data.pending,
                                icon: Icons.schedule_rounded,
                                accentColor: AppColors.warning,
                                subtitle:
                                    '${unpaidBills.length} ${unpaidBills.length == 1 ? 'bill' : 'bills'}',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SummaryCard(
                                label: AppLocalizations.of(context)!.overdue,
                                amount: overdueAmount,
                                icon: Icons.warning_amber_rounded,
                                accentColor: AppColors.error,
                                subtitle: overdueCount > 0
                                    ? AppLocalizations.of(
                                        context,
                                      )!.urgent(overdueCount)
                                    : AppLocalizations.of(context)!.allOnTime,
                                isUrgent: overdueCount > 0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Row 2: Collected & Expenses
                        Row(
                          children: [
                            Expanded(
                              child: _SummaryCard(
                                label: AppLocalizations.of(context)!.collected,
                                amount: data.collected,
                                icon: Icons.arrow_downward_rounded,
                                accentColor: AppColors.success,
                                subtitle: 'FY $yearStr',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SummaryCard(
                                label: AppLocalizations.of(context)!.expenses,
                                amount: totalExpenses,
                                icon: Icons.upload_rounded,
                                accentColor: Colors.orange,
                                subtitle: AppLocalizations.of(
                                  context,
                                )!.items(expensesInYear.length),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingCards(),
                  error: (_, __) => _buildErrorCard(
                    AppLocalizations.of(context)!.errorLoadingBills,
                  ),
                ),
                loading: () => _buildLoadingCards(),
                error: (_, __) => _buildErrorCard(
                  AppLocalizations.of(context)!.errorLoadingExpenses,
                ),
              ),
              loading: () => _buildLoadingCards(),
              error: (_, __) => _buildErrorCard(
                AppLocalizations.of(context)!.errorLoadingFinancials,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bills by Type
          StaggeredFadeIn(
            delay: const Duration(milliseconds: 200),
            child: Text(
              AppLocalizations.of(context)!.billsByType,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),

          StaggeredFadeIn(
            delay: const Duration(milliseconds: 300),
            child: billsAsync.when(
              data: (bills) {
                final typeBreakdown =
                    <BillType, ({int count, double amount})>{};
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

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
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

/// Full-width Net Profit hero card.
class _NetProfitCard extends StatelessWidget {
  final double netProfit;
  final bool isProfitable;
  final String yearStr;

  const _NetProfitCard({
    required this.netProfit,
    required this.isProfitable,
    required this.yearStr,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = isProfitable
        ? const Color(0xFF1DB954)
        : const Color(0xFFE53935);

    return BouncingScaleWrapper(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isProfitable
                ? [const Color(0xFF0D7A3E), const Color(0xFF1DB954)]
                : [const Color(0xFFA31515), const Color(0xFFE53935)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(26),
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
                      isProfitable ? 'NET PROFIT' : 'NET LOSS',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Use CounterFormat.raw to avoid double ₹
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: netProfit.abs()),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                      builder: (_, val, __) {
                        final formatter = NumberFormat.currency(
                          locale: 'en_IN',
                          symbol: '₹',
                          decimalDigits: 0,
                        );
                        return Text(
                          formatter.format(val),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FY $yearStr',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isProfitable
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium summary card with accent border.
class _SummaryCard extends StatelessWidget {
  final String? label;
  final double? amount;
  final IconData? icon;
  final Color? accentColor;
  final String? subtitle;
  final bool isUrgent;
  final bool isLoading;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.accentColor,
    this.subtitle,
    this.isUrgent = false,
  }) : isLoading = false;

  const _SummaryCard.loading()
    : label = null,
      amount = null,
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
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 80,
              height: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return BouncingScaleWrapper(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
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
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: accentColor!.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 14, color: accentColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedCounterText(
                  value: amount!,
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
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
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
          if (icon == Icons.check_circle_outline)
            const AnimatedPendingGraphic()
          else if (icon == Icons.history_outlined)
            const AnimatedHistoryGraphic()
          else
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),

          const SizedBox(height: 24),
          Text(message, style: Theme.of(context).textTheme.titleMedium)
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
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
    // Filter History by the selected Financial Year
    final billsAsync = ref.watch(billsByFinancialYearProvider);

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
          if (icon == Icons.history_outlined)
            const AnimatedHistoryGraphic()
          else
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),

          const SizedBox(height: 24),
          Text(message, style: Theme.of(context).textTheme.titleMedium)
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
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

    // Calculate days until due or overdue
    String? dueInfo;
    if (bill.dueDate != null && !bill.isFullyPaid) {
      final daysUntil = bill.dueDate!.difference(DateTime.now()).inDays;
      if (daysUntil < 0) {
        dueInfo = '${-daysUntil}d late';
      } else if (daysUntil == 0) {
        dueInfo = 'Due today';
      } else if (daysUntil == 1) {
        dueInfo = 'Due tmrw';
      } else if (daysUntil <= 7) {
        dueInfo = 'Due in ${daysUntil}d';
      }
    }

    final double progress = bill.amount > 0
        ? (bill.paidAmount / bill.amount).clamp(0.0, 1.0)
        : 0.0;

    return BouncingScaleWrapper(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getBillTypeColor(
                          bill.billType,
                        ).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getBillTypeIcon(bill.billType),
                        color: _getBillTypeColor(bill.billType),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill.tenantName ?? 'No Tenant',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${bill.propertyName ?? 'Unit'} • Room ${bill.roomNumber ?? '—'}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        bill.isFullyPaid
                            ? 'PAID'
                            : bill.isOverdue
                            ? 'OVERDUE'
                            : 'PENDING',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- PROGRESS & AMOUNTS ---
                if (!bill.isFullyPaid && bill.paidAmount > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Billed',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatCurrency(bill.amount),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Pending',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedCounterText(
                            value: bill.pendingAmount,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: statusColor,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (dueInfo != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dueInfo,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill.isFullyPaid ? 'Amount Settled' : 'Amount Due',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (dueInfo != null) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 12,
                                    color: AppColors.error,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dueInfo,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      AnimatedCounterText(
                        value: bill.isFullyPaid
                            ? bill.paidAmount
                            : bill.pendingAmount,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: bill.isFullyPaid
                              ? AppColors.success
                              : theme.colorScheme.onSurface,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 24),

                // Dashed Divider Built Properly without span
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                        (constraints.constrainWidth() / 10).floor(),
                        (index) => SizedBox(
                          width: 5,
                          height: 1.5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // --- ACTION BAR ---
                Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      tooltip: 'Share',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (value) {
                        HapticFeedback.lightImpact();
                        _handleShare(context, ref, bill, value);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'text',
                          child: Row(
                            children: [
                              Icon(
                                Icons.message_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text('Share Text'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'pdf',
                          child: Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf_outlined,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text('PDF Invoice'),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showBillDetails(context, ref, bill);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),

                    if (!bill.isFullyPaid) ...[
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          _showRecordPayment(context, bill);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: statusColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.payments_outlined, size: 18),
                        label: const Text(
                          'Pay',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
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

    if (action == 'text' || action == 'whatsapp') {
      final message = bill.isFullyPaid
          ? 'Payment received! Receipt for $period - ${formatCurrency(bill.paidAmount)}. Thank you!'
          : 'Rent Due: $amount for $period. Room ${bill.roomNumber ?? ""}. Please pay at your earliest convenience.';

      await shareService.shareText(text: message);
      await ref.read(billingRepositoryProvider).markBillAsSent(bill.id);
      // We don't get success check from native share, assuming triggered
      if (context.mounted) {
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
          final bytes = await pdfFile.readAsBytes();
          await Printing.sharePdf(
            bytes: bytes,
            filename: pdfFile.path.split('/').last,
          );
          await ref.read(billingRepositoryProvider).markBillAsSent(bill.id);
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
                      '${getBillTypeLabel(AppLocalizations.of(context)!, bill.billType).toUpperCase()} Bill',
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
                                    '${getPaymentModeLabel(AppLocalizations.of(context)!, payment.paymentMode).toUpperCase()} • ${DateFormat('dd MMM yyyy').format(payment.paymentDate)}',
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
                    child: Text(
                      getPaymentModeLabel(
                        AppLocalizations.of(context)!,
                        mode,
                      ).toUpperCase(),
                    ),
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

// ═══════════════════════════════════════════════════════════════════════════
// Expenses Tab
// ═══════════════════════════════════════════════════════════════════════════

class _ExpensesTab extends ConsumerWidget {
  const _ExpensesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final year = ref.watch(reportsFinancialYearProvider);

    return expensesAsync.when(
      data: (expenses) {
        final startDate = DateTime(year, 4, 1);
        final endDate = DateTime(year + 1, 3, 31, 23, 59, 59);

        final filteredExpenses = expenses.where((e) {
          return e.date.isBefore(endDate) && e.date.isAfter(startDate);
        }).toList();

        if (filteredExpenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnimatedExpenseGraphic(),
                const SizedBox(height: 24),
                Text(
                      'No expenses recorded',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
              ],
            ),
          );
        }

        filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // padding for FAB
          itemCount: filteredExpenses.length,
          itemBuilder: (context, index) {
            final expense = filteredExpenses[index];
            return StaggeredFadeIn(
              delay: Duration(milliseconds: index * 50),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                    child: Icon(
                      Icons.outbound,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  title: Text(
                    expense.category.name[0].toUpperCase() +
                        expense.category.name.substring(1),
                  ),
                  subtitle: Text(
                    '${DateFormat('dd MMM').format(expense.date)}${expense.description != null ? ' - ${expense.description}' : ''}',
                  ),
                  trailing: Text(
                    formatCurrency(expense.amount),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
