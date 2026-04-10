/// Dashboard screen - main home screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../domain/entities/billing_status.dart';
import '../../../domain/entities/bill.dart';
import '../../../core/theme/app_colors.dart';

import '../../widgets/bouncing_scale_wrapper.dart';
import '../../widgets/staggered_fade_in.dart';


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
          // Prominent Reports button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => context.push('/reports'),
              icon: const Icon(Icons.assessment_outlined, size: 20),
              label: const Text('Reports'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
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
              // 1. Top Section: Action Center (Priority Zone)
              const StaggeredFadeIn(
                delay: Duration(milliseconds: 0),
                child: Column(
                  children: [
                    _SectionHeader(
                      icon: Icons.notifications_active_outlined,
                      title: 'Attention Needed',
                    ),
                    SizedBox(height: 12),
                    _ActionRequiredSection(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Bottom Section: Live Property Status
              StaggeredFadeIn(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    const _SectionHeader(
                      icon: Icons.meeting_room_outlined,
                      title: 'Live Property Status',
                    ),
                    const SizedBox(height: 12),
                    _LivePropertyStatusList(),
                  ],
                ),
              ),
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
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.home_work_outlined,
                  color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_add_outlined,
                  color: Theme.of(context).colorScheme.secondary,
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
                  color: Theme.of(context).colorScheme.error, // Warning context
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: Theme.of(context).colorScheme.error,
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



class _ActionRequiredSection extends ConsumerWidget {
  const _ActionRequiredSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpaidBillsAsync = ref.watch(unpaidBillsProvider);
    final billingAttentionAsync = ref.watch(billingAttentionListProvider);
    final expiringAgreementsAsync = ref.watch(expiringAgreementsProvider);
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
                ? theme.colorScheme.error.withValues(alpha: 0.5)
                : theme.colorScheme.error.withValues(
                    alpha: 0.5,
                  ); // Warning context
            final iconBgColor = hasOverdue
                ? theme.colorScheme.error.withValues(alpha: 0.1)
                : theme.colorScheme.error.withValues(alpha: 0.1);
            final iconColor = hasOverdue
                ? theme.colorScheme.error
                : theme.colorScheme.error;

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

        // Subsection A2: "Agreements Expiring"
        expiringAgreementsAsync.when(
          data: (expiring) {
            if (expiring.isEmpty) return const SizedBox.shrink();

            final expiredCount = expiring.where((e) => e.isExpired).length;
            final count = expiring.length;
            
            final color = expiredCount > 0 ? theme.colorScheme.error : AppColors.warning;
            
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: BouncingScaleWrapper(
                onTap: () {
                    // Navigate to tenant list maybe, or show a dialog
                    context.push('/properties');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: color.withValues(alpha: 0.25),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: color.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.handshake_outlined,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$count Agreement${count > 1 ? 's' : ''} Expiring',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (expiredCount > 0)
                                    Text(
                                      '$expiredCount already expired',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  else
                                    Text(
                                      'Within next 30 days',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        const SizedBox(height: 12),

        // Subsection B: "Collect Payment" (Existing Unpaid Bills)
        unpaidBillsAsync.when(
          data: (bills) {
            if (bills.isEmpty) return const SizedBox.shrink();
            final overdueCount = bills.where((b) => b.isOverdue).length;
            final count = bills.length;

            return BouncingScaleWrapper(
              onTap: () => context.push('/reports'),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.25),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.error.withValues(alpha: 0.05),
                    ),
                    child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.error.withValues(
                        alpha: 0.1,
                      ),
                      child: Icon(
                        Icons.priority_high,
                        color: theme.colorScheme.error,
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
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.primary,
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

  String _billTypeLabel(BillType type) => switch (type) {
    BillType.rent => 'Rent',
    BillType.electricity => 'Elec',
    BillType.water => 'Water',
    BillType.maintenance => 'Maint',
    BillType.other => 'Other',
  };

  Color _billTypeColor(BuildContext context, BillType type) => switch (type) {
    BillType.rent => Theme.of(context).colorScheme.primary,
    BillType.electricity => Theme.of(context).colorScheme.error,
    BillType.water => Colors.blue,
    BillType.maintenance => Colors.green,
    BillType.other => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.status == BillingCycleStatus.overdue;
    final statusColor = isOverdue
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.error; // Warning
    final statusTextColor = isOverdue
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.error;
    final billColor = _billTypeColor(context, item.billType);

    return ListTile(
      visualDensity: VisualDensity.compact,
      onTap: () {
        // Navigate to room detail with cycle dates and bill type for bill creation
        context.push(
          '/rooms/${item.roomId}?createBill=true'
          '&cycleStart=${item.cycleStart.toIso8601String()}'
          '&cycleEnd=${item.cycleEnd.toIso8601String()}'
          '&billType=${item.billType.name}',
        );
      },
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: billColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: billColor.withValues(alpha: 0.3)),
        ),
        child: Text(
          _billTypeLabel(item.billType),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: billColor,
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
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
            '&cycleEnd=${item.cycleEnd.toIso8601String()}'
            '&billType=${item.billType.name}',
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
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _RoomStatusTile(item: item),
            );
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
    final color = _getStatusColor(context, item.status);

    return BouncingScaleWrapper(
      onTap: () => context.push('/rooms/${item.roomId}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Leading Room Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item.roomNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Middle Info
                Expanded(
                  child: Text(
                    item.tenantName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Trailing Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.statusLabel,
                        style: TextStyle(
                          color: _getStatusTextColor(context, item.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, RoomStatusType status) {
    switch (status) {
      case RoomStatusType.paid:
        return Theme.of(context).colorScheme.tertiary; // Success equivalent
      case RoomStatusType.dueSoon:
        return Theme.of(context).colorScheme.error; // Warning equivalent
      case RoomStatusType.overdue:
        return Theme.of(context).colorScheme.error;
    }
  }

  Color _getStatusTextColor(BuildContext context, RoomStatusType status) {
    switch (status) {
      case RoomStatusType.paid:
        return Theme.of(context).colorScheme.tertiary;
      case RoomStatusType.dueSoon:
        return Theme.of(context).colorScheme.error;
      case RoomStatusType.overdue:
        return Theme.of(context).colorScheme.error;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

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
