/// Record payment sheet.
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
import '../../../domain/entities/payment.dart';
import 'receipt_dialog.dart';

/// Bottom sheet to record a payment.
class RecordPaymentSheet extends ConsumerStatefulWidget {
  final Bill bill;

  const RecordPaymentSheet({super.key, required this.bill});

  @override
  ConsumerState<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends ConsumerState<RecordPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController; // Changed to late final
  late final TextEditingController _notesController; // Changed to late final

  PaymentMode _paymentMode = PaymentMode.cash;
  DateTime _paymentDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with pending amount
    _amountController = TextEditingController(
      // Initialized in initState
      text: widget.bill.pendingAmount.toStringAsFixed(0),
    );
    _notesController = TextEditingController(); // Initialized in initState
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectPaymentDate() async {
    final picked = await showDatePicker(
      // Changed variable name to 'picked'
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Changed variable name to 'picked'
      setState(() => _paymentDate = picked);
    }
  }

  Future<void> _recordPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    if (amount > widget.bill.pendingAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Amount cannot exceed pending balance of ${formatCurrency(widget.bill.pendingAmount)}',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(billingRepositoryProvider);
      await repo.recordPayment(
        billId: widget.bill.id,
        amount: amount,
        paymentMode: _paymentMode,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        paymentDate: _paymentDate,
      );

      if (mounted) {
        // Invalidate providers to refresh UI
        ref.invalidate(billsForOccupancyProvider(widget.bill.occupancyId));
        ref.invalidate(
          billsForOccupancyStreamProvider(widget.bill.occupancyId),
        );
        ref.invalidate(unpaidBillsProvider);
        ref.invalidate(dashboardSummaryProvider);

        // Get landlord name for receipt
        final landlord = await ref.read(landlordProvider.future);
        final landlordName = landlord?.name;

        // Create updated bill with new payment amounts for receipt
        final updatedBill = widget.bill.copyWith(
          paidAmount: widget.bill.paidAmount + amount,
          pendingAmount: widget.bill.pendingAmount - amount,
          status: (widget.bill.pendingAmount - amount) <= 0
              ? BillStatus.paid
              : BillStatus.partial,
        );

        // Create a payment object for the receipt
        final payment = Payment(
          id: 0,
          billId: widget.bill.id,
          amount: amount,
          paymentMode: _paymentMode,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          paymentDate: _paymentDate,
        );

        Navigator.pop(context);

        // Show receipt dialog with landlord name
        await ReceiptDialog.show(
          context: context,
          bill: updatedBill,
          latestPayment: payment,
          landlordName: landlordName, // Added landlordName
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Record Payment',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Bill summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.bill.billType.name.toUpperCase()} - ${widget.bill.billingPeriod}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Pending: ${formatCurrency(widget.bill.pendingAmount)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.moneyPending,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      'of ${formatCurrency(widget.bill.amount)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount (₹) *',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => validatePositiveNumber(v, 'Amount'),
              ),
              const SizedBox(height: 16),

              // Payment mode
              Text(
                'Payment Mode',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: PaymentMode.values.map((mode) {
                  final isSelected = _paymentMode == mode;
                  IconData icon;
                  switch (mode) {
                    case PaymentMode.cash:
                      icon = Icons.money;
                    case PaymentMode.upi:
                      icon = Icons.qr_code;
                    case PaymentMode.bankTransfer:
                      icon = Icons.account_balance;
                    case PaymentMode.cheque:
                      icon = Icons.edit_note;
                    case PaymentMode.other:
                      icon = Icons.more_horiz;
                  }
                  return ChoiceChip(
                    avatar: Icon(icon, size: 18),
                    label: Text(mode.name.toUpperCase()),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _paymentMode = mode),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Payment date
              InkWell(
                onTap: _selectPaymentDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Payment Date',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    '${_paymentDate.day}/${_paymentDate.month}/${_paymentDate.year}',
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
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _recordPayment,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Record Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
