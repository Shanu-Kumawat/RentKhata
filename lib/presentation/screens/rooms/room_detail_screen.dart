/// Room detail screen with billing and tenant management.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/property_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/occupancy.dart';
import '../../../domain/entities/bill.dart';
import '../billing/create_bill_sheet.dart';
import '../billing/record_payment_sheet.dart';
import '../../widgets/upi_qr_widget.dart';
import 'move_in_sheet.dart';
import 'add_room_screen.dart';

/// Room detail screen showing occupancy, bills, and actions.
class RoomDetailScreen extends ConsumerWidget {
  final int roomId;

  const RoomDetailScreen({super.key, required this.roomId});

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
        return _RoomDetailContent(room: room);
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

class _RoomDetailContent extends ConsumerWidget {
  final Room room;

  const _RoomDetailContent({required this.room});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occupancyAsync = ref.watch(occupancyForRoomProvider(room.id));
    final landlordAsync = ref.watch(landlordProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${room.roomNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditRoom(context, room),
          ),
        ],
      ),
      body: occupancyAsync.when(
        data: (occupancy) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room info card
              _RoomInfoCard(room: room),
              const SizedBox(height: 16),

              // Occupancy section
              if (occupancy != null) ...[
                _OccupancyCard(
                  occupancy: occupancy,
                  room: room,
                  onEndOccupancy: () =>
                      _confirmMoveOut(context, ref, occupancy),
                ),
                const SizedBox(height: 16),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showCreateBill(context, occupancy),
                        icon: const Icon(Icons.receipt_long_outlined),
                        label: const Text('Create Bill'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: landlordAsync.when(
                        data: (landlord) => FilledButton.icon(
                          onPressed: () => _showUpiQr(
                            context,
                            landlord?.name ?? 'Landlord',
                            landlord?.upiId,
                            occupancy.agreedRent,
                          ),
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Collect Rent'),
                        ),
                        loading: () => const FilledButton(
                          onPressed: null,
                          child: CircularProgressIndicator(),
                        ),
                        error: (_, __) => const SizedBox(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Bills section
                _BillsSection(occupancyId: occupancy.id),
              ] else ...[
                // Vacant room
                _VacantRoomCard(onMoveIn: () => _showMoveIn(context, room)),
              ],
            ],
          ),
        ),
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

  void _showCreateBill(BuildContext context, Occupancy occupancy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => CreateBillSheet(
        occupancyId: occupancy.id,
        roomId: room.id,
        roomNumber: room.roomNumber,
        agreedRent: occupancy.agreedRent,
        hasElectricityMeter: room.hasElectricityMeter,
        electricityRate: room.currentElectricityRate,
      ),
    );
  }

  void _showUpiQr(
    BuildContext context,
    String payeeName,
    String? upiId,
    double amount,
  ) {
    UpiQrDialog.show(
      context,
      payeeName: payeeName,
      upiId: upiId,
      amount: amount,
      transactionNote: 'Rent for Room ${room.roomNumber}',
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
      builder: (context) => _MoveOutSheet(occupancy: occupancy, room: room),
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

class _OccupancyCard extends StatelessWidget {
  final Occupancy occupancy;
  final Room room;
  final VoidCallback onEndOccupancy;

  const _OccupancyCard({
    required this.occupancy,
    required this.room,
    required this.onEndOccupancy,
  });

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ),
    );
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

class _BillTile extends StatelessWidget {
  final Bill bill;

  const _BillTile({required this.bill});

  @override
  Widget build(BuildContext context) {
    final statusColor = bill.isFullyPaid
        ? AppColors.success
        : bill.isOverdue
        ? AppColors.error
        : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => _showRecordPayment(context),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            bill.isFullyPaid ? Icons.check_circle : Icons.pending,
            color: statusColor,
          ),
        ),
        title: Text(
          '${bill.billType.name.toUpperCase()} - ${bill.billingPeriod}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          bill.isFullyPaid
              ? 'Paid'
              : 'Pending: ${formatCurrency(bill.pendingAmount)}',
        ),
        trailing: Text(
          formatCurrency(bill.amount),
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showRecordPayment(BuildContext context) {
    if (bill.isFullyPaid) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RecordPaymentSheet(bill: bill),
    );
  }
}

/// Move out bottom sheet with deposit settlement
class _MoveOutSheet extends ConsumerStatefulWidget {
  final Occupancy occupancy;
  final Room room;

  const _MoveOutSheet({required this.occupancy, required this.room});

  @override
  ConsumerState<_MoveOutSheet> createState() => _MoveOutSheetState();
}

class _MoveOutSheetState extends ConsumerState<_MoveOutSheet> {
  final _deductionController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _moveOutDate = DateTime.now();
  bool _isLoading = false;

  double get deposit => widget.occupancy.securityDeposit;
  double get deduction => double.tryParse(_deductionController.text) ?? 0;
  double get refundable => (deposit - deduction).clamp(0, deposit);

  @override
  void dispose() {
    _deductionController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get bills for this occupancy and filter for unpaid
    final billsAsync = ref.watch(
      billsForOccupancyProvider(widget.occupancy.id),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
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
                      'Move Out ${widget.occupancy.tenantName ?? 'Tenant'}',
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
                  // Move out date
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      title: const Text('Move Out Date'),
                      subtitle: Text(
                        '${_moveOutDate.day}/${_moveOutDate.month}/${_moveOutDate.year}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        // Allow dates from 2000 to 5 years in future (flexible for corrections)
                        final earliestDate = DateTime(2000);
                        final latestDate = DateTime.now().add(
                          const Duration(days: 365 * 5),
                        );

                        // Ensure initial date is within valid range
                        var initial = _moveOutDate;
                        if (initial.isBefore(earliestDate))
                          initial = earliestDate;
                        if (initial.isAfter(latestDate)) initial = latestDate;

                        final date = await showDatePicker(
                          context: context,
                          initialDate: initial,
                          firstDate: earliestDate,
                          lastDate: latestDate,
                        );
                        if (date != null) {
                          setState(() => _moveOutDate = date);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pending Bills Warning
                  billsAsync.when(
                    data: (allBills) {
                      final bills = allBills
                          .where((b) => !b.isFullyPaid)
                          .toList();
                      if (bills.isEmpty) return const SizedBox.shrink();
                      final total = bills.fold<double>(
                        0,
                        (sum, b) => sum + b.pendingAmount,
                      );
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.warning),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${bills.length} pending bill(s) totaling ${formatCurrency(total)}. '
                                'Consider deducting from deposit.',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  // Deposit Summary Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deposit Settlement',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _SettlementRow(
                            'Security Deposit',
                            formatCurrency(deposit),
                          ),
                          const SizedBox(height: 12),

                          // Deduction Input
                          TextFormField(
                            controller: _deductionController,
                            decoration: const InputDecoration(
                              labelText: 'Deduction Amount (₹)',
                              hintText: '0',
                              prefixIcon: Icon(Icons.remove_circle_outline),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _reasonController,
                            decoration: const InputDecoration(
                              labelText: 'Reason for Deduction (Optional)',
                              hintText: 'e.g., Unpaid bills, damages',
                              prefixIcon: Icon(Icons.notes_outlined),
                            ),
                          ),
                          const Divider(height: 24),
                          _SettlementRow(
                            'Refundable Amount',
                            formatCurrency(refundable),
                            highlight: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
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
                          onPressed: _isLoading ? null : _completeMoveOut,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.warning,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Confirm Move Out'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeMoveOut() async {
    setState(() => _isLoading = true);

    try {
      // End the occupancy
      await ref
          .read(tenantRepositoryProvider)
          .endOccupancy(widget.occupancy.id, _moveOutDate);

      // Log the deposit settlement (for future: could store in a deposit_transactions table)
      // For now, just complete the move out

      if (mounted) {
        // Invalidate providers to refresh state across all screens
        ref.invalidate(roomProvider(widget.occupancy.roomId));
        ref.invalidate(allRoomsProvider);
        ref.invalidate(propertiesStreamProvider);
        ref.invalidate(roomsForPropertyStreamProvider(widget.room.propertyId));
        ref.invalidate(tenantsProvider);
        ref.invalidate(tenantsStreamProvider);
        ref.invalidate(tenantProvider(widget.occupancy.tenantId));
        ref.invalidate(dashboardSummaryProvider);

        Navigator.pop(context);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              refundable > 0
                  ? 'Tenant moved out. Refund: ${formatCurrency(refundable)}'
                  : 'Tenant moved out successfully',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _SettlementRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SettlementRow(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: highlight
              ? Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              : TextStyle(color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: highlight
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                )
              : const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
