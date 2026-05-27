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
import '../../../core/utils/l10n_helpers.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../services/image_service.dart';

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
  // Stores only the relative filename, not absolute path.
  String? _meterPhoto;
  String? _existingPhotoPath;

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
    _existingPhotoPath = widget.bill.meterPhotoPath;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
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

    if (source != null) {
      final imageService = ImageService();
      final fileName = await imageService.pickAndSaveImage(source: source);
      if (fileName != null) {
        setState(() => _meterPhoto = fileName);
      }
    }
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
            AppLocalizations.of(
              context,
            )!.amountCannotBeLessThanPaid(formatCurrency(_minimumAmount)),
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
        meterPhotoPath:
            _meterPhoto ??
            _existingPhotoPath, // Use filename stored from new pick or existing
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.billUpdatedSuccessfully,
            ),
          ),
        );
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

    // Check if there is a photo to display
    final hasPhoto =
        _meterPhoto != null ||
        (_existingPhotoPath != null && _existingPhotoPath!.isNotEmpty);

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
                      AppLocalizations.of(context)!.editBill,
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
                            AppLocalizations.of(
                              context,
                            )!.partiallyPaidBillWarning,
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
                        '${getBillTypeLabel(AppLocalizations.of(context)!, widget.bill.billType).toUpperCase()} - ${widget.bill.billingPeriod}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_hasPayments) ...[
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.paidAmount(formatCurrency(widget.bill.paidAmount)),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Meter Photo Section (Only for electricity bills)
                if (widget.bill.billType == BillType.electricity) ...[
                  Text(
                    AppLocalizations.of(context)!.meterPhoto,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (hasPhoto)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _meterPhoto != null
                              ? Image.file(
                                  File(
                                    ImageService.resolveImagePathSync(
                                      _meterPhoto!,
                                    ),
                                  ),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(
                                    ImageService.resolveImagePathSync(
                                      _existingPhotoPath!,
                                    ),
                                  ),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    height: 150,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: _pickMeterPhoto,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    InkWell(
                      onTap: _pickMeterPhoto,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 32,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)!.addMeterPhoto,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],

                // Amount (disabled if has payments, or show min value info)
                TextFormField(
                  controller: _amountController,
                  enabled: _canEditAmount,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.billAmountLabel,
                    prefixIcon: const Icon(Icons.currency_rupee),
                    helperText: _hasPayments
                        ? AppLocalizations.of(
                            context,
                          )!.minAmount(formatCurrency(widget.bill.paidAmount))
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => validatePositiveNumber(
                    v,
                    AppLocalizations.of(context)!.amountLabel,
                  ),
                ),
                const SizedBox(height: 16),

                // Due date
                InkWell(
                  onTap: _selectDueDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.dueDate,
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
                          : AppLocalizations.of(context)!.notSet,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.notesOptional,
                    prefixIcon: const Icon(Icons.note_outlined),
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
                        : Text(AppLocalizations.of(context)!.saveChanges),
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
