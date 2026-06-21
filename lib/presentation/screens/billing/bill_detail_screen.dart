/// Bill detail screen with comprehensive bill information.
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/image_service.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/repository_providers.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/audit_log.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/payment.dart';
import '../../../services/share_service.dart';
import '../../../services/invoice_pdf_service.dart';
import '../../widgets/share_bottom_sheet.dart';
import '../pdf/pdf_preview_screen.dart';
import 'edit_bill_sheet.dart';
import 'record_payment_sheet.dart';
import 'edit_payment_sheet.dart';
import '../../../core/theme/app_colors.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../../../core/utils/ui_utils.dart';

/// Screen to view detailed bill information including payments.
class BillDetailScreen extends ConsumerWidget {
  final Bill bill;

  const BillDetailScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for real-time updates to this bill
    final billAsync = ref.watch(billByIdProvider(bill.id));

    if (billAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.billDetails)),
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.error(billAsync.error.toString()),
          ),
        ),
      );
    }

    final activeBill = billAsync.value ?? bill;
    return _BillDetailContent(bill: activeBill);
  }
}

class _BillDetailContent extends ConsumerWidget {
  final Bill bill;

  const _BillDetailContent({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final paymentsAsync = ref.watch(paymentsForBillProvider(bill.id));
    final landlordAsync = ref.watch(landlordProvider);

    // Extract landlord info
    final landlord = landlordAsync.valueOrNull;
    final landlordName = landlord?.name;
    final landlordPhone = landlord?.phone;
    final landlordUpi = landlord?.upiId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          bill.billNumber ?? AppLocalizations.of(context)!.billDetails,
        ),
        actions: [
          if (bill.canEdit ||
              bill.canEditLimited ||
              bill.canDelete ||
              (!bill.isFullyPaid && bill.status != BillStatus.voided))
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(
                context,
                ref,
                value,
                landlordName,
                landlordUpi,
              ),
              itemBuilder: (context) => [
                if (bill.canEdit || bill.canEditLimited)
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: Text(AppLocalizations.of(context)!.editBill),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (bill.canDelete)
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.deleteBill,
                        style: const TextStyle(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (bill.status != BillStatus.voided &&
                    !bill.isFullyPaid &&
                    bill.status != BillStatus.partial)
                  PopupMenuItem(
                    value: 'void',
                    child: ListTile(
                      leading: const Icon(Icons.block, color: AppColors.error),
                      title: Text(
                        AppLocalizations.of(context)!.voidBill,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (!bill.isFullyPaid &&
                    bill.status != BillStatus.draft &&
                    bill.status != BillStatus.voided)
                  PopupMenuItem(
                    value: 'reminder',
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active_outlined),
                      title: Text(AppLocalizations.of(context)!.sendReminder),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Amount Card
            _StatusCard(bill: bill),
            const SizedBox(height: 16),

            // Quick Actions
            _QuickActionsCard(
              bill: bill,
              onSendReminder: () => _sendReminder(context, ref, landlordName),
            ),
            const SizedBox(height: 16),

            // Bill Details Card
            _BillInfoCard(bill: bill),
            const SizedBox(height: 16),

            // Electricity Details (if applicable)
            if (bill.billType == BillType.electricity &&
                bill.electricityPrevReading != null) ...[
              _ElectricityDetailsCard(bill: bill),
              const SizedBox(height: 16),
            ],

            // Payments Section
            Text(
              AppLocalizations.of(context)!.paymentHistory,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            paymentsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.error(e.toString()),
                  ),
                ),
              ),
              data: (payments) => payments.isEmpty
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.payment_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.noPaymentsRecorded,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: payments
                          .map((p) => _PaymentTile(payment: p, bill: bill))
                          .toList(),
                    ),
            ),

            // Notes (if any)
            if (bill.notes != null && bill.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.notes,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(bill.notes!, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],

            // Audit History Section
            const SizedBox(height: 16),
            _AuditHistorySection(billId: bill.id),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main action buttons
              if (bill.status == BillStatus.voided)
                const SizedBox.shrink()
              else
                Row(
                  children: [
                    if (bill.canRecordPayment) ...[
                      // Draft/Unpaid: Preview invoice PDF (secondary)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openPdfPreview(
                            context,
                            ref,
                            landlordName,
                            landlordPhone,
                            landlordUpi,
                          ),
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: Text(
                            AppLocalizations.of(context)!.invoicePreview,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Draft/Unpaid: Record Payment (Primary & Default)
                      Expanded(
                        flex: 1,
                        child: ElevatedButton.icon(
                          onPressed: () => _recordPayment(context),
                          icon: const Icon(Icons.payment),
                          label: Text(
                            AppLocalizations.of(
                              context,
                            )!.payAmount(formatCurrency(bill.pendingAmount)),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Paid: Single invoice PDF preview action
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openPdfPreview(
                            context,
                            ref,
                            landlordName,
                            landlordPhone,
                            landlordUpi,
                          ),
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: Text(
                            AppLocalizations.of(context)!.invoicePreview,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _recordPayment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RecordPaymentSheet(bill: bill),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    String? landlordName,
    String? landlordUpi,
  ) {
    switch (action) {
      case 'edit':
        _editBill(context);
        break;
      case 'void':
        _confirmVoid(context, ref);
        break;
      case 'delete':
        _confirmDeleteBill(context, ref);
        break;
      case 'reminder':
        _sendReminder(context, ref, landlordName);
        break;
    }
  }

  void _editBill(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditBillSheet(bill: bill),
    );
  }

  Future<void> _openPdfPreview(
    BuildContext context,
    WidgetRef ref,
    String? landlordName,
    String? landlordPhone,
    String? landlordUpi,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(billingRepositoryProvider);
    final isPaid = bill.isFullyPaid;
    final payments = await repo.getPaymentsForBill(bill.id);
    final latestPayment = payments.isNotEmpty ? payments.last : null;

    if (!context.mounted) return;

    try {
      final pdfService = InvoicePdfService();
      final file = await withLoadingOverlay(
        context: context,
        action: () {
          if (isPaid && latestPayment != null) {
            return pdfService.generateReceipt(
              bill: bill,
              payment: latestPayment,
              landlordName: landlordName ?? l10n.landlord,
              landlordPhone: landlordPhone ?? '',
              l10n: l10n,
            );
          } else {
            return pdfService.generateInvoice(
              bill: bill,
              landlordName: landlordName ?? l10n.landlord,
              landlordPhone: landlordPhone ?? '',
              landlordUpiId: landlordUpi,
              l10n: l10n,
            );
          }
        },
      );

      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfPreviewScreen(
            pdfFile: file,
            title: l10n.invoicePreview,
            shareSubject: isPaid
                ? 'Receipt #${latestPayment?.id}'
                : l10n.invoiceNumber(bill.billNumber ?? ''),
            suggestedFileName: file.path.split('/').last,
            shareContentType: isPaid
                ? ShareContentType.receipt
                : ShareContentType.invoice,
            onShareAsMessage: () async {
              final shareService = ShareService(repo);
              if (isPaid && latestPayment != null) {
                await shareService.shareReceipt(
                  bill: bill,
                  payment: latestPayment,
                  landlordName: landlordName ?? l10n.landlord,
                  l10n: l10n,
                );
              } else {
                await shareService.shareInvoice(
                  bill: bill,
                  landlordName: landlordName ?? l10n.landlord,
                  landlordUpi: landlordUpi,
                  l10n: l10n,
                );
                await repo.markBillAsSent(bill.id);
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorSavingPdf(e.toString()))),
      );
    }
  }

  void _sendReminder(
    BuildContext context,
    WidgetRef ref,
    String? landlordName,
  ) async {
    // The "Send Reminder" quick action button now acts as a share button
    // for the unpaid bill. It fetches additional info directly to pass to _openPdfPreview.
    final landlordAsync = ref.read(landlordProvider);
    final landlord = landlordAsync.value;

    _openPdfPreview(
      context,
      ref,
      landlordName ?? landlord?.name,
      landlord?.phone,
      landlord?.upiId,
    );
  }

  void _confirmVoid(BuildContext context, WidgetRef ref) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        title: Text(AppLocalizations.of(context)!.voidBillTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.voidBillWarning),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.voidReasonLabel,
                hintText: AppLocalizations.of(context)!.voidReasonHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.voidBill),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(billingRepositoryProvider)
          .voidBill(bill.id, reasonController.text);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.billMarkedVoid)),
        );
        ref.invalidate(billByIdProvider(bill.id));
        ref.invalidate(billingRepositoryProvider);
      }
    }
  }

  void _confirmDeleteBill(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        title: Text(AppLocalizations.of(context)!.deleteBillTitle),
        content: Text(
          AppLocalizations.of(
            context,
          )!.confirmDeleteBill(bill.billType.name, bill.billingPeriod),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              try {
                final repo = ref.read(billingRepositoryProvider);
                final success = await repo.deleteBill(bill.id);

                if (success && context.mounted) {
                  // Invalidate providers to refresh UI
                  ref.invalidate(billsForOccupancyProvider(bill.occupancyId));
                  ref.invalidate(
                    billsForOccupancyStreamProvider(bill.occupancyId),
                  );
                  ref.invalidate(unpaidBillsProvider);
                  ref.invalidate(dashboardSummaryProvider);

                  Navigator.pop(context); // Go back to room/occupancy screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.billDeleted),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Bad state: ', '')),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}

/// Card showing bill status and amounts.
class _StatusCard extends StatelessWidget {
  final Bill bill;

  const _StatusCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusLabel, statusIcon) = _getStatusDetails(
      context,
      bill.status,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Status header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: statusColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  statusLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (bill.isOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.overdueU,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Amount breakdown
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _AmountColumn(
                      label: AppLocalizations.of(context)!.total,
                      amount: bill.amount,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _AmountColumn(
                      label: AppLocalizations.of(context)!.paid,
                      amount: bill.paidAmount,
                      color: AppColors.success,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _AmountColumn(
                      label: AppLocalizations.of(context)!.pendingTitle,
                      amount: bill.pendingAmount,
                      color: bill.pendingAmount > 0
                          ? Theme.of(context).colorScheme.error
                          : AppColors.success,
                    ),
                  ],
                ),
                if (bill.paidAmount > 0 && bill.pendingAmount > 0) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: bill.paidAmount / bill.amount,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.success,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, String, IconData) _getStatusDetails(
    BuildContext context,
    BillStatus status,
  ) {
    return switch (status) {
      BillStatus.draft => (
        Colors.grey,
        AppLocalizations.of(context)!.draft,
        Icons.edit_note,
      ),
      BillStatus.sent => (
        Colors.blue,
        AppLocalizations.of(context)!.sent,
        Icons.send,
      ),
      BillStatus.partial => (
        Colors.orange,
        AppLocalizations.of(context)!.partiallyPaid,
        Icons.timelapse,
      ),
      BillStatus.paid => (
        AppColors.success,
        AppLocalizations.of(context)!.paid,
        Icons.check_circle,
      ),
      BillStatus.overdue => (
        Theme.of(context).colorScheme.error,
        AppLocalizations.of(context)!.overdueBill,
        Icons.warning,
      ),
      BillStatus.voided => (
        Colors.grey.shade600,
        AppLocalizations.of(context)!.voided,
        Icons.cancel,
      ),
    };
  }
}

/// Column showing amount with label.
class _AmountColumn extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _AmountColumn({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatCurrency(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Card with quick actions for the bill.
class _QuickActionsCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback onSendReminder;

  const _QuickActionsCard({required this.bill, required this.onSendReminder});

  @override
  Widget build(BuildContext context) {
    if (bill.status == BillStatus.voided) {
      return const SizedBox.shrink();
    }

    // If Fully Paid, we usually don't show QuickActions (or just Share Receipt)
    // Redundancy fix: We already have "Share" in the bottom bar, so hide it here.
    if (bill.isFullyPaid) {
      return const SizedBox.shrink();
    } else {
      // Unpaid: Only show Reminder if not draft. View Invoice is redundant.
      if (bill.status == BillStatus.draft) {
        return const SizedBox.shrink(); // No quick actions for draft (everything is at bottom)
      }
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onSendReminder,
          icon: const Icon(Icons.notifications_active_outlined),
          label: Text(AppLocalizations.of(context)!.sendReminder),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );
    }
  }
}

/// Card showing bill info (type, period, dates).
class _BillInfoCard extends StatelessWidget {
  final Bill bill;

  const _BillInfoCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.receipt_outlined,
              label: AppLocalizations.of(context)!.billNumber,
              value:
                  bill.billNumber ?? AppLocalizations.of(context)!.notAssigned,
            ),
            _InfoRow(
              icon: Icons.category_outlined,
              label: AppLocalizations.of(context)!.type,
              value: _getBillTypeLabel(context, bill.billType),
            ),
            _InfoRow(
              icon: Icons.calendar_month_outlined,
              label: AppLocalizations.of(context)!.billingPeriod,
              value: bill.billingPeriod,
            ),

            if (bill.dueDate != null)
              _InfoRow(
                icon: Icons.event_outlined,
                label: AppLocalizations.of(context)!.dueDate,
                value: _formatDate(bill.dueDate!),
                valueColor: bill.isOverdue
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
            if (bill.roomNumber != null)
              _InfoRow(
                icon: Icons.door_front_door_outlined,
                label: AppLocalizations.of(context)!.room,
                value: AppLocalizations.of(
                  context,
                )!.roomNumber(bill.roomNumber!),
              ),
            if (bill.tenantName != null)
              _InfoRow(
                icon: Icons.person_outlined,
                label: AppLocalizations.of(context)!.tenant,
                value: bill.tenantName!,
              ),
            _InfoRow(
              icon: Icons.access_time_outlined,
              label: AppLocalizations.of(context)!.created,
              value: _formatDateTime(bill.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getBillTypeLabel(BuildContext context, BillType type) {
    switch (type) {
      case BillType.rent:
        return AppLocalizations.of(context)!.monthlyRent;
      case BillType.electricity:
        return AppLocalizations.of(context)!.electricityBill;
      case BillType.water:
        return AppLocalizations.of(context)!.waterBill;
      case BillType.maintenance:
        return AppLocalizations.of(context)!.maintenance;
      case BillType.other:
        return AppLocalizations.of(context)!.otherCharges;
    }
  }
}

/// Electricity details card.
class _ElectricityDetailsCard extends ConsumerWidget {
  final Bill bill;

  const _ElectricityDetailsCard({required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final units =
        (bill.electricityCurrReading ?? 0) - (bill.electricityPrevReading ?? 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: Colors.amber.shade600),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.electricityDetails,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ReadingBox(
                    label: AppLocalizations.of(context)!.previous,
                    value: bill.electricityPrevReading!.toStringAsFixed(0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, size: 20),
                ),
                Expanded(
                  child: _ReadingBox(
                    label: AppLocalizations.of(context)!.current,
                    value: bill.electricityCurrReading!.toStringAsFixed(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.unitsConsumedRate(
                      units.toStringAsFixed(0),
                      formatRate(bill.electricityRateAtBilling ?? 0),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.amber.shade900,
                    ),
                  ),
                  Text(
                    formatCurrency(bill.electricityCharges ?? 0),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            // Meter Photo (if present)
            if (bill.meterPhotoPath != null &&
                bill.meterPhotoPath!.isNotEmpty) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  // Show full screen image
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppBar(
                            title: Text(
                              AppLocalizations.of(context)!.meterPhoto,
                            ),
                            automaticallyImplyLeading: false,
                            actions: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          Image.file(
                            File(
                              ImageService.resolveImagePathSync(
                                bill.meterPhotoPath!,
                              ),
                            ),
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(7),
                        ),
                        child: Image.file(
                          File(
                            ImageService.resolveImagePathSync(
                              bill.meterPhotoPath!,
                            ),
                          ),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.meterPhoto,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.tapToViewFullSize,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ],
            // Add Meter Photo button (if missing and is electricity bill)
            if ((bill.meterPhotoPath == null || bill.meterPhotoPath!.isEmpty) &&
                bill.billType == BillType.electricity &&
                !bill.isFullyPaid) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _addMeterPhoto(context, ref, bill),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.addMeterPhoto,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _addMeterPhoto(
    BuildContext context,
    WidgetRef ref,
    Bill bill,
  ) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null && context.mounted) {
      final imageService = ImageService();
      // pickAndSaveImage returns just the filename (e.g. 'img_123.jpg') for DB
      final fileName = await imageService.pickAndSaveImage(source: source);

      if (fileName != null && context.mounted) {
        try {
          final repo = ref.read(billingRepositoryProvider);
          final updatedBill = bill.copyWith(meterPhotoPath: fileName);

          final success = await repo.updateBill(updatedBill);

          if (success && context.mounted) {
            // Invalidate providers
            ref.invalidate(billByIdProvider(bill.id));
            ref.invalidate(billsForOccupancyProvider(bill.occupancyId));
            ref.invalidate(billsForOccupancyStreamProvider(bill.occupancyId));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.meterPhotoAdded),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.errorAddingPhoto(e.toString()),
                ),
              ),
            );
          }
        }
      }
    }
  }
}

/// A box showing meter reading value.
class _ReadingBox extends StatelessWidget {
  final String label;
  final String value;

  const _ReadingBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// An info row with icon, label, and value.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tile showing a single payment with edit/delete actions.
class _PaymentTile extends ConsumerWidget {
  final Payment payment;
  final Bill bill;

  const _PaymentTile({required this.payment, required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
          child: Icon(
            _getPaymentModeIcon(payment.paymentMode),
            color: AppColors.success,
            size: 20,
          ),
        ),
        title: Text(
          formatCurrency(payment.amount),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
        subtitle: Text(
          '${_getPaymentModeLabel(context, payment.paymentMode)} • ${_formatDate(payment.paymentDate)}',
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (action) => _handleAction(context, ref, action),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(AppLocalizations.of(context)!.editPayment),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  AppLocalizations.of(context)!.deletePayment,
                  style: const TextStyle(color: Colors.red),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        _editPayment(context, ref);
        break;
      case 'delete':
        _confirmDeletePayment(context, ref);
        break;
    }
  }

  void _editPayment(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditPaymentSheet(payment: payment, bill: bill),
    );
  }

  void _confirmDeletePayment(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        title: Text(AppLocalizations.of(context)!.deletePaymentTitle),
        content: Text(
          AppLocalizations.of(context)!.confirmDeletePayment(
            formatCurrency(payment.amount),
            _formatDate(payment.paymentDate),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              try {
                final repo = ref.read(billingRepositoryProvider);
                final success = await repo.deletePayment(payment.id);

                if (success && context.mounted) {
                  // Invalidate providers to refresh UI
                  ref.invalidate(billByIdProvider(bill.id));
                  ref.invalidate(paymentsForBillProvider(bill.id));
                  ref.invalidate(billsForOccupancyProvider(bill.occupancyId));
                  ref.invalidate(unpaidBillsProvider);
                  ref.invalidate(dashboardSummaryProvider);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.paymentDeleted,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.error(e.toString()),
                      ),
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData _getPaymentModeIcon(PaymentMode mode) {
    return switch (mode) {
      PaymentMode.cash => Icons.money,
      PaymentMode.upi => Icons.qr_code,
      PaymentMode.bankTransfer => Icons.account_balance,
      PaymentMode.cheque => Icons.edit_note,
      PaymentMode.other => Icons.more_horiz,
    };
  }

  String _getPaymentModeLabel(BuildContext context, PaymentMode mode) {
    return switch (mode) {
      PaymentMode.cash => AppLocalizations.of(context)!.cash,
      PaymentMode.upi => AppLocalizations.of(context)!.upi,
      PaymentMode.bankTransfer => AppLocalizations.of(context)!.bankTransfer,
      PaymentMode.cheque => AppLocalizations.of(context)!.cheque,
      PaymentMode.other => AppLocalizations.of(context)!.other,
    };
  }
}

/// Expandable section showing audit history for a bill.
class _AuditHistorySection extends ConsumerWidget {
  final int billId;

  const _AuditHistorySection({required this.billId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auditLogsAsync = ref.watch(auditLogsForBillProvider(billId));

    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.history, size: 20),
        title: Text(
          AppLocalizations.of(context)!.auditHistory,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          auditLogsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(
                  context,
                )!.errorLoadingAuditLogs(e.toString()),
              ),
            ),
            data: (logs) {
              if (logs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.noChangesRecorded,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return Column(
                children: logs.map((log) => _AuditLogTile(log: log)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A tile showing a single audit log entry.
class _AuditLogTile extends StatelessWidget {
  final AuditLog log;

  const _AuditLogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = _getActionDetails(log.action);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, size: 14, color: color),
      ),
      title: Text(
        _getActionLabel(context, log.action),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (log.notes != null && log.notes!.isNotEmpty)
            Text(
              log.notes!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            dateFormat.format(log.createdAt),
            style: theme.textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      isThreeLine: log.notes != null && log.notes!.isNotEmpty,
    );
  }

  (IconData, Color) _getActionDetails(AuditAction action) {
    return switch (action) {
      AuditAction.create => (Icons.add_circle_outline, Colors.green),
      AuditAction.update => (Icons.edit_outlined, Colors.blue),
      AuditAction.delete => (Icons.delete_outline, Colors.red),
      AuditAction.void_ => (Icons.cancel_outlined, Colors.grey),
    };
  }

  String _getActionLabel(BuildContext context, AuditAction action) {
    return switch (action) {
      AuditAction.create => AppLocalizations.of(context)!.created,
      AuditAction.update => AppLocalizations.of(context)!.updated,
      AuditAction.delete => AppLocalizations.of(context)!.deleted,
      AuditAction.void_ => AppLocalizations.of(context)!.voided,
    };
  }
}
