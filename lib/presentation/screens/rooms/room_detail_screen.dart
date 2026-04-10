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
import '../../../services/ledger_service.dart';
import '../../../services/pdf_service.dart';
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
                  // Actions - Create Bill & Khata Statement
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _showCreateBill(occupancy),
                          icon: const Icon(Icons.receipt_long_outlined),
                          label: const Text('Create Bill'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _generateAndShareKhataStatement(context, ref, occupancy.id),
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('Statement'),
                        ),
                      ),
                    ],
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
        agreementEndDate: occupancy.agreementEndDate,
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

  Future<void> _generateAndShareKhataStatement(BuildContext context, WidgetRef ref, int occupancyId) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final ledgerStatement = await ref.read(ledgerStatementProvider(occupancyId).future);
      if (ledgerStatement == null) throw Exception('Ledger not found');

      final pdfFile = await PdfService.generateTenantLedgerPdf(ledgerStatement);

      // Hide loading
      if (context.mounted) Navigator.pop(context);

      final shareService = ShareService(ref.read(billingRepositoryProvider));
      await shareService.sharePdfStatement(pdfFile, tenantName: ledgerStatement.tenantName);
    } catch (e) {
      // Hide loading
      if (context.mounted) Navigator.pop(context);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating statement: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    room.isOccupied
                        ? Icons.person_rounded
                        : Icons.meeting_room_outlined,
                    color: room.isOccupied
                        ? AppColors.success
                        : Theme.of(context).colorScheme.onSurfaceVariant,
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        room.isOccupied ? 'Occupied' : 'Vacant',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: room.isOccupied
                                  ? AppColors.success
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
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
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      (occupancy.tenantName ?? 'T')[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
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
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Billing Start',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            if (!hasSeparateBillingDate) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Same as move-in',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add_outlined,
                size: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
        billsAsync.when(
          data: (bills) {
            if (bills.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No bills yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            // Separating bills logic
            final activeBills = bills.where((b) {
              // Active = Unpaid AND Not Void
              return !b.isFullyPaid && b.status != BillStatus.voided;
            }).toList();

            final historyBills = bills
                .where((b) => b.isFullyPaid || b.status == BillStatus.voided)
                .toList();

            // Sort by date descending (assuming input is sorted, but verify)
            // If repository sorts them, good. Otherwise sorting here helps.
            // activeBills.sort(...) // Skip for now, assume repo returns sorting.

            // History limits
            final recentHistory = historyBills.take(2).toList();
            final olderHistory = historyBills.skip(2).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeBills.isNotEmpty) ...[
                  Text(
                    'Active Bills',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...activeBills.map((bill) => _BillTile(bill: bill)),
                ],

                if (recentHistory.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  // If no active bills, maybe don't need separate header?
                  // But "History" is good separator.
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recentHistory.map((bill) => _BillTile(bill: bill)),
                ],

                if (olderHistory.isNotEmpty) ...[
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'View Bill History (${olderHistory.length})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: olderHistory
                          .map((bill) => _BillTile(bill: bill))
                          .toList(),
                    ),
                  ),
                ],
              ],
            );
          },
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
    final statusColor = bill.status == BillStatus.voided
        ? Colors.grey
        : isPaid
        ? AppColors.success
        : isPartial
        ? Colors.orange
        : isOverdue
        ? AppColors.error
        : AppColors.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () => _viewBillDetails(context),
        child: Column(
          children: [
            // Main Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getBillIcon(bill.billType),
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bill Details
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
                        const SizedBox(height: 4),
                        Text(
                          bill.billingPeriod,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (isOverdue && !isPaid)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Overdue by ${_getDaysOverdue(bill.dueDate!)} days',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Hero Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatCurrency(bill.amount),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: bill.status == BillStatus.voided
                              ? theme.disabledColor
                              : (isPaid
                                    ? statusColor
                                    : theme.colorScheme.onSurface),
                          decoration: bill.status == BillStatus.voided
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (bill.status == BillStatus.voided)
                        Text(
                          'VOID',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.disabledColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        )
                      else if (isPartial)
                        Text(
                          '${formatCurrency(bill.pendingAmount)} due',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Text(
                          isPaid ? 'PAID' : 'DUE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Footer (Two-Tone Effect)
            if (bill.status != BillStatus.voided)
              Container(
                color: statusColor.withValues(alpha: 0.08),
                child: Row(
                  children: [
                    if (!isPaid && bill.status != BillStatus.voided) ...[
                      // Remind Button
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _sendReminder(context, ref),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_active_outlined,
                                    size: 18,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Remind',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Divider
                      Container(
                        height: 24,
                        width: 1,
                        color: statusColor.withValues(alpha: 0.2),
                      ),
                      // Pay Button
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _viewBillDetails(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.payment,
                                    size: 18,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Pay Now',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // View Button
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _viewBillDetails(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 18,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'View',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Divider
                      Container(
                        height: 24,
                        width: 1,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.2,
                        ),
                      ),
                      // Share Button
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _shareInvoice(context, ref),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    size: 18,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Share',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getDaysOverdue(DateTime dueDate) {
    final now = DateTime.now();
    return now.difference(dueDate).inDays;
  }

  IconData _getBillIcon(BillType type) {
    return switch (type) {
      BillType.rent => Icons.home_rounded,
      BillType.electricity => Icons.bolt_rounded,
      BillType.water => Icons.water_drop_rounded,
      BillType.maintenance => Icons.build_rounded,
      BillType.other => Icons.receipt_long_rounded,
    };
  }

  String _getBillLabel(BillType type) {
    return switch (type) {
      BillType.rent => 'Monthly Rent',
      BillType.electricity => 'Electricity Bill',
      BillType.water => 'Water Bill',
      BillType.maintenance => 'Maintenance',
      BillType.other => 'Other Charges',
    };
  }

  void _viewBillDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BillDetailScreen(bill: bill)),
    );
  }

  void _sendReminder(BuildContext context, WidgetRef ref) async {
    if (bill.status == BillStatus.draft) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.send_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Send Invoice First?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Share the invoice with the tenant to start tracking.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _shareInvoice(context, ref);
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text('Send Invoice'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final landlord = await ref.read(landlordProvider.future);
    final landlordName = landlord?.name ?? 'Landlord';

    final repo = ref.read(billingRepositoryProvider);
    final shareService = ShareService(repo);
    await shareService.shareBillReminder(
      bill: bill,
      landlordName: landlordName,
    );
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
