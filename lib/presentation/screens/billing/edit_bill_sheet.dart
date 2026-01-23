/// Edit bill sheet with payment-aware restrictions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/bill.dart';

/// Bottom sheet to edit a bill with payment-aware restrictions.
/// - Unpaid bills: full editing allowed
/// - Partially paid: only notes, due date, amount (increase only)
/// - Fully paid: not editable (should not open this sheet)
class EditBillSheet extends ConsumerStatefulWidget {
  final Bill bill;

  const EditBillSheet({super.key, required this.bill});

  @override
  ConsumerState<EditBillSheet> createState() => _EditBillSheetState();
}

class _EditBillSheetState extends ConsumerState<EditBillSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  DateTime? _dueDate;
  bool _isLoading = false;

  /// Whether this bill has any payments
  bool get _hasPayments => widget.bill.paidAmount > 0;

  /// Whether amount can be edited (always true, but restricted for partial bills)
  bool get _canEditAmount => true;

  /// Minimum allowed amount (must be >= paid amount)
  double get _minimumAmount => widget.bill.paidAmount;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.bill.amount.toStringAsFixed(0),
    );
    _notesController = TextEditingController(text: widget.bill.notes ?? '');
    _dueDate = widget.bill.dueDate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _saveBill() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    // Validate amount is not less than paid amount
    if (amount < _minimumAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Amount cannot be less than paid amount of ${formatCurrency(_minimumAmount)}',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(billingRepositoryProvider);

      // Create updated bill
      final updatedBill = widget.bill.copyWith(
        amount: _canEditAmount ? amount : widget.bill.amount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        dueDate: _dueDate,
        // Recalculate pending amount if amount changed
        pendingAmount: _canEditAmount
            ? amount - widget.bill.paidAmount
            : widget.bill.pendingAmount,
      );

      final success = await repo.updateBill(updatedBill);

      if (success && mounted) {
        // Invalidate providers to refresh UI
        ref.invalidate(billByIdProvider(widget.bill.id));
        ref.invalidate(billsForOccupancyProvider(widget.bill.occupancyId));
        ref.invalidate(
          billsForOccupancyStreamProvider(widget.bill.occupancyId),
        );
        ref.invalidate(unpaidBillsProvider);
        ref.invalidate(dashboardSummaryProvider);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill updated successfully')),
        );
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
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Bill',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                // Warning for partial payments
                if (_hasPayments) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This bill has received payments. Amount can only be increased. It cannot be less than paid amount.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Bill summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.bill.billType.name.toUpperCase()} - ${widget.bill.billingPeriod}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_hasPayments) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Paid: ${formatCurrency(widget.bill.paidAmount)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Amount (disabled if has payments, or show min value info)
                TextFormField(
                  controller: _amountController,
                  enabled: _canEditAmount,
                  decoration: InputDecoration(
                    labelText: 'Bill Amount (₹) *',
                    prefixIcon: const Icon(Icons.currency_rupee),
                    helperText: _hasPayments
                        ? 'Min amount: ${formatCurrency(widget.bill.paidAmount)}'
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => validatePositiveNumber(v, 'Amount'),
                ),
                const SizedBox(height: 16),

                // Due date
                InkWell(
                  onTap: _selectDueDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      suffixIcon: _dueDate != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() => _dueDate = null),
                            )
                          : null,
                    ),
                    child: Text(
                      _dueDate != null
                          ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                          : 'Not set',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    prefixIcon: Icon(Icons.note_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

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
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
