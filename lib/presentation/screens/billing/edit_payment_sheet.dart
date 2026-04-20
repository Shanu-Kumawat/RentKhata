/// Edit payment sheet for modifying existing payments.
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
import '../../../core/utils/l10n_helpers.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Bottom sheet to edit an existing payment.
class EditPaymentSheet extends ConsumerStatefulWidget {
  final Payment payment;
  final Bill bill;

  const EditPaymentSheet({
    super.key,
    required this.payment,
    required this.bill,
  });

  @override
  ConsumerState<EditPaymentSheet> createState() => _EditPaymentSheetState();
}

class _EditPaymentSheetState extends ConsumerState<EditPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  late PaymentMode _paymentMode;
  late DateTime _paymentDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.payment.amount.toStringAsFixed(0),
    );
    _notesController = TextEditingController(text: widget.payment.notes ?? '');
    _paymentMode = widget.payment.paymentMode;
    _paymentDate = widget.payment.paymentDate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectPaymentDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _paymentDate = picked);
    }
  }

  Future<void> _updatePayment() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    // Check if new amount exceeds what's allowed
    // Max allowed = original payment amount + current pending
    final maxAllowed = widget.payment.amount + widget.bill.pendingAmount;
    if (amount > maxAllowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.amountCannotExceedMax(formatCurrency(maxAllowed))),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(billingRepositoryProvider);
      await repo.updatePayment(
        paymentId: widget.payment.id,
        amount: amount,
        paymentMode: _paymentMode,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        paymentDate: _paymentDate,
      );

      if (mounted) {
        // Invalidate providers to refresh UI
        ref.invalidate(billByIdProvider(widget.bill.id));
        ref.invalidate(paymentsForBillProvider(widget.bill.id));
        ref.invalidate(billsForOccupancyProvider(widget.bill.occupancyId));
        ref.invalidate(unpaidBillsProvider);
        ref.invalidate(dashboardSummaryProvider);

        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.paymentUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.error(e.toString()))));
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
                    AppLocalizations.of(context)!.editPayment,
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
                          '${getBillTypeLabel(AppLocalizations.of(context)!, widget.bill.billType).toUpperCase()} - ${widget.bill.billingPeriod}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          AppLocalizations.of(context)!.originalAmount(formatCurrency(widget.payment.amount)),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.paymentAmountRequiredLabel,
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => validatePositiveNumber(v, 'Amount'),
              ),
              const SizedBox(height: 16),

              // Payment mode
              Text(
                AppLocalizations.of(context)!.paymentModeLabel,
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
                    label: Text(_getPaymentModeLabel(context, mode).toUpperCase()),
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.paymentDateLabel,
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.notesOptionalLabel,
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePayment,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(AppLocalizations.of(context)!.updatePayment),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPaymentModeLabel(BuildContext context, PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash:
        return AppLocalizations.of(context)!.cash;
      case PaymentMode.upi:
        return AppLocalizations.of(context)!.upi;
      case PaymentMode.bankTransfer:
        return AppLocalizations.of(context)!.bankTransfer;
      case PaymentMode.cheque:
        return AppLocalizations.of(context)!.cheque;
      case PaymentMode.other:
        return AppLocalizations.of(context)!.other;
    }
  }
}
