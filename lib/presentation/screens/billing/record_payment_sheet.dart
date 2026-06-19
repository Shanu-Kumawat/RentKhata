/// Record payment sheet.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/analytics_provider.dart';
import '../../../application/providers/notification_settings_providers.dart';
import '../../../application/providers/review_provider.dart';
import '../settings/widgets/animated_review_dialog.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/l10n_helpers.dart';
import '../../../data/database/tables/notification_setting_table.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/payment.dart';
import '../../../services/local_notification_service.dart';
import 'receipt_dialog.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Bottom sheet to record a payment.
class RecordPaymentSheet extends ConsumerStatefulWidget {
  final Bill bill;

  const RecordPaymentSheet({super.key, required this.bill});

  @override
  ConsumerState<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends ConsumerState<RecordPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  PaymentMode _paymentMode = PaymentMode.cash;
  DateTime _paymentDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with pending amount
    _amountController = TextEditingController(
      text: widget.bill.pendingAmount.toStringAsFixed(0),
    );
    _notesController = TextEditingController();
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

  Future<void> _recordPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    if (amount > widget.bill.pendingAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.amountCannotExceedPendingBalance(
              formatCurrency(widget.bill.pendingAmount),
            ),
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
        // Log custom analytics event
        ref.read(analyticsServiceProvider).logPaymentRecorded(amount: amount, method: _paymentMode.name);

        // Update Review Service Action Count
        final reviewService = ref.read(reviewServiceProvider);
        await reviewService.recordAction();
        final shouldShowReview = await reviewService.shouldShowReviewPrompt();

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
        final landlordPhone = landlord?.phone;

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

        final notificationService = LocalNotificationService();
        final notificationSettings = ref.read(
          notificationSettingsNotifierProvider,
        );

        await notificationService.showPaymentRecordedConfirmation(
          roomNumber:
              updatedBill.roomNumber ?? widget.bill.roomNumber ?? 'Room',
          tenantName:
              updatedBill.tenantName ?? widget.bill.tenantName ?? 'Tenant',
          amount: amount,
          isFullyPaid: updatedBill.isFullyPaid,
        );

        if (updatedBill.isFullyPaid) {
          await notificationService.cancelBillNotifications(updatedBill.id);
          await notificationService.cancelOverdueEscalation(updatedBill.id);
        } else {
          final pauseEnabled = notificationSettings.isEnabled(
            NotificationType.partialPaymentPause,
          );
          final paidRatio = updatedBill.amount > 0
              ? updatedBill.paidAmount / updatedBill.amount
              : 0.0;

          if (pauseEnabled && paidRatio >= 0.5) {
            await notificationService.cancelOverdueEscalation(updatedBill.id);
            await notificationService.showPartialPaymentPauseNotice(
              roomNumber:
                  updatedBill.roomNumber ?? widget.bill.roomNumber ?? 'Room',
              tenantName:
                  updatedBill.tenantName ?? widget.bill.tenantName ?? 'Tenant',
              paidRatio: paidRatio,
            );
          } else {
            final overdueDays = <int>{
              if (notificationSettings.isEnabled(NotificationType.overdue1Day))
                1,
              if (notificationSettings.isEnabled(NotificationType.overdue3Days))
                3,
              if (notificationSettings.isEnabled(NotificationType.overdue7Days))
                7,
              if (notificationSettings.isEnabled(
                NotificationType.overdue14Days,
              ))
                14,
            };

            if (overdueDays.isNotEmpty) {
              await notificationService.scheduleOverdueEscalation(
                bill: updatedBill,
                escalationDays: overdueDays,
                notificationHour: notificationSettings.notificationHour,
                pauseOnPartialPayment: pauseEnabled,
                partialPaymentThresholdRatio: 0.5,
              );
            }
          }
        }

        if (!mounted) return;
        Navigator.pop(context);

        // Show receipt dialog with landlord name
        await ReceiptDialog.show(
          context: context,
          bill: updatedBill,
          latestPayment: payment,
          landlordName: landlordName,
          landlordPhone: landlordPhone,
        );

        // Show review prompt if eligible after receipt is dismissed
        if (shouldShowReview && mounted) {
          await AnimatedReviewDialog.show(
            context,
            triggerContext: ReviewTriggerContext.payment,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = widget.bill.pendingAmount;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 32,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title & Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.recordPayment,
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
                const SizedBox(height: 16),

                // Context Info (Subtle)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          '${getBillTypeLabel(AppLocalizations.of(context)!, widget.bill.billType).toUpperCase()} • ${widget.bill.billingPeriod}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.dueAmount(formatCurrency(pending)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // HERO AMOUNT INPUT
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.enterAmount,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    IntrinsicWidth(
                      child: TextFormField(
                        controller: _amountController,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          prefixText: '₹',
                          prefixStyle: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: AppLocalizations.of(context)!.zeroAmount,
                          hintStyle: theme.textTheme.displayMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        validator: (v) => validatePositiveNumber(v, AppLocalizations.of(context)!),
                      ),
                    ),
                    // "Full Amount" Chip
                    if (double.tryParse(_amountController.text) != pending)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ActionChip(
                          label: Text(AppLocalizations.of(context)!.payFullDue),
                          avatar: const Icon(Icons.check, size: 16),
                          onPressed: () {
                            _amountController.text = pending.toStringAsFixed(0);
                            setState(() {});
                          },
                          visualDensity: VisualDensity.compact,
                          side: BorderSide.none,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),

                // Payment Mode Selector (Horizontal)
                // Payment Mode Selector (Wrap for visibility)
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: PaymentMode.values.map((mode) {
                      final isSelected = _paymentMode == mode;
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          getPaymentModeLabel(
                            AppLocalizations.of(context)!,
                            mode,
                          ).toUpperCase(),
                        ),
                        avatar: isSelected
                            ? Icon(
                                Icons.check,
                                color: theme.colorScheme.onPrimary,
                                size: 18,
                              )
                            : _getModeIcon(mode),
                        selected: isSelected,
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : null,
                          fontWeight: isSelected ? FontWeight.bold : null,
                          fontSize: 12,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onSelected: (_) => setState(() => _paymentMode = mode),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),

                // Date & Notes (Vertical Stack for safety)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _selectPaymentDate,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.date,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${_paymentDate.day}/${_paymentDate.month}/${_paymentDate.year}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: theme.colorScheme.outlineVariant,
                      ),
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            context,
                          )!.addNoteOptional,
                          prefixIcon: const Icon(Icons.edit_note),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Primary Action Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _recordPayment,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.recordPayment,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Icon _getModeIcon(PaymentMode mode) {
    return Icon(switch (mode) {
      PaymentMode.cash => Icons.money,
      PaymentMode.upi => Icons.qr_code,
      PaymentMode.bankTransfer => Icons.account_balance,
      PaymentMode.cheque => Icons.edit_note,
      PaymentMode.other => Icons.more_horiz,
    }, size: 18);
  }
}
