/// Create bill screen.
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../application/providers/notification_settings_providers.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/bill.dart';
import '../../../data/database/tables/bill_table.dart' as db;
import '../../../data/database/tables/notification_setting_table.dart';
import '../../../services/image_service.dart';
import '../../../services/billing_cycle_service.dart';
import '../../../services/local_notification_service.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../../../core/utils/l10n_helpers.dart';
import 'widgets/contextual_profile_sheet.dart';

/// Bottom sheet to create a new bill.
class CreateBillSheet extends ConsumerStatefulWidget {
  final int occupancyId;
  final int roomId;
  final String roomNumber;
  final double agreedRent;
  final bool hasElectricityMeter;
  final double electricityRate;

  /// Optional: Pre-fill period start from anniversary-based billing cycle
  final DateTime? suggestedPeriodStart;

  /// Optional: Pre-fill period end from anniversary-based billing cycle
  final DateTime? suggestedPeriodEnd;

  /// Billing start date for cycle calculations (use effectiveBillingStartDate from occupancy)
  final DateTime? billingStartDate;

  /// Optional: Pre-select bill type
  final BillType? initialBillType;

  /// Optional: Agreement end date to show warnings
  final DateTime? agreementEndDate;

  const CreateBillSheet({
    super.key,
    required this.occupancyId,
    required this.roomId,
    required this.roomNumber,
    required this.agreedRent,
    required this.hasElectricityMeter,
    required this.electricityRate,
    this.suggestedPeriodStart,
    this.suggestedPeriodEnd,
    this.billingStartDate,
    this.initialBillType,
    this.agreementEndDate,
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
  // Stores only the relative filename (e.g. 'img_123.jpg'), not the absolute path.
  String? _meterPhoto;

  // Mutable cycle state for navigation
  DateTime? _currentPeriodStart;
  DateTime? _currentPeriodEnd;
  int _currentCycleNumber = 0;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.agreedRent.toStringAsFixed(0);
    _electricityRate = widget.electricityRate;
    _electricityRateController.text = widget.electricityRate.toStringAsFixed(2);

    // Pre-select bill type if provided
    if (widget.initialBillType != null) {
      _selectedBillType = widget.initialBillType!;
    }

    // Pre-select month/year from suggested cycle dates if provided
    if (widget.suggestedPeriodStart != null) {
      _billingMonth = widget.suggestedPeriodStart!.month;
      _billingYear = widget.suggestedPeriodStart!.year;
    }

    // If date-to-date, use the cycle start date
    _currentPeriodStart = widget.suggestedPeriodStart;
    _currentPeriodEnd = widget.suggestedPeriodEnd;

    // Calculate cycle number if move-in date provided
    if (widget.billingStartDate != null &&
        widget.suggestedPeriodStart != null) {
      _currentCycleNumber = BillingCycleService.getCycleNumber(
        widget.billingStartDate!,
        widget.suggestedPeriodStart!,
      );
    }

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

  String _getMonthName(BuildContext context, int month) {
    final l10n = AppLocalizations.of(context)!;
    final months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december,
    ];
    return months[month - 1];
  }

  /// Formats a date as "Jan 15" or "Feb 14"
  String _formatShortDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final shortMonths = [
      l10n.jan,
      l10n.feb,
      l10n.mar,
      l10n.apr,
      l10n.mayShort,
      l10n.jun,
      l10n.jul,
      l10n.aug,
      l10n.sep,
      l10n.oct,
      l10n.nov,
      l10n.dec,
    ];
    return '${shortMonths[date.month - 1]} ${date.day}';
  }

  /// Builds the billing period section - shows anniversary-based dates if enabled,
  /// or month/year picker for bill types without anniversary
  Widget _buildBillingPeriodSection(BuildContext context, List<String> months) {
    // Watch bill settings to reactively update UI when anniversary settings change
    final settingsAsync = ref.watch(billSettingsProvider);

    return settingsAsync.when(
      loading: () => _buildMonthYearPicker(context, months),
      error: (_, __) => _buildMonthYearPicker(context, months),
      data: (settings) {
        // Check if the selected bill type uses anniversary billing
        final defaultToDateToDate = switch (_selectedBillType) {
          BillType.rent => settings.rentUsesDateToDate,
          BillType.electricity => settings.electricityUsesDateToDate,
          BillType.water => settings.waterUsesDateToDate,
          BillType.maintenance => settings.maintenanceUsesDateToDate,
          BillType.other => settings.otherUsesDateToDate,
        };

        if (!defaultToDateToDate || widget.billingStartDate == null) {
          // Bill type doesn't use anniversary billing
          return _buildMonthYearPicker(context, months);
        }

        // Fetch the correct cycle for this bill type
        final cycleAsync = ref.watch(
          nextBillingCycleForBillTypeProvider(
            widget.occupancyId,
            _selectedBillType,
          ),
        );

        return cycleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildMonthYearPicker(context, months),
          data: (cycle) {
            // Use the fetched cycle as the base, but respect user navigation
            final effectiveStart = _currentPeriodStart ?? cycle.start;
            final effectiveEnd = _currentPeriodEnd ?? cycle.end;

            // Update internal state if not already set (initial load)
            if (_currentPeriodStart == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _currentPeriodStart = cycle.start;
                    _currentPeriodEnd = cycle.end;
                    // Calculate cycle number using static method
                    _currentCycleNumber = BillingCycleService.getCycleNumber(
                      widget.billingStartDate!,
                      cycle.start,
                    );
                  });
                }
              });
            }

            return _buildDateToDatePeriodDisplayWithCycle(
              context,
              effectiveStart,
              effectiveEnd,
            );
          },
        );
      },
    );
  }

  /// Displays the date-to-date based billing period with navigation
  /// Uses provided cycle dates
  Widget _buildDateToDatePeriodDisplayWithCycle(
    BuildContext context,
    DateTime start,
    DateTime end,
  ) {
    final theme = Theme.of(context);

    // Determine if this is a past/future cycle for UI hints
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isFutureCycle = start.isAfter(today);
    final isPastCycle = end.isBefore(today);
    final canNavigate = widget.billingStartDate != null;

    final bool exceedsAgreement =
        widget.agreementEndDate != null &&
        end.isAfter(widget.agreementEndDate!);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Header with "Anniversary" badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.dateToDate,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPastCycle) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.overdueU,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ] else if (isFutureCycle) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.advance,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.currentLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Date range display with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (canNavigate)
                IconButton(
                  onPressed: _currentCycleNumber > 0 ? _goToPreviousCycle : null,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: AppLocalizations.of(context)!.previousCycle,
                )
              else
                const SizedBox(width: 48),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_formatShortDate(context, start)} - ${_formatShortDate(context, end)}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      start.year == end.year
                          ? '${start.year}'
                          : '${start.year} - ${end.year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (canNavigate)
                IconButton(
                  onPressed: _goToNextCycle,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: AppLocalizations.of(context)!.nextCycle,
                )
              else
                const SizedBox(width: 48),
            ],
          ),

          if (exceedsAgreement) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.cycleExceedsAgreementWarning(
                        '${widget.agreementEndDate!.day}/${widget.agreementEndDate!.month}/${widget.agreementEndDate!.year}',
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Displays the anniversary-based billing period with navigation
  void _goToPreviousCycle() {
    if (widget.billingStartDate == null || _currentCycleNumber <= 0) return;

    setState(() {
      _currentCycleNumber--;
      final cycle = BillingCycleService.getCycleByNumber(
        widget.billingStartDate!,
        _currentCycleNumber,
      );
      _currentPeriodStart = cycle.start;
      _currentPeriodEnd = cycle.end;
      _billingMonth = cycle.start.month;
      _billingYear = cycle.start.year;
    });
  }

  void _goToNextCycle() {
    if (widget.billingStartDate == null) return;

    setState(() {
      _currentCycleNumber++;
      final cycle = BillingCycleService.getCycleByNumber(
        widget.billingStartDate!,
        _currentCycleNumber,
      );
      _currentPeriodStart = cycle.start;
      _currentPeriodEnd = cycle.end;
      _billingMonth = cycle.start.month;
      _billingYear = cycle.start.year;
    });
  }

  /// Builds the traditional month/year picker for non-rent bills
  Widget _buildMonthYearPicker(BuildContext context, List<String> months) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            initialValue: _billingMonth,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.monthLabel,
            ),
            items: List.generate(12, (i) {
              return DropdownMenuItem(value: i + 1, child: Text(months[i]));
            }),
            onChanged: (v) => setState(() => _billingMonth = v!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<int>(
            initialValue: _billingYear,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.yearLabel,
            ),
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
    );
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
      // pickAndSaveImage returns the relative filename for DB storage
      final fileName = await imageService.pickAndSaveImage(source: source);
      if (fileName != null) {
        setState(() => _meterPhoto = fileName);
      }
    }
  }

  Future<void> _saveBill() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if Landlord profile is complete
    final isProfileComplete = await ContextualProfileSheet.ensureProfile(
      context,
      ref,
    );
    if (!isProfileComplete) return;

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
            insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            title: Text(AppLocalizations.of(context)!.billAlreadyExists),
            content: Text(
              AppLocalizations.of(context)!.duplicateBillMessage(
                _selectedBillType.name,
                _getMonthName(context, _billingMonth),
                _billingYear,
                existingBill.billNumber ?? AppLocalizations.of(context)!.draft,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context)!.createAnyway),
              ),
            ],
          ),
        );

        if (proceed != true) {
          setState(() => _isLoading = false);
          return;
        }
      }

      // Calculate period dates - use mutable cycle state (from navigation),
      // falling back to suggested dates, then to calendar month dates
      final periodStart =
          _currentPeriodStart ??
          widget.suggestedPeriodStart ??
          DateTime(_billingYear, _billingMonth, 1);
      final periodEnd =
          _currentPeriodEnd ??
          widget.suggestedPeriodEnd ??
          DateTime(_billingYear, _billingMonth + 1, 0);

      // Get configurable due date offset from settings
      final settings = await ref.read(billSettingsProvider.future);
      final hasDateToDateDates =
          _currentPeriodEnd != null || widget.suggestedPeriodEnd != null;
      final calculatedDueDate = hasDateToDateDates
          ? periodEnd.add(Duration(days: settings.dueDateOffsetDays))
          : periodStart.add(const Duration(days: 10));

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
        meterPhotoPath: _meterPhoto,
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
        ref.invalidate(billingAttentionListProvider); // Refresh attention list!
        Navigator.pop(context, true);

        // Show appropriate message
        if (_selectedBillType == BillType.electricity &&
            _electricityRate != widget.electricityRate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(
                  context,
                )!.billCreatedWithRate(_electricityRate.toStringAsFixed(2)),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.billCreated)),
          );
        }

        // Trigger notifications
        final notificationService = LocalNotificationService();
        final notificationSettings = ref.read(
          notificationSettingsNotifierProvider,
        );

        // Get the created bill to schedule notifications
        final createdBills = await repo.getBillsForOccupancy(
          widget.occupancyId,
        );
        if (createdBills.isNotEmpty) {
          createdBills.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final createdBill = createdBills.first;

          // Show confirmation notification
          await notificationService.showBillCreatedConfirmation(
            roomNumber: widget.roomNumber,
            tenantName: createdBill.tenantName ?? 'Tenant',
            amount: createdBill.amount,
            period: createdBill.billingPeriod,
          );

          if (notificationSettings.isEnabled(NotificationType.billDueSoon)) {
            await notificationService.scheduleDueBillReminder(
              bill: createdBill,
              daysBefore: notificationSettings.getDaysBefore(
                NotificationType.billDueSoon,
              ),
              notificationHour: notificationSettings.notificationHour,
            );
          }

          final overdueDays = <int>{
            if (notificationSettings.isEnabled(NotificationType.overdue1Day)) 1,
            if (notificationSettings.isEnabled(NotificationType.overdue3Days))
              3,
            if (notificationSettings.isEnabled(NotificationType.overdue7Days))
              7,
            if (notificationSettings.isEnabled(NotificationType.overdue14Days))
              14,
          };

          if (overdueDays.isNotEmpty) {
            await notificationService.scheduleOverdueEscalation(
              bill: createdBill,
              escalationDays: overdueDays,
              notificationHour: notificationSettings.notificationHour,
              pauseOnPartialPayment: notificationSettings.isEnabled(
                NotificationType.partialPaymentPause,
              ),
              partialPaymentThresholdRatio: 0.5,
            );
          }

          if (notificationSettings.isEnabled(
                NotificationType.utilityUsageAnomaly,
              ) &&
              createdBill.billType == BillType.electricity) {
            final electricityBills = createdBills
                .where(
                  (b) =>
                      b.billType == BillType.electricity &&
                      b.electricityPrevReading != null &&
                      b.electricityCurrReading != null &&
                      b.electricityCurrReading! >= b.electricityPrevReading!,
                )
                .toList();

            if (electricityBills.length >= 2) {
              electricityBills.sort((a, b) {
                final aDate = a.periodEndDate ?? a.createdAt;
                final bDate = b.periodEndDate ?? b.createdAt;
                return aDate.compareTo(bDate);
              });

              final latest = electricityBills[electricityBills.length - 1];
              final previous = electricityBills[electricityBills.length - 2];

              final latestUnits =
                  (latest.electricityCurrReading! -
                          latest.electricityPrevReading!)
                      .round();
              final previousUnits =
                  (previous.electricityCurrReading! -
                          previous.electricityPrevReading!)
                      .round();

              if (latestUnits > 0 && previousUnits > 0) {
                final increasePercent =
                    ((latestUnits - previousUnits) / previousUnits) * 100;
                final hasSpike =
                    increasePercent >= 35 &&
                    (latestUnits - previousUnits) >= 25;

                if (hasSpike) {
                  await notificationService.scheduleUtilityUsageAnomalyReminder(
                    occupancyId: widget.occupancyId,
                    tenantName: createdBill.tenantName ?? 'Tenant',
                    roomNumber: widget.roomNumber,
                    currentUnits: latestUnits,
                    previousUnits: previousUnits,
                    increasePercent: increasePercent,
                    notificationHour: notificationSettings.notificationHour,
                  );
                }
              }
            }
          }
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
    final l10n = AppLocalizations.of(context)!;
    final months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december,
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
                            AppLocalizations.of(context)!.createBill,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.roomNumber(widget.roomNumber),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
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
                    AppLocalizations.of(context)!.type,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: BillType.values.map((type) {
                      final isSelected = _selectedBillType == type;
                      return FilterChip(
                        label: Text(
                          getBillTypeLabel(
                            AppLocalizations.of(context)!,
                            type,
                          ).toUpperCase(),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedBillType = type;
                            // Reset cycle state so new cycle is fetched for new bill type
                            _currentPeriodStart = null;
                            _currentPeriodEnd = null;
                            _currentCycleNumber = 0;
                          });
                          _updateAmount();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Billing period
                  _buildBillingPeriodSection(context, months),
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
                                  AppLocalizations.of(context)!.meterReadings,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.meterTrackingExplanation,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Meter reading inputs
                            Row(
                              children: [
                                Expanded(
                                  child: _MeterReadingInput(
                                    label: AppLocalizations.of(
                                      context,
                                    )!.previous,
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
                                    label: AppLocalizations.of(
                                      context,
                                    )!.current,
                                    controller: _currReadingController,
                                    onChanged: (_) =>
                                        _calculateElectricityCharges(),
                                    validator: (v) => validatePositiveNumber(
                                      v,
                                      AppLocalizations.of(
                                        context,
                                      )!.currentReading,
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
                                  AppLocalizations.of(context)!.ratePerUnit,
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
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.electricityCalculation,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.unitsCalculation(
                                      ((double.tryParse(
                                                    _currReadingController.text,
                                                  ) ??
                                                  0) -
                                              (double.tryParse(
                                                    _prevReadingController.text,
                                                  ) ??
                                                  0))
                                          .toStringAsFixed(0),
                                      formatCurrency(_electricityRate),
                                    ),
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                                        ? Theme.of(context).colorScheme.tertiary
                                        : Colors.grey.shade300,
                                    width: _meterPhoto != null ? 2 : 1,
                                  ),
                                  image: _meterPhoto != null
                                      ? DecorationImage(
                                          image: FileImage(
                                            File(
                                              ImageService.resolveImagePathSync(
                                                _meterPhoto!,
                                              ),
                                            ),
                                          ),
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
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.tertiary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _meterPhoto != null
                                              ? AppLocalizations.of(
                                                  context,
                                                )!.meterPhotoAdded
                                              : AppLocalizations.of(
                                                  context,
                                                )!.addMeterPhoto,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: _meterPhoto != null
                                                    ? Theme.of(
                                                        context,
                                                      ).colorScheme.tertiary
                                                    : null,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _meterPhoto != null
                                          ? AppLocalizations.of(
                                              context,
                                            )!.tapToChangePhoto
                                          : AppLocalizations.of(
                                              context,
                                            )!.optionalVerification,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
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
                                  tooltip: AppLocalizations.of(
                                    context,
                                  )!.removePhoto,
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.billAmountLabel,
                      prefixIcon: const Icon(Icons.currency_rupee),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => validatePositiveNumber(
                      v,
                      AppLocalizations.of(context)!.amount,
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
                          : Text(AppLocalizations.of(context)!.createBill),
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
            AppLocalizations.of(context)!.units,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
