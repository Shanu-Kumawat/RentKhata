/// Create bill screen.
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/bill.dart';
import '../../../data/database/tables/bill_table.dart' as db;
import '../../../services/image_service.dart';

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
  final _electricityRateController = TextEditingController();

  BillType _selectedBillType = BillType.rent;
  int _billingMonth = DateTime.now().month;
  int _billingYear = DateTime.now().year;
  bool _isLoading = false;
  double _electricityCharges = 0;
  double _electricityRate = 0;
  File? _meterPhoto;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.agreedRent.toStringAsFixed(0);
    _electricityRate = widget.electricityRate;
    _electricityRateController.text = widget.electricityRate.toStringAsFixed(2);
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
    _electricityRateController.dispose();
    super.dispose();
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  void _updateAmount() {
    if (_selectedBillType == BillType.rent) {
      _amountController.text = widget.agreedRent.toStringAsFixed(0);
    } else if (_selectedBillType == BillType.electricity) {
      // For electricity, amount will be calculated from meter readings
      _amountController.text = '0';
      _calculateElectricityCharges();
    } else {
      // For water, maintenance, other: default to 0, user enters amount
      _amountController.text = '0';
    }
  }

  void _calculateElectricityCharges() {
    final prev = double.tryParse(_prevReadingController.text) ?? 0;
    final curr = double.tryParse(_currReadingController.text) ?? 0;
    final units = curr - prev;
    _electricityRate =
        double.tryParse(_electricityRateController.text) ??
        widget.electricityRate;

    if (units > 0) {
      _electricityCharges = units * _electricityRate;
      _amountController.text = _electricityCharges.toStringAsFixed(0);
    } else {
      _electricityCharges = 0;
    }
    setState(() {});
  }

  Future<void> _pickMeterPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final imageService = ImageService();
      final photo = await imageService.pickImage(source: source);
      if (photo != null) {
        setState(() => _meterPhoto = photo);
      }
    }
  }

  Future<void> _saveBill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(billingRepositoryProvider);
      final dao = ref.read(billingDaoProvider);

      // Check for duplicate bill
      final dbBillType = switch (_selectedBillType) {
        BillType.rent => db.BillType.rent,
        BillType.electricity => db.BillType.electricity,
        BillType.water => db.BillType.water,
        BillType.maintenance => db.BillType.maintenance,
        BillType.other => db.BillType.other,
      };

      final existingBill = await dao.checkDuplicateBill(
        occupancyId: widget.occupancyId,
        billType: dbBillType,
        billingMonth: _billingMonth,
        billingYear: _billingYear,
      );

      if (existingBill != null && mounted) {
        // Show duplicate warning dialog
        final proceed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Bill Already Exists'),
            content: Text(
              'A ${_selectedBillType.name} bill for ${_getMonthName(_billingMonth)} $_billingYear '
              'already exists (${existingBill.billNumber ?? "Draft"}).\n\n'
              'Do you want to create another bill anyway?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Create Anyway'),
              ),
            ],
          ),
        );

        if (proceed != true) {
          setState(() => _isLoading = false);
          return;
        }
      }

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
            ? _electricityRate
            : null,
        electricityCharges: _selectedBillType == BillType.electricity
            ? _electricityCharges
            : null,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        periodStartDate: periodStart,
        periodEndDate: periodEnd,
        dueDate: calculatedDueDate,
      );

      // Update global electricity rate if it was changed
      if (_selectedBillType == BillType.electricity &&
          _electricityRate != widget.electricityRate) {
        await repo.addElectricityRate(_electricityRate, DateTime.now());
        ref.invalidate(currentElectricityRateProvider);
      }

      if (mounted) {
        // Invalidate providers to refresh UI
        ref.invalidate(billsForOccupancyProvider(widget.occupancyId));
        ref.invalidate(unpaidBillsProvider);
        ref.invalidate(dashboardSummaryProvider);
        Navigator.pop(context);

        // Show appropriate message
        if (_selectedBillType == BillType.electricity &&
            _electricityRate != widget.electricityRate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Bill created. Global rate updated to ₹${_electricityRate.toStringAsFixed(2)}/unit',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Bill created')));
        }
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
                          initialValue: _billingMonth,
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
                          initialValue: _billingYear,
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
                    // Meter Readings Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.speed, color: Colors.amber.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  'Meter Readings',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Meter reading inputs
                            Row(
                              children: [
                                Expanded(
                                  child: _MeterReadingInput(
                                    label: 'Previous',
                                    controller: _prevReadingController,
                                    onChanged: (_) =>
                                        _calculateElectricityCharges(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                Expanded(
                                  child: _MeterReadingInput(
                                    label: 'Current',
                                    controller: _currReadingController,
                                    onChanged: (_) =>
                                        _calculateElectricityCharges(),
                                    validator: (v) => validatePositiveNumber(
                                      v,
                                      'Current reading',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Electricity rate (editable)
                            Row(
                              children: [
                                const Icon(
                                  Icons.bolt,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Rate per unit:',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _electricityRateController,
                                    decoration: const InputDecoration(
                                      prefixText: '₹ ',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      isDense: true,
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    onChanged: (_) =>
                                        _calculateElectricityCharges(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Calculation Summary
                    if (_electricityCharges > 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.1),
                              AppColors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Electricity Calculation',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${((double.tryParse(_currReadingController.text) ?? 0) - (double.tryParse(_prevReadingController.text) ?? 0)).toStringAsFixed(0)} units × ${formatCurrency(_electricityRate)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatCurrency(_electricityCharges),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Meter Photo Section (Fully clickable)
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _pickMeterPhoto,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: _meterPhoto != null
                                      ? null
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _meterPhoto != null
                                        ? AppColors.success
                                        : Colors.grey.shade300,
                                    width: _meterPhoto != null ? 2 : 1,
                                  ),
                                  image: _meterPhoto != null
                                      ? DecorationImage(
                                          image: FileImage(_meterPhoto!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: _meterPhoto == null
                                    ? Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.grey.shade400,
                                        size: 28,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _meterPhoto != null
                                              ? Icons.check_circle
                                              : Icons.camera_alt_outlined,
                                          size: 18,
                                          color: _meterPhoto != null
                                              ? AppColors.success
                                              : AppColors.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _meterPhoto != null
                                              ? 'Meter Photo Added'
                                              : 'Add Meter Photo',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: _meterPhoto != null
                                                    ? AppColors.success
                                                    : null,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _meterPhoto != null
                                          ? 'Tap to change photo'
                                          : 'Optional - helps with verification',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_meterPhoto != null)
                                IconButton(
                                  onPressed: () =>
                                      setState(() => _meterPhoto = null),
                                  icon: const Icon(Icons.close),
                                  color: Colors.grey,
                                  tooltip: 'Remove photo',
                                )
                              else
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                        ),
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

/// Styled meter reading input box.
class _MeterReadingInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const _MeterReadingInput({
    required this.label,
    required this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            onChanged: onChanged,
            validator: validator,
          ),
          Text(
            'units',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
