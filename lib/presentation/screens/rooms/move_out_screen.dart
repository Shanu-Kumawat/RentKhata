import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/property_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/occupancy.dart';
import '../../../domain/entities/payment.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../../../core/utils/l10n_helpers.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/settlement_statement.dart';
import '../../../services/pdf_service.dart';
import '../pdf/pdf_preview_screen.dart';

/// Screen for processing move out with deposit settlement
class MoveOutScreen extends ConsumerStatefulWidget {
  final Occupancy occupancy;
  final Room room;

  const MoveOutScreen({super.key, required this.occupancy, required this.room});

  @override
  ConsumerState<MoveOutScreen> createState() => _MoveOutScreenState();
}

class _MoveOutScreenState extends ConsumerState<MoveOutScreen> {
  DateTime _moveOutDate = DateTime.now();
  final _deductionController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  // Settlement state
  final Set<int> _selectedBillIdsToDeduct = {};
  final Set<int> _selectedBillIdsToVoid = {};
  double _manualDeduction = 0;

  @override
  void initState() {
    super.initState();
    _deductionController.addListener(_onManualDeductionChanged);
  }

  void _onManualDeductionChanged() {
    setState(() {
      _manualDeduction = double.tryParse(_deductionController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    _deductionController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  double _calculateTotalBillDeduction(List<Bill> bills) {
    return bills
        .where((b) => _selectedBillIdsToDeduct.contains(b.id))
        .fold(0, (sum, b) => sum + b.pendingAmount);
  }

  @override
  Widget build(BuildContext context) {
    final billsAsync = ref.watch(
      billsForOccupancyProvider(widget.occupancy.id),
    );
    final deposit = widget.occupancy.securityDeposit;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
            // Handle
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.moveOutSettlement,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.occupancy.tenantName ??
                              AppLocalizations.of(context)!.tenant,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
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
              child: billsAsync.when(
                data: (bills) {
                  final pendingBills = bills
                      .where((b) => !b.isFullyPaid)
                      .toList();
                  final billDeduction = _calculateTotalBillDeduction(
                    pendingBills,
                  );
                  final totalDeduction = billDeduction + _manualDeduction;
                  final refundAmount = deposit - totalDeduction;

                  final isNegative = refundAmount < 0; // Tenant owes money

                  return ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Date Selection
                      _DateSelectionCard(
                        date: _moveOutDate,
                        onSelect: (d) => setState(() => _moveOutDate = d),
                      ),
                      const SizedBox(height: 16),

                      // Deposit Summary
                      Card(
                        elevation: 0,
                        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.securityDepositLabel,
                              ),
                              Text(
                                formatCurrency(deposit),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bill Deductions
                      if (pendingBills.isNotEmpty) ...[
                        Text(
                          AppLocalizations.of(context)!.pendingBillsToDeduct,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...pendingBills.map((bill) {
                          final isDeducting = _selectedBillIdsToDeduct.contains(
                            bill.id,
                          );
                          final isVoiding = _selectedBillIdsToVoid.contains(
                            bill.id,
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CheckboxListTile(
                                value: isDeducting,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedBillIdsToDeduct.add(bill.id);
                                      _selectedBillIdsToVoid.remove(bill.id);
                                    } else {
                                      _selectedBillIdsToDeduct.remove(bill.id);
                                    }
                                  });
                                },
                                title: Text(
                                  '${getBillTypeLabel(AppLocalizations.of(context)!, bill.billType).toUpperCase()} - ${bill.billingPeriod}',
                                  style: TextStyle(
                                    decoration: isVoiding
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Text(
                                  'Due: ${formatCurrency(bill.pendingAmount)}',
                                  style: TextStyle(
                                    decoration: isVoiding
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                secondary: Icon(
                                  isDeducting
                                      ? Icons.remove_circle
                                      : Icons.circle_outlined,
                                  color: isDeducting ? AppColors.error : null,
                                ),
                                activeColor: AppColors.error,
                                contentPadding: EdgeInsets.zero,
                              ),
                              if (!isDeducting)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isVoiding) {
                                        _selectedBillIdsToVoid.remove(bill.id);
                                      } else {
                                        _selectedBillIdsToVoid.add(bill.id);
                                      }
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  child: Text(
                                    isVoiding
                                        ? AppLocalizations.of(context)!.undoVoid
                                        : AppLocalizations.of(
                                            context,
                                          )!.markAsVoid,
                                  ),
                                ),
                            ],
                          );
                        }),
                        const Divider(height: 32),
                      ],

                      // Manual Deduction
                      Text(
                        AppLocalizations.of(context)!.otherDeductionsTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _deductionController,
                        decoration: const InputDecoration(
                          labelText: 'Manual Deduction Amount (₹)',
                          prefixIcon: Icon(Icons.money_off),
                          hintText: '0',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Reason (e.g. Damages, Painting)',
                          prefixIcon: Icon(Icons.comment),
                        ),
                        maxLines: 2,
                      ),

                      const SizedBox(height: 32),

                      // Final Calculation
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isNegative
                              ? AppColors.error.withValues(alpha: 0.1)
                              : AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isNegative
                                ? AppColors.error
                                : AppColors.success,
                          ),
                        ),
                        child: Column(
                          children: [
                            _SettlementRow(
                              AppLocalizations.of(context)!.totalDeposit,
                              formatCurrency(deposit),
                            ),
                            const SizedBox(height: 8),
                            if (billDeduction > 0)
                              _SettlementRow(
                                AppLocalizations.of(context)!.billDeductions,
                                '- ${formatCurrency(billDeduction)}',
                                isDeduction: true,
                              ),
                            if (_manualDeduction > 0)
                              _SettlementRow(
                                AppLocalizations.of(
                                  context,
                                )!.otherDeductionsTitle,
                                '- ${formatCurrency(_manualDeduction)}',
                                isDeduction: true,
                              ),

                            const Divider(),
                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isNegative
                                      ? AppLocalizations.of(context)!.tenantOwes
                                      : AppLocalizations.of(
                                          context,
                                        )!.refundableAmount,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  formatCurrency(refundAmount.abs()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isNegative
                                            ? AppColors.error
                                            : AppColors.success,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Submit
                      FilledButton(
                        onPressed: _isLoading
                            ? null
                            : () => _confirmSettlement(
                                refundAmount,
                                totalDeduction,
                              ),
                        style: FilledButton.styleFrom(
                          backgroundColor: isNegative
                              ? AppColors.error
                              : AppColors.primary,
                          padding: const EdgeInsets.all(16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isNegative
                                    ? AppLocalizations.of(
                                        context,
                                      )!.confirmMoveOutRecord
                                    : AppLocalizations.of(
                                        context,
                                      )!.confirmMoveOutSettle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSettlement(
    double refundAmount,
    double totalDeduction,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    setState(() => _isLoading = true);

    try {
      final billingRepo = ref.read(billingRepositoryProvider);

      final bills =
          ref.read(billsForOccupancyProvider(widget.occupancy.id)).value ?? [];

      final List<SettlementBillDeduction> billDeductions = [];

      // 0. Mark voided bills
      for (final billId in _selectedBillIdsToVoid) {
        await billingRepo.voidBill(billId, 'Voided during move-out settlement');
      }

      // 1. Mark selected bills as PAID (settled via deposit)
      for (final billId in _selectedBillIdsToDeduct) {
        final bill = bills.firstWhere((b) => b.id == billId);
        // Only pay what is pending
        if (bill.pendingAmount > 0) {
          billDeductions.add(
            SettlementBillDeduction(
              billTypeLabel: getBillTypeLabel(
                l10n,
                bill.billType,
              ).toUpperCase(),
              period: bill.billingPeriod,
              amount: bill.pendingAmount,
            ),
          );

          await billingRepo.recordPayment(
            billId: billId,
            amount: bill.pendingAmount,
            paymentMode: PaymentMode.other,
            notes: l10n.settledViaDeposit,
            paymentDate: DateTime.now(),
          );
        }
      }

      // 2. End Occupancy
      await ref
          .read(tenantRepositoryProvider)
          .endOccupancy(
            widget.occupancy.id,
            _moveOutDate,
            deductionAmount: _manualDeduction,
            deductionReason: _reasonController.text,
            settlementNotes:
                'Bill Deductions: ${formatCurrency(totalDeduction - _manualDeduction)}; Refund: ${formatCurrency(refundAmount)}',
            isSettled: true,
            depositReturnedAmount: refundAmount > 0 ? refundAmount : 0,
          );

      // 3. Generate Settlement PDF
      final landlordRepo = ref.read(landlordRepositoryProvider);
      final landlord = await landlordRepo.getLandlord();

      final statement = SettlementStatement(
        occupancyId: widget.occupancy.id,
        tenantName: widget.occupancy.tenantName ?? l10n.tenant,
        landlordName: landlord?.name ?? l10n.landlord,
        propertyName: widget.room.propertyName ?? 'Property',
        roomNumber: widget.room.roomNumber,
        moveInDate: widget.occupancy.moveInDate,
        moveOutDate: _moveOutDate,
        securityDeposit: widget.occupancy.securityDeposit,
        billDeductions: billDeductions,
        manualDeduction: _manualDeduction,
        manualDeductionReason: _reasonController.text.trim().isEmpty
            ? null
            : _reasonController.text.trim(),
        totalDeductions: totalDeduction,
        refundAmount: refundAmount,
      );

      final pdfFile = await PdfService.generateSettlementPdf(statement, l10n);

      // Trigger updates
      if (mounted) {
        ref.invalidate(roomProvider(widget.occupancy.roomId));
        ref.invalidate(allRoomsProvider);
        ref.invalidate(propertiesStreamProvider);
        ref.invalidate(roomsForPropertyStreamProvider(widget.room.propertyId));
        ref.invalidate(tenantsProvider);
        ref.invalidate(tenantsStreamProvider);
        ref.invalidate(tenantProvider(widget.occupancy.tenantId));
        ref.invalidate(dashboardSummaryProvider); // Refresh dashboard

        Navigator.pop(context); // Close sheet
        Navigator.pop(context); // Close Room Detail
      }

      await rootNavigator.push(
        MaterialPageRoute(
          builder: (_) => PdfPreviewScreen(
            pdfFile: pdfFile,
            title: l10n.moveOutSettlementTitle,
            shareSubject: 'Move-Out Settlement Receipt',
            shareText:
                'Dear ${statement.tenantName},\n\nYour Move-Out Settlement is complete. Please find the detailed Settlement Receipt attached.',
            suggestedFileName: pdfFile.path.split('/').last,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      setState(() => _isLoading = false);
    }
  }
}

class _SettlementRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDeduction;

  const _SettlementRow(this.label, this.value, {this.isDeduction = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDeduction ? AppColors.error : null,
          ),
        ),
      ],
    );
  }
}

class _DateSelectionCard extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onSelect;

  const _DateSelectionCard({required this.date, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: AppColors.primary),
        title: Text(AppLocalizations.of(context)!.moveOutDate),
        subtitle: Text('${date.day}/${date.month}/${date.year}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: now.add(const Duration(days: 30)),
          );
          if (picked != null) onSelect(picked);
        },
      ),
    );
  }
}
