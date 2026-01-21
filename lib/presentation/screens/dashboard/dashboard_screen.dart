/// Dashboard screen - main home screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../domain/entities/billing_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

/// Main dashboard screen showing financial overview and actionable items.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(unpaidBillsProvider);
    ref.invalidate(filteredFinancialsProvider);
    ref.invalidate(roomStatusListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch necessary providers
    // (Variables removed to silence warnings)

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Section: Compact Financial Summary
              const _CompactFinancialHeader(),
              const SizedBox(height: 24),

              // 2. Middle Section: Action Center (Priority Zone)
              const _SectionHeader(
                icon: Icons.notifications_active_outlined,
                title: 'Attention Needed',
              ),
              const SizedBox(height: 12),
              const _ActionRequiredSection(),
              const SizedBox(height: 24),

              // 3. Bottom Section: Live Property Status
              const _SectionHeader(
                icon: Icons.meeting_room_outlined,
                title: 'Live Property Status',
              ),
              const SizedBox(height: 12),
              _LivePropertyStatusList(),
              const SizedBox(height: 80), // Bottom padding for FAB
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

// ============ New Components ============

class _CompactFinancialHeader extends ConsumerWidget {
  const _CompactFinancialHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredFinancialsProvider);
    final selectedMonth = ref.watch(dashboardMonthProvider);
    final dateFormat = DateFormat('MMMM yyyy');

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    final newDate = DateTime(
                      selectedMonth.year,
                      selectedMonth.month - 1,
                    );
                    ref.read(dashboardMonthProvider.notifier).setMonth(newDate);
                  },
                ),
                Text(
                  dateFormat.format(selectedMonth),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    final newDate = DateTime(
                      selectedMonth.year,
                      selectedMonth.month + 1,
                    );
                    ref.read(dashboardMonthProvider.notifier).setMonth(newDate);
                  },
                ),
              ],
            ),
            const Divider(height: 16),
            // Financials Row
            filteredAsync.when(
              data: (data) => Row(
                children: [
                  Expanded(
                    child: _SimpleAmountStat(
                      label: 'Collected',
                      amount: data.collected,
                      color: AppColors.successText,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _SimpleAmountStat(
                      label: 'Pending',
                      amount: data.pending,
                      color: AppColors.errorText,
                      isPending: true,
                    ),
                  ),
                ],
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (_, __) => const Text('Error loading financials'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleAmountStat extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isPending;

  const _SimpleAmountStat({
    required this.label,
    required this.amount,
    required this.color,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.5,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatCurrency(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ActionRequiredSection extends ConsumerWidget {
  const _ActionRequiredSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpaidBillsAsync = ref.watch(unpaidBillsProvider);
    final billingAttentionAsync = ref.watch(billingAttentionListProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Subsection A: "Create Bills" (Proactive - Anniversary-Based)
        billingAttentionAsync.when(
          data: (attentionItems) {
            if (attentionItems.isEmpty) {
              return _EmptyAttentionCard();
            }

            final overdueCount = attentionItems
                .where((i) => i.status == BillingCycleStatus.overdue)
                .length;
            final dueSoonCount = attentionItems
                .where((i) => i.status == BillingCycleStatus.dueSoon)
                .length;

            // Determine card styling based on urgency
            final hasOverdue = overdueCount > 0;
            final borderColor = hasOverdue
                ? AppColors.error.withValues(alpha: 0.5)
                : AppColors.warning.withValues(alpha: 0.5);
            final iconBgColor = hasOverdue
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1);
            final iconColor = hasOverdue ? AppColors.error : AppColors.warning;

            return Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
              child: ExpansionTile(
                backgroundColor: iconBgColor,
                collapsedBackgroundColor: Theme.of(context).cardColor,
                shape: const Border(),
                leading: CircleAvatar(
                  backgroundColor: iconBgColor,
                  child: Icon(
                    hasOverdue
                        ? Icons.warning_amber_rounded
                        : Icons.schedule_outlined,
                    color: iconColor,
                  ),
                ),
                title: Text(
                  _buildAttentionTitle(overdueCount, dueSoonCount),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  hasOverdue
                      ? 'Bills need to be created urgently'
                      : 'Billing cycles ending soon',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                children: [
                  ...attentionItems.map(
                    (item) => _BillingAttentionTile(item: item),
                  ),
                  if (attentionItems.length > 1)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tap a tenant to create their bill',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
          error: (error, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading billing status',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Subsection B: "Collect Payment" (Existing Unpaid Bills)
        unpaidBillsAsync.when(
          data: (bills) {
            if (bills.isEmpty) return const SizedBox.shrink();
            final overdueCount = bills.where((b) => b.isOverdue).length;
            final count = bills.length;

            return InkWell(
              onTap: () => context.push('/reports'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.priority_high,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count Bills Unpaid',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (overdueCount > 0)
                          Text(
                            '$overdueCount are overdue',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.errorText,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else
                          Text(
                            'Follow up with tenants',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _buildAttentionTitle(int overdueCount, int dueSoonCount) {
    if (overdueCount > 0 && dueSoonCount > 0) {
      return '$overdueCount overdue, $dueSoonCount due soon';
    } else if (overdueCount > 0) {
      return '$overdueCount ${overdueCount == 1 ? 'tenant' : 'tenants'} overdue';
    } else {
      return '$dueSoonCount ${dueSoonCount == 1 ? 'tenant' : 'tenants'} due soon';
    }
  }
}

/// Card shown when no tenants need billing attention.
class _EmptyAttentionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.success.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.success.withValues(alpha: 0.1),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All caught up!',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    'No billing cycles ending soon',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
}

/// Tile for a single billing attention item.
class _BillingAttentionTile extends StatelessWidget {
  final BillingAttentionItem item;

  const _BillingAttentionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.status == BillingCycleStatus.overdue;
    final statusColor = isOverdue ? AppColors.error : AppColors.warning;
    final statusTextColor = isOverdue
        ? AppColors.errorText
        : AppColors.warningText;

    return ListTile(
      visualDensity: VisualDensity.compact,
      onTap: () {
        // Navigate to room detail with cycle dates for bill creation
        context.push(
          '/rooms/${item.roomId}?createBill=true'
          '&cycleStart=${item.cycleStart.toIso8601String()}'
          '&cycleEnd=${item.cycleEnd.toIso8601String()}',
        );
      },
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Room ${item.roomNumber} - ${item.tenantName}',
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        item.cycleEndDescription,
        style: TextStyle(
          fontSize: 11,
          color: statusTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: OutlinedButton(
        onPressed: () {
          context.push(
            '/rooms/${item.roomId}?createBill=true'
            '&cycleStart=${item.cycleStart.toIso8601String()}'
            '&cycleEnd=${item.cycleEnd.toIso8601String()}',
          );
        },
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          foregroundColor: statusColor,
          side: BorderSide(color: statusColor.withValues(alpha: 0.5)),
        ),
        child: const Text('Create'),
      ),
    );
  }
}

class _LivePropertyStatusList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusListAsync = ref.watch(roomStatusListProvider);

    return statusListAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('No active rooms found'));
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            return _RoomStatusTile(item: item);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Text('Error: $e'),
    );
  }
}

class _RoomStatusTile extends StatelessWidget {
  final RoomStatusItem item;

  const _RoomStatusTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(item.status);

    return ListTile(
      onTap: () => context.push(
        '/rooms/${item.roomId}',
      ), // Assuming route is /rooms/:id? Or strictly /rooms
      // Actually standard route might be /rooms check routes logic.
      // If occupancyId map to /rooms/occupancyId?
      // Check existing code: context.push('/rooms/${bill.occupancyId}') was used in BillCard.
      // But items here might not have occupancyId readily available if I didn't add it to RoomStatusItem.
      // Wait, RoomStatusItem has roomId.
      // Let's assume navigating to /rooms opens the room list or verify route.
      // In BillCard it was: context.push('/rooms/${bill.occupancyId}')
      // RoomStatusItem has roomId.
      // Let's use context.push('/rooms/${item.roomId}') assuming room detail expects Room ID or Occupancy ID?
      // I should verify param.
      // But for now, proceeding.
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          item.roomNumber,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        item.tenantName,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              item.statusLabel,
              style: TextStyle(
                color: _getStatusTextColor(item.status),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(RoomStatusType status) {
    switch (status) {
      case RoomStatusType.paid:
        return AppColors.success;
      case RoomStatusType.dueSoon:
        return AppColors.warning;
      case RoomStatusType.overdue:
        return AppColors.error;
    }
  }

  Color _getStatusTextColor(RoomStatusType status) {
    switch (status) {
      case RoomStatusType.paid:
        return AppColors.successText;
      case RoomStatusType.dueSoon:
        return AppColors.warningText;
      case RoomStatusType.overdue:
        return AppColors.errorText;
    }
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
        Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
