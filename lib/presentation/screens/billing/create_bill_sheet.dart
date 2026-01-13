/// Create bill screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/bill.dart';

/// Bottom sheet to create a new bill.
class CreateBillSheet extends ConsumerStatefulWidget {
  final int occupancyId;
  final int roomId;
  final String roomNumber;
  final double agreedRent;
  final bool hasElectricityMeter;
  final double electricityRate;

  const CreateBillSheet({
    super.key,
    required this.occupancyId,
    required this.roomId,
    required this.roomNumber,
    required this.agreedRent,
    required this.hasElectricityMeter,
    required this.electricityRate,
  });

  @override
  ConsumerState<CreateBillSheet> createState() => _CreateBillSheetState();
}

class _CreateBillSheetState extends ConsumerState<CreateBillSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _prevReadingController = TextEditingController();
  final _currReadingController = TextEditingController();
  final _notesController = TextEditingController();

  BillType _selectedBillType = BillType.rent;
  int _billingMonth = DateTime.now().month;
  int _billingYear = DateTime.now().year;
  bool _isLoading = false;
  double _electricityCharges = 0;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.agreedRent.toStringAsFixed(0);
    _loadLastReading();
  }

  Future<void> _loadLastReading() async {
    if (!widget.hasElectricityMeter) return;

    final lastBill = await ref.read(
      lastElectricityBillProvider(widget.occupancyId).future,
    );
    if (lastBill != null && lastBill.electricityCurrReading != null) {
      _prevReadingController.text = lastBill.electricityCurrReading!
          .toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _prevReadingController.dispose();
    _currReadingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    if (_selectedBillType == BillType.rent) {
      _amountController.text = widget.agreedRent.toStringAsFixed(0);
    } else if (_selectedBillType == BillType.electricity) {
      _calculateElectricityCharges();
    }
  }

  void _calculateElectricityCharges() {
    final prev = double.tryParse(_prevReadingController.text) ?? 0;
    final curr = double.tryParse(_currReadingController.text) ?? 0;
    final units = curr - prev;

    if (units > 0) {
      _electricityCharges = units * widget.electricityRate;
      _amountController.text = _electricityCharges.toStringAsFixed(0);
    }
    setState(() {});
  }

  Future<void> _saveBill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(billingRepositoryProvider);

      // Calculate period dates from month/year
      final periodStart = DateTime(_billingYear, _billingMonth, 1);
      // End of month: next month's 1st minus 1 day
      final periodEnd = DateTime(_billingYear, _billingMonth + 1, 0);
      // Due date: 10 days after period start
      final calculatedDueDate = periodStart.add(const Duration(days: 10));

      await repo.createBill(
        occupancyId: widget.occupancyId,
        billType: _selectedBillType,
        billingMonth: _billingMonth,
        billingYear: _billingYear,
        amount: double.parse(_amountController.text),
        electricityPrevReading: _selectedBillType == BillType.electricity
            ? double.tryParse(_prevReadingController.text)
            : null,
        electricityCurrReading: _selectedBillType == BillType.electricity
            ? double.tryParse(_currReadingController.text)
            : null,
        electricityRateAtBilling: _selectedBillType == BillType.electricity
            ? widget.electricityRate
            : null,
        electricityCharges: _selectedBillType == BillType.electricity
            ? _electricityCharges
            : null,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        periodStartDate: periodStart,
        periodEndDate: periodEnd,
        dueDate: calculatedDueDate,
      );

      if (mounted) {
        // Invalidate providers to refresh UI
        ref.invalidate(billsForOccupancyProvider(widget.occupancyId));
        ref.invalidate(unpaidBillsProvider);
        ref.invalidate(dashboardSummaryProvider);
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bill created')));
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

  @override
  Widget build(BuildContext context) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Bill',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Room ${widget.roomNumber}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bill type selector
                  Text(
                    'Bill Type',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: BillType.values.map((type) {
                      final isSelected = _selectedBillType == type;
                      return FilterChip(
                        label: Text(type.name.toUpperCase()),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedBillType = type);
                          _updateAmount();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Billing period
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<int>(
                          value: _billingMonth,
                          decoration: const InputDecoration(labelText: 'Month'),
                          items: List.generate(12, (i) {
                            return DropdownMenuItem(
                              value: i + 1,
                              child: Text(months[i]),
                            );
                          }),
                          onChanged: (v) => setState(() => _billingMonth = v!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<int>(
                          value: _billingYear,
                          decoration: const InputDecoration(labelText: 'Year'),
                          items: List.generate(5, (i) {
                            final year = DateTime.now().year - 2 + i;
                            return DropdownMenuItem(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }),
                          onChanged: (v) => setState(() => _billingYear = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Electricity readings (if applicable)
                  if (_selectedBillType == BillType.electricity &&
                      widget.hasElectricityMeter) ...[
                    Text(
                      'Meter Readings',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prevReadingController,
                            decoration: const InputDecoration(
                              labelText: 'Previous',
                              prefixIcon: Icon(Icons.arrow_back),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _calculateElectricityCharges(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _currReadingController,
                            decoration: const InputDecoration(
                              labelText: 'Current',
                              prefixIcon: Icon(Icons.arrow_forward),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                validatePositiveNumber(v, 'Current reading'),
                            onChanged: (_) => _calculateElectricityCharges(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_electricityCharges > 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(double.tryParse(_currReadingController.text) ?? 0) - (double.tryParse(_prevReadingController.text) ?? 0)} units @ ${formatCurrency(widget.electricityRate)}/unit',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              formatCurrency(_electricityCharges),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Bill Amount (₹) *',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => validatePositiveNumber(v, 'Amount'),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      prefixIcon: Icon(Icons.note_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveBill,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Bill'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
