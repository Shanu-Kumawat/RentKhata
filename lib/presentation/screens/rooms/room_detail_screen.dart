/// Room detail screen with billing and tenant management.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/property_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/occupancy.dart';
import '../../../domain/entities/bill.dart';
import '../../../services/share_service.dart';
import '../../../services/billing_cycle_service.dart';
import '../billing/create_bill_sheet.dart';
import '../billing/bill_detail_screen.dart';
import 'move_in_sheet.dart';
import 'add_room_screen.dart';
import 'move_out_screen.dart';

/// Room detail screen showing occupancy, bills, and actions.
class RoomDetailScreen extends ConsumerWidget {
  final int roomId;

  /// If true, automatically show create bill sheet on load
  final bool createBill;

  /// Optional: Pre-fill cycle start date for anniversary-based billing
  final DateTime? cycleStart;

  /// Optional: Pre-fill cycle end date for anniversary-based billing
  final DateTime? cycleEnd;

  /// Optional: Pre-select bill type for bill creation
  final BillType? billType;

  const RoomDetailScreen({
    super.key,
    required this.roomId,
    this.createBill = false,
    this.cycleStart,
    this.cycleEnd,
    this.billType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomProvider(roomId));

    return roomAsync.when(
      data: (room) {
        if (room == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Room')),
            body: const Center(child: Text('Room not found')),
          );
        }
        return _RoomDetailContent(
          room: room,
          autoCreateBill: createBill,
          cycleStart: cycleStart,
          cycleEnd: cycleEnd,
          billType: billType,
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _RoomDetailContent extends ConsumerStatefulWidget {
  final Room room;
  final bool autoCreateBill;
  final DateTime? cycleStart;
  final DateTime? cycleEnd;
  final BillType? billType;

  const _RoomDetailContent({
    required this.room,
    this.autoCreateBill = false,
    this.cycleStart,
    this.cycleEnd,
    this.billType,
  });

  @override
  ConsumerState<_RoomDetailContent> createState() => _RoomDetailContentState();
}

class _RoomDetailContentState extends ConsumerState<_RoomDetailContent> {
  bool _hasAutoOpenedBillSheet = false;

  void _maybeAutoOpenBillSheet(Occupancy? occupancy) {
    if (widget.autoCreateBill &&
        !_hasAutoOpenedBillSheet &&
        occupancy != null) {
      _hasAutoOpenedBillSheet = true;
      // Delay to ensure the screen is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showCreateBill(
            context,
            occupancy,
            cycleStart: widget.cycleStart,
            cycleEnd: widget.cycleEnd,
            billType: widget.billType,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final occupancyAsync = ref.watch(occupancyForRoomProvider(widget.room.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.room.roomNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditRoom(context, widget.room),
          ),
        ],
      ),
      body: occupancyAsync.when(
        data: (occupancy) {
          // Auto-open bill sheet if requested via navigation
          _maybeAutoOpenBillSheet(occupancy);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room info card
                _RoomInfoCard(room: widget.room),
                const SizedBox(height: 16),

                // Occupancy section
                if (occupancy != null) ...[
                  _OccupancyCard(
                    occupancy: occupancy,
                    room: widget.room,
                    onEndOccupancy: () =>
                        _confirmMoveOut(context, ref, occupancy),
                  ),
                  const SizedBox(height: 16),

                  // Actions - Create Bill button (full width)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _showCreateBill(context, occupancy),
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: const Text('Create Bill'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bills section
                  _BillsSection(occupancyId: occupancy.id),
                ] else ...[
                  // Vacant room
                  _VacantRoomCard(
                    onMoveIn: () => _showMoveIn(context, widget.room),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showMoveIn(BuildContext context, Room room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => MoveInSheet(roomId: room.id, room: room),
    );
  }

  Future<void> _showCreateBill(
    BuildContext context,
    Occupancy occupancy, {
    DateTime? cycleStart,
    DateTime? cycleEnd,
    BillType? billType,
  }) async {
    // Calculate anniversary-based cycle dates if not provided
    DateTime effectiveCycleStart;
    DateTime effectiveCycleEnd;

    if (cycleStart != null && cycleEnd != null) {
      // Use provided dates (from dashboard navigation)
      effectiveCycleStart = cycleStart;
      effectiveCycleEnd = cycleEnd;
    } else {
      // Find the next cycle that doesn't have a rent bill yet
      final billingRepo = ref.read(billingRepositoryProvider);
      final allBills = await billingRepo.getBillsForOccupancy(occupancy.id);
      final rentBills = allBills
          .where((b) => b.billType == BillType.rent)
          .toList();

      if (rentBills.isEmpty) {
        // No rent bills exist - use current cycle from move-in date
        final currentCycle = BillingCycleService.getCurrentCycle(
          occupancy.moveInDate,
        );
        effectiveCycleStart = currentCycle.start;
        effectiveCycleEnd = currentCycle.end;
      } else {
        // Find the latest rent bill and get the next cycle after it
        rentBills.sort((a, b) {
          final aEnd =
              a.periodEndDate ?? DateTime(a.billingYear, a.billingMonth + 1, 0);
          final bEnd =
              b.periodEndDate ?? DateTime(b.billingYear, b.billingMonth + 1, 0);
          return bEnd.compareTo(aEnd);
        });

        final latestBill = rentBills.first;
        final lastPeriodEnd =
            latestBill.periodEndDate ??
            DateTime(latestBill.billingYear, latestBill.billingMonth + 1, 0);

        final nextCycle = BillingCycleService.getNextCycleAfter(
          occupancy.moveInDate,
          lastPeriodEnd,
        );
        effectiveCycleStart = nextCycle.start;
        effectiveCycleEnd = nextCycle.end;
      }
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => CreateBillSheet(
        occupancyId: occupancy.id,
        roomId: widget.room.id,
        roomNumber: widget.room.roomNumber,
        agreedRent: occupancy.agreedRent,
        hasElectricityMeter: widget.room.hasElectricityMeter,
        electricityRate: widget.room.currentElectricityRate,
        suggestedPeriodStart: effectiveCycleStart,
        suggestedPeriodEnd: effectiveCycleEnd,
        billingStartDate: occupancy.effectiveBillingStartDate,
        initialBillType: billType,
      ),
    );
  }

  void _showEditRoom(BuildContext context, Room room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          AddRoomSheet(propertyId: room.propertyId, existingRoom: room),
    );
  }

  void _confirmMoveOut(
    BuildContext context,
    WidgetRef ref,
    Occupancy occupancy,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          MoveOutScreen(occupancy: occupancy, room: widget.room),
    );
  }
}

class _RoomInfoCard extends StatelessWidget {
  final Room room;

  const _RoomInfoCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: room.isOccupied
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    room.isOccupied
                        ? Icons.person_rounded
                        : Icons.meeting_room_outlined,
                    color: room.isOccupied
                        ? AppColors.success
                        : AppColors.onSurfaceVariant,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.propertyName ?? 'Property',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        room.isOccupied ? 'Occupied' : 'Vacant',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: room.isOccupied
                                  ? AppColors.success
                                  : AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatCurrency(room.baseRent),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/month',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (room.hasElectricityMeter) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.bolt_outlined,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Electricity meter @ ${formatCurrency(room.currentElectricityRate)}/unit',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OccupancyCard extends ConsumerWidget {
  final Occupancy occupancy;
  final Room room;
  final VoidCallback onEndOccupancy;

  const _OccupancyCard({
    required this.occupancy,
    required this.room,
    required this.onEndOccupancy,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingStartDate = occupancy.effectiveBillingStartDate;
    final hasSeparateBillingDate = occupancy.billingStartDate != null;

    return Card(
      child: InkWell(
        onTap: () => context.go('/tenants/${occupancy.tenantId}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      (occupancy.tenantName ?? 'T')[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          occupancy.tenantName ?? 'Tenant',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Since ${occupancy.moveInDate.day}/${occupancy.moveInDate.month}/${occupancy.moveInDate.year}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'move_out') onEndOccupancy();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'move_out',
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app, color: AppColors.warning),
                            SizedBox(width: 8),
                            Text('Move Out'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoTile(
                    label: 'Agreed Rent',
                    value: formatCurrency(occupancy.agreedRent),
                  ),
                  const SizedBox(width: 24),
                  if (occupancy.securityDeposit > 0)
                    _InfoTile(
                      label: 'Security Deposit',
                      value: formatCurrency(occupancy.securityDeposit),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Billing Start Date row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Billing Start',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                            if (!hasSeparateBillingDate) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Same as move-in',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${billingStartDate.day}/${billingStartDate.month}/${billingStartDate.year}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _editBillingStartDate(context, ref),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editBillingStartDate(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: occupancy.effectiveBillingStartDate,
      firstDate: occupancy.moveInDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Billing Start Date',
    );

    if (newDate != null && context.mounted) {
      final tenantRepo = ref.read(tenantRepositoryProvider);
      final success = await tenantRepo.updateBillingStartDate(
        occupancy.id,
        newDate,
      );

      if (success && context.mounted) {
        // Invalidate occupancy provider to refresh data
        ref.invalidate(occupancyForRoomProvider(room.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Billing start date updated to ${newDate.day}/${newDate.month}/${newDate.year}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update billing start date'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _VacantRoomCard extends StatelessWidget {
  final VoidCallback onMoveIn;

  const _VacantRoomCard({required this.onMoveIn});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_outlined,
                size: 32,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Room is Vacant',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Assign a tenant to start collecting rent',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onMoveIn,
              icon: const Icon(Icons.person_add),
              label: const Text('Move In Tenant'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillsSection extends ConsumerWidget {
  final int occupancyId;

  const _BillsSection({required this.occupancyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsForOccupancyProvider(occupancyId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bills',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        billsAsync.when(
          data: (bills) => bills.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No bills yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: bills.map((bill) => _BillTile(bill: bill)).toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('Error: $e'),
        ),
      ],
    );
  }
}

class _BillTile extends ConsumerWidget {
  final Bill bill;

  const _BillTile({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPaid = bill.isFullyPaid;
    final isPartial = bill.paidAmount > 0 && !isPaid;
    final isOverdue = bill.isOverdue;

    // Status colors
    final (statusColor, statusBg, statusLabel) = isPaid
        ? (AppColors.success, AppColors.success.withValues(alpha: 0.12), 'PAID')
        : isPartial
        ? (Colors.orange, Colors.orange.withValues(alpha: 0.12), 'PARTIAL')
        : isOverdue
        ? (AppColors.error, AppColors.error.withValues(alpha: 0.12), 'OVERDUE')
        : (
            AppColors.warning,
            AppColors.warning.withValues(alpha: 0.12),
            'UNPAID',
          );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: InkWell(
        onTap: () => _viewBillDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top row: Bill type & Status badge
              Row(
                children: [
                  // Bill type icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withValues(alpha: 0.2),
                          statusColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getBillIcon(bill.billType),
                      color: statusColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Bill type & period
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getBillLabel(bill.billType),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bill.billingPeriod,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Amount row
              Row(
                children: [
                  // Amount info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              formatCurrency(bill.amount),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPaid ? statusColor : null,
                              ),
                            ),
                            if (isPartial) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(${formatCurrency(bill.pendingAmount)} due)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (!isPaid && bill.dueDate != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: isOverdue
                                    ? AppColors.error
                                    : AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Due ${bill.dueDate!.day}/${bill.dueDate!.month}/${bill.dueDate!.year}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isOverdue
                                      ? AppColors.error
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: isOverdue
                                      ? FontWeight.w600
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Quick action button
                  if (!isPaid)
                    IconButton.filledTonal(
                      onPressed: () => _sendReminder(context, ref),
                      icon: const Icon(
                        Icons.notifications_active_outlined,
                        size: 20,
                      ),
                      tooltip: 'Send Reminder',
                      style: IconButton.styleFrom(
                        backgroundColor: statusColor.withValues(alpha: 0.1),
                        foregroundColor: statusColor,
                      ),
                    )
                  else
                    IconButton.filledTonal(
                      onPressed: () => _shareInvoice(context, ref),
                      icon: const Icon(Icons.share_outlined, size: 20),
                      tooltip: 'Share Invoice',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.success.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: AppColors.success,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getBillIcon(BillType type) {
    return switch (type) {
      BillType.rent => Icons.home_outlined,
      BillType.electricity => Icons.bolt_outlined,
      BillType.water => Icons.water_drop_outlined,
      BillType.maintenance => Icons.build_outlined,
      BillType.other => Icons.receipt_long_outlined,
    };
  }

  String _getBillLabel(BillType type) {
    return switch (type) {
      BillType.rent => 'Rent',
      BillType.electricity => 'Electricity',
      BillType.water => 'Water',
      BillType.maintenance => 'Maintenance',
      BillType.other => 'Other',
    };
  }

  void _viewBillDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BillDetailScreen(bill: bill)),
    );
  }

  void _sendReminder(BuildContext context, WidgetRef ref) async {
    final landlord = await ref.read(landlordProvider.future);
    final landlordName = landlord?.name ?? 'Landlord';

    final message = ShareService.billReminderMessage(
      tenantName: bill.tenantName ?? 'Tenant',
      billType: bill.billType.name,
      period: bill.billingPeriod,
      amount: bill.pendingAmount,
      dueDate: bill.dueDate ?? DateTime.now(),
      landlordName: landlordName,
    );

    final repo = ref.read(billingRepositoryProvider);
    final shareService = ShareService(repo);
    final success = await shareService.shareToWhatsApp(message: message);
    if (!success && context.mounted) {
      await shareService.shareText(text: message, subject: 'Payment Reminder');
    }
  }

  void _shareInvoice(BuildContext context, WidgetRef ref) async {
    final landlord = await ref.read(landlordProvider.future);

    final repo = ref.read(billingRepositoryProvider);
    final shareService = ShareService(repo);
    await shareService.shareInvoice(
      bill: bill,
      landlordName: landlord?.name ?? 'Landlord',
      landlordUpi: landlord?.upiId,
    );
  }
}
