/// Occupancy detail screen - historical view of a specific occupancy period.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/occupancy_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/occupancy.dart';
import '../billing/bill_detail_screen.dart';

/// Screen showing complete historical details of an occupancy period.
class OccupancyDetailScreen extends ConsumerWidget {
  final int occupancyId;

  const OccupancyDetailScreen({super.key, required this.occupancyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(occupancyDetailProvider(occupancyId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Occupancy Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Details',
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Occupancy not found'));
          }
          return _OccupancyDetailContent(detail: detail);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _OccupancyDetailContent extends StatelessWidget {
  final OccupancyDetail detail;

  const _OccupancyDetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    final occupancy = detail.occupancy;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Info
          _OccupancyInfoCard(occupancy: occupancy),
          const SizedBox(height: 24),

          // Stats Grid
          _OccupancyStatsGrid(detail: detail),
          const SizedBox(height: 24),

          // Bills Section
          _SectionHeader(
            title: 'Bills & Payments',
            icon: Icons.receipt_long_outlined,
            action: detail.bills.isNotEmpty
                ? '${detail.bills.length} bills'
                : null,
          ),
          const SizedBox(height: 12),
          if (detail.bills.isEmpty)
            _EmptyState(
              icon: Icons.receipt_outlined,
              message: 'No bills generated during this stay',
            )
          else
            ...detail.bills.map(
              (bill) => _BillCard(
                bill: bill,
                propertyName: occupancy.propertyName,
                roomNumber: occupancy.roomNumber,
              ),
            ),

          const SizedBox(height: 24),

          // Family Members
          _SectionHeader(
            title: 'Family Members',
            icon: Icons.family_restroom_outlined,
            action: '${detail.familyMembers.length} people',
          ),
          const SizedBox(height: 12),
          if (detail.familyMembers.isEmpty)
            _EmptyState(
              icon: Icons.people_outline,
              message: 'No family members recorded',
            )
          else
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: detail.familyMembers
                    .map(
                      (member) => _FamilyMemberTile(
                        name: member.name,
                        relationship: member.relationship.name,
                        age: member.age?.toString(),
                        gender: member.gender,
                      ),
                    )
                    .toList(),
              ),
            ),

          const SizedBox(height: 24),

          // Deposit Settlement
          if (occupancy.securityDeposit > 0) ...[
            _SectionHeader(
              title: 'Deposit Settlement',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 12),
            _DepositSettlementCard(occupancy: occupancy),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}

class _OccupancyInfoCard extends StatelessWidget {
  final Occupancy occupancy;

  const _OccupancyInfoCard({required this.occupancy});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final isActive = occupancy.isActive;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home_work_outlined,
                    color: isActive
                        ? AppColors.success
                        : AppColors.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        occupancy.propertyName ?? 'Property',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Room ${occupancy.roomNumber ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Past Stay',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isActive
                          ? AppColors.success
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _DateColumn(
                      label: 'Move In',
                      date: dateFormat.format(occupancy.moveInDate),
                      icon: Icons.login,
                      color: AppColors.success,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _DateColumn(
                      label: 'Move Out',
                      date: occupancy.moveOutDate != null
                          ? dateFormat.format(occupancy.moveOutDate!)
                          : 'Present',
                      icon: Icons.logout,
                      color: isActive ? AppColors.primary : AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    GoRouter.of(context).push('/tenants/${occupancy.tenantId}'),
                icon: const Icon(Icons.person_outline, size: 18),
                label: Text('View ${occupancy.tenantName ?? 'Tenant'} Profile'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateColumn extends StatelessWidget {
  final String label;
  final String date;
  final IconData icon;
  final Color color;

  const _DateColumn({
    required this.label,
    required this.date,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _OccupancyStatsGrid extends StatelessWidget {
  final OccupancyDetail detail;

  const _OccupancyStatsGrid({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Rent',
            value: formatCurrency(detail.occupancy.agreedRent),
            icon: Icons.payments_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Total Paid',
            value: formatCurrency(detail.totalPaid),
            icon: Icons.check_circle_outline,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Pending',
            value: formatCurrency(
              detail.totalPending > 0 ? detail.totalPending : 0,
            ),
            icon: Icons.pending_outlined,
            color: detail.totalPending > 0
                ? AppColors.error
                : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Keep height constraints
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color, // Solid color background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.2,
                  ), // Frosted glass effect for icon bg
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(
                alpha: 0.8,
              ), // Slightly transparent white
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final Bill bill;
  final String? propertyName;
  final String? roomNumber;

  const _BillCard({required this.bill, this.propertyName, this.roomNumber});

  @override
  Widget build(BuildContext context) {
    final statusColor = bill.isFullyPaid
        ? AppColors.success
        : bill.isOverdue
        ? AppColors.error
        : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillDetailScreen(bill: bill),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Property & Room info (Context)
              if (propertyName != null || roomNumber != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.home_work_outlined,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${propertyName ?? ''} ${roomNumber != null ? '(Room $roomNumber)' : ''}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      bill.isFullyPaid ? Icons.check_circle : Icons.pending,
                      color: statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_billTypeLabel(bill.billType)} • ${bill.billingPeriod}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (bill.electricityCharges != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Usage: ${bill.electricityCurrReading! - bill.electricityPrevReading!} units',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatCurrency(bill.amount),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (!bill.isFullyPaid && bill.paidAmount > 0)
                        Text(
                          'Paid: ${formatCurrency(bill.paidAmount)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bill.isFullyPaid
                          ? 'Paid on ${DateFormat('dd MMM').format(bill.dueDate ?? DateTime.now())}'
                          : 'Due ${bill.dueDate != null ? DateFormat('dd MMM').format(bill.dueDate!) : 'N/A'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bill.isOverdue && !bill.isFullyPaid
                            ? AppColors.error
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!bill.isFullyPaid)
                      Text(
                        'Pay Now',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
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
        return 'Elec';
      case BillType.water:
        return 'Water';
      case BillType.maintenance:
        return 'Maint';
      case BillType.other:
        return 'Other';
    }
  }
}

class _FamilyMemberTile extends StatelessWidget {
  final String name;
  final String relationship;
  final String? age;
  final String? gender;

  const _FamilyMemberTile({
    required this.name,
    required this.relationship,
    this.age,
    this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(name, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(
        [
          relationship,
          if (age != null) '$age yrs',
          if (gender != null) gender,
        ].where((e) => e != null).join(' • '),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DepositSettlementCard extends StatelessWidget {
  final Occupancy occupancy;

  const _DepositSettlementCard({required this.occupancy});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(occupancy.depositStatus);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deposit Status',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    occupancy.depositStatus
                        .toString()
                        .split('.')
                        .last
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _RowItem('Amount', formatCurrency(occupancy.securityDeposit)),
            const SizedBox(height: 8),
            if (occupancy.deductionAmount > 0) ...[
              _RowItem(
                'Deductions',
                '- ${formatCurrency(occupancy.deductionAmount)}',
                valueColor: AppColors.error,
              ),
              const SizedBox(height: 8),
            ],
            _RowItem(
              'Return Amount',
              occupancy.depositReturnedAmount != null
                  ? formatCurrency(occupancy.depositReturnedAmount!)
                  : '-',
              valueColor: occupancy.depositReturnedAmount != null
                  ? AppColors.success
                  : null,
            ),
            if (occupancy.deductionReason != null &&
                occupancy.deductionReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              _DetailRow(
                'Reason',
                occupancy.deductionReason!,
                icon: Icons.info_outline,
              ),
            ],
            if (occupancy.settlementNotes != null &&
                occupancy.settlementNotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              if (occupancy.deductionReason == null) const Divider(),
              const SizedBox(height: 8),
              _DetailRow(
                'Notes',
                occupancy.settlementNotes!,
                icon: Icons.notes,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(DepositStatus status) {
    switch (status) {
      case DepositStatus.received:
        return AppColors.success;
      case DepositStatus.pending:
        return AppColors.warning;
      case DepositStatus.returned:
        return AppColors.onSurfaceVariant;
      default:
        return AppColors.info;
    }
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _RowItem(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow(this.label, this.value, {required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? action;

  const _SectionHeader({required this.title, required this.icon, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (action != null)
          Text(
            action!,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
