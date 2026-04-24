import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/notification_settings_providers.dart';
import '../../../data/database/tables/notification_setting_table.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/billing_status.dart';
import '../../../services/local_notification_service.dart';
import 'dart:async';
import 'package:rent_khata/l10n/app_localizations.dart';

enum _SaveStatus { idle, saving, saved, error }

/// Notification settings screen with granular controls
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  // Local state for immediate UI feedback
  late NotificationSettingsState _localState;
  Timer? _debounceTimer;
  bool _initialized = false;
  _SaveStatus _saveStatus = _SaveStatus.idle;

  @override
  void initState() {
    super.initState();
    // Initialize with default/empty state, will be updated from provider
    _localState = const NotificationSettingsState(
      enabledSettings: {},
      daysBeforeSettings: {},
      notificationHour: 9,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateLocalState(NotificationSettingsState newState) {
    if (!mounted) return;
    setState(() {
      _localState = newState;
    });
    _saveDebounced();
  }

  void _saveDebounced() {
    setState(() => _saveStatus = _SaveStatus.saving);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), _saveSettings);
  }

  Future<void> _saveSettings() async {
    try {
      final notificationService = LocalNotificationService();

      // Save settings to database
      await ref
          .read(notificationSettingsNotifierProvider.notifier)
          .saveAllSettings(
            enabledSettings: _localState.enabledSettings,
            daysBeforeSettings: _localState.daysBeforeSettings,
            notificationHour: _localState.notificationHour,
          );

      // Re-schedule based on new settings
      final hasPermission = await notificationService.requestPermission();
      if (hasPermission) {
        await _rescheduleNotifications(notificationService);
      }

      if (mounted) {
        setState(() => _saveStatus = _SaveStatus.saved);

        // Return to idle after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _saveStatus == _SaveStatus.saved) {
            setState(() => _saveStatus = _SaveStatus.idle);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saveStatus = _SaveStatus.error);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.errorPrefix}$e')));
      }
    }
  }

  Future<void> _rescheduleNotifications(
    LocalNotificationService service,
  ) async {
    // Cancel all existing notifications first
    await service.cancelAll();

    // Get all unpaid bills and schedule based on settings
    final bills = await ref.read(unpaidBillsProvider.future);

    bool billDueSoon = _localState.isEnabled(NotificationType.billDueSoon);
    int dueSoonDays = _localState.getDaysBefore(NotificationType.billDueSoon);

    final enabledOverdueDays = <int>{
      if (_localState.isEnabled(NotificationType.overdue1Day)) 1,
      if (_localState.isEnabled(NotificationType.overdue3Days)) 3,
      if (_localState.isEnabled(NotificationType.overdue7Days)) 7,
      if (_localState.isEnabled(NotificationType.overdue14Days)) 14,
    };

    for (final bill in bills) {
      if (bill.dueDate == null) continue;

      // Schedule due soon reminder
      if (billDueSoon) {
        await service.scheduleDueBillReminder(
          bill: bill,
          daysBefore: dueSoonDays,
          notificationHour: _localState.notificationHour,
        );
      }

      // Schedule overdue escalation
      if (enabledOverdueDays.isNotEmpty) {
        await service.scheduleOverdueEscalation(
          bill: bill,
          escalationDays: enabledOverdueDays,
          notificationHour: _localState.notificationHour,
          pauseOnPartialPayment: _localState.isEnabled(
            NotificationType.partialPaymentPause,
          ),
          partialPaymentThresholdRatio: 0.5,
        );
      }
    }

    // Schedule cycle ending reminders if enabled
    if (_localState.isEnabled(NotificationType.cycleEndingSoon)) {
      final occupancies = await ref.read(activeOccupanciesProvider.future);
      final cycleData =
          <
            ({
              int occupancyId,
              String tenantName,
              String roomNumber,
              DateTime cycleEndDate,
            })
          >[];

      for (final occupancy in occupancies) {
        final cycle = ref.read(currentBillingCycleProvider(occupancy));
        cycleData.add((
          occupancyId: occupancy.id,
          tenantName: occupancy.tenantName ?? 'Tenant',
          roomNumber: occupancy.roomNumber ?? 'Room',
          cycleEndDate: cycle.end,
        ));
      }

      await service.scheduleAllCycleReminders(
        occupancies: cycleData,
        daysBefore: _localState.getDaysBefore(NotificationType.cycleEndingSoon),
        notificationHour: _localState.notificationHour,
      );
    }

    if (_localState.isEnabled(NotificationType.agreementExpiringSoon)) {
      final occupancies = await ref.read(activeOccupanciesProvider.future);
      final agreementData =
          <
            ({
              int occupancyId,
              String tenantName,
              String roomNumber,
              DateTime agreementEndDate,
            })
          >[];

      for (final occupancy in occupancies) {
        final endDate = occupancy.agreementEndDate;
        if (endDate == null) continue;

        agreementData.add((
          occupancyId: occupancy.id,
          tenantName: occupancy.tenantName ?? 'Tenant',
          roomNumber: occupancy.roomNumber ?? 'Room',
          agreementEndDate: endDate,
        ));
      }

      await service.scheduleAllAgreementExpiryReminders(
        occupancies: agreementData,
        daysBefore: _localState.getDaysBefore(
          NotificationType.agreementExpiringSoon,
        ),
        notificationHour: _localState.notificationHour,
      );
    }

    if (_localState.isEnabled(NotificationType.agreementExpired)) {
      final graceDays = _localState
          .getDaysBefore(NotificationType.agreementExpired)
          .clamp(0, 30);
      final occupancies = await ref.read(activeOccupanciesProvider.future);

      for (final occupancy in occupancies) {
        final endDate = occupancy.agreementEndDate;
        if (endDate == null) continue;

        await service.scheduleAgreementExpiredReminder(
          occupancyId: occupancy.id,
          tenantName: occupancy.tenantName ?? 'Tenant',
          roomNumber: occupancy.roomNumber ?? 'Room',
          agreementEndDate: endDate,
          graceDays: graceDays,
          notificationHour: _localState.notificationHour,
        );
      }
    }

    // Bill generation reminders for due-soon/overdue cycles.
    if (_localState.isEnabled(NotificationType.billNotGenerated)) {
      final leadDays = _localState
          .getDaysBefore(NotificationType.billNotGenerated)
          .clamp(0, 14);
      final attentionItems = await ref.read(
        billingAttentionListProvider.future,
      );
      final scheduledKeys = <String>{};

      for (final item in attentionItems) {
        final shouldAlert =
            item.status == BillingCycleStatus.overdue ||
            item.daysUntilCycleEnd <= leadDays;
        if (!shouldAlert) continue;

        final key = '${item.occupancyId}-${item.billType.index}';
        if (!scheduledKeys.add(key)) continue;

        await service.scheduleBillGenerationReminder(
          occupancyId: item.occupancyId,
          billType: item.billType,
          tenantName: item.tenantName,
          roomNumber: item.roomNumber,
          cycleEndDate: item.cycleEnd,
          daysUntilCycleEnd: item.daysUntilCycleEnd,
          notificationHour: _localState.notificationHour,
        );
      }
    }

    // Deposit settlement reminders after move-out.
    if (_localState.isEnabled(NotificationType.depositSettlementDue)) {
      final daysAfterMoveOut = _localState
          .getDaysBefore(NotificationType.depositSettlementDue)
          .clamp(1, 30);
      final db = ref.read(appDatabaseProvider);
      final unsettled =
          await (db.select(db.occupancies)..where(
                (o) =>
                    o.isActive.equals(false) &
                    o.moveOutDate.isNotNull() &
                    o.isSettled.equals(false),
              ))
              .get();

      for (final occupancy in unsettled) {
        if (occupancy.securityDeposit <= 0 || occupancy.moveOutDate == null) {
          continue;
        }

        final tenant = await db.tenantDao.getTenantById(occupancy.tenantId);
        final room = await db.propertyDao.getRoomById(occupancy.roomId);

        await service.scheduleDepositSettlementDueReminder(
          occupancyId: occupancy.id,
          tenantName: tenant?.name ?? 'Tenant',
          roomNumber: room?.roomNumber ?? 'Room',
          moveOutDate: occupancy.moveOutDate!,
          daysAfterMoveOut: daysAfterMoveOut,
          notificationHour: _localState.notificationHour,
        );
      }
    }

    // High utility usage anomaly reminders.
    if (_localState.isEnabled(NotificationType.utilityUsageAnomaly)) {
      final occupancies = await ref.read(activeOccupanciesProvider.future);
      final billingRepo = ref.read(billingRepositoryProvider);

      for (final occupancy in occupancies) {
        final bills = await billingRepo.getBillsForOccupancy(occupancy.id);
        final electricityBills = bills
            .where(
              (b) =>
                  b.billType == BillType.electricity &&
                  b.electricityPrevReading != null &&
                  b.electricityCurrReading != null &&
                  b.electricityCurrReading! >= b.electricityPrevReading!,
            )
            .toList();

        if (electricityBills.length < 2) continue;

        electricityBills.sort((a, b) {
          final aDate = a.periodEndDate ?? a.createdAt;
          final bDate = b.periodEndDate ?? b.createdAt;
          return aDate.compareTo(bDate);
        });

        final latest = electricityBills[electricityBills.length - 1];
        final previous = electricityBills[electricityBills.length - 2];

        final latestUnits =
            (latest.electricityCurrReading! - latest.electricityPrevReading!)
                .round();
        final previousUnits =
            (previous.electricityCurrReading! -
                    previous.electricityPrevReading!)
                .round();

        if (latestUnits <= 0 || previousUnits <= 0) continue;

        final increasePercent =
            ((latestUnits - previousUnits) / previousUnits) * 100;
        final hasSpike =
            increasePercent >= 35 && (latestUnits - previousUnits) >= 25;
        if (!hasSpike) continue;

        await service.scheduleUtilityUsageAnomalyReminder(
          occupancyId: occupancy.id,
          tenantName: occupancy.tenantName ?? 'Tenant',
          roomNumber: occupancy.roomNumber ?? 'Room',
          currentUnits: latestUnits,
          previousUnits: previousUnits,
          increasePercent: increasePercent,
          notificationHour: _localState.notificationHour,
        );
      }
    }
  }

  // Helper to toggle a boolean setting
  void _toggleSetting(NotificationType type, bool value) {
    HapticFeedback.lightImpact();
    var newEnabled = Map<NotificationType, bool>.from(
      _localState.enabledSettings,
    );
    newEnabled[type] = value;
    _updateLocalState(_localState.copyWith(enabledSettings: newEnabled));
  }

  // Helper to update days before
  void _updateDaysBefore(NotificationType type, int days) {
    if (days != _localState.daysBeforeSettings[type]) {
      HapticFeedback.selectionClick();
    }
    var newDays = Map<NotificationType, int>.from(
      _localState.daysBeforeSettings,
    );
    newDays[type] = days;
    _updateLocalState(_localState.copyWith(daysBeforeSettings: newDays));
  }

  // Helper to update hour
  void _updateHour(int hour) {
    HapticFeedback.lightImpact();
    _updateLocalState(_localState.copyWith(notificationHour: hour));
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(notificationSettingsNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    // Sync local state with provider state only once when loaded
    if (!_initialized && !providerState.isLoading) {
      _localState = providerState;
      _initialized = true;
    }

    // If completely loading for first time
    if (providerState.isLoading && !_initialized) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.notificationSettings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationSettings),
        actions: [_buildAppBarStatus(), const SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.changesSavedAutomatically,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Billing Reminders Section
            _buildSectionHeader(
              icon: Icons.calendar_today_outlined,
              title: l10n.billingReminders,
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildToggleWithSlider(
              title: l10n.billingCycleEnding,
              subtitle: l10n.remindDaysBeforeCycleEnds(
                _localState.getDaysBefore(NotificationType.cycleEndingSoon),
              ),
              value: _localState.isEnabled(NotificationType.cycleEndingSoon),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.cycleEndingSoon, v),
              sliderValue: _localState
                  .getDaysBefore(NotificationType.cycleEndingSoon)
                  .toDouble(),
              sliderMin: 1,
              sliderMax: 7,
              onSliderChanged: (v) => _updateDaysBefore(
                NotificationType.cycleEndingSoon,
                v.round(),
              ),
            ),
            _buildToggleWithSlider(
              title: l10n.billDueSoon,
              subtitle: l10n.remindDaysBeforeDueDate(
                _localState.getDaysBefore(NotificationType.billDueSoon),
              ),
              value: _localState.isEnabled(NotificationType.billDueSoon),
              onChanged: (v) => _toggleSetting(NotificationType.billDueSoon, v),
              sliderValue: _localState
                  .getDaysBefore(NotificationType.billDueSoon)
                  .toDouble(),
              sliderMin: 1,
              sliderMax: 7,
              onSliderChanged: (v) =>
                  _updateDaysBefore(NotificationType.billDueSoon, v.round()),
            ),
            _buildToggleWithSlider(
              title: l10n.renewAgreements,
              subtitle: l10n.remindDaysBeforeCycleEnds(
                _localState
                    .getDaysBefore(NotificationType.agreementExpiringSoon)
                    .clamp(7, 60),
              ),
              value: _localState.isEnabled(
                NotificationType.agreementExpiringSoon,
              ),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.agreementExpiringSoon, v),
              sliderValue: _localState
                  .getDaysBefore(NotificationType.agreementExpiringSoon)
                  .clamp(7, 60)
                  .toDouble(),
              sliderMin: 7,
              sliderMax: 60,
              onSliderChanged: (v) => _updateDaysBefore(
                NotificationType.agreementExpiringSoon,
                v.round(),
              ),
            ),
            const Divider(height: 32),

            // Overdue Escalation Section
            _buildSectionHeader(
              icon: Icons.warning_amber_outlined,
              title: l10n.overdueFollowUps,
              color: Theme.of(context).colorScheme.error,
            ),
            _buildSimpleToggle(
              title: l10n.oneDayOverdue,
              subtitle: l10n.firstReminderAfterDueDate,
              value: _localState.isEnabled(NotificationType.overdue1Day),
              onChanged: (v) => _toggleSetting(NotificationType.overdue1Day, v),
            ),
            _buildSimpleToggle(
              title: l10n.threeDaysOverdue,
              subtitle: l10n.secondReminder,
              value: _localState.isEnabled(NotificationType.overdue3Days),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.overdue3Days, v),
            ),
            _buildSimpleToggle(
              title: l10n.oneWeekOverdue,
              subtitle: l10n.weeklyReminder,
              value: _localState.isEnabled(NotificationType.overdue7Days),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.overdue7Days, v),
            ),
            _buildSimpleToggle(
              title: l10n.twoWeeksOverdue,
              subtitle: l10n.criticalUrgentAttention,
              value: _localState.isEnabled(NotificationType.overdue14Days),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.overdue14Days, v),
            ),
            const Divider(height: 32),

            // Smart Alerts Section
            _buildSectionHeader(
              icon: Icons.auto_awesome_outlined,
              title: 'Smart Alerts',
              color: Theme.of(context).colorScheme.tertiary,
            ),
            _buildToggleWithSlider(
              title: 'Agreement already expired',
              subtitle:
                  'Remind after ${_localState.getDaysBefore(NotificationType.agreementExpired).clamp(0, 30)} day(s) past agreement end date',
              value: _localState.isEnabled(NotificationType.agreementExpired),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.agreementExpired, v),
              sliderValue: _localState
                  .getDaysBefore(NotificationType.agreementExpired)
                  .clamp(0, 30)
                  .toDouble(),
              sliderMin: 0,
              sliderMax: 30,
              onSliderChanged: (v) => _updateDaysBefore(
                NotificationType.agreementExpired,
                v.round(),
              ),
            ),
            _buildToggleWithSlider(
              title: 'Bill not generated reminder',
              subtitle:
                  'Alert when cycle is overdue or within ${_localState.getDaysBefore(NotificationType.billNotGenerated).clamp(0, 14)} day(s) of ending',
              value: _localState.isEnabled(NotificationType.billNotGenerated),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.billNotGenerated, v),
              sliderValue: _localState
                  .getDaysBefore(NotificationType.billNotGenerated)
                  .clamp(0, 14)
                  .toDouble(),
              sliderMin: 0,
              sliderMax: 14,
              onSliderChanged: (v) => _updateDaysBefore(
                NotificationType.billNotGenerated,
                v.round(),
              ),
            ),
            _buildSimpleToggle(
              title: 'Pause overdue follow-ups after partial payment',
              subtitle: 'Pauses escalations once paid amount reaches 50%',
              value: _localState.isEnabled(
                NotificationType.partialPaymentPause,
              ),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.partialPaymentPause, v),
            ),
            _buildToggleWithSlider(
              title: 'Deposit settlement due after move-out',
              subtitle:
                  'Remind after ${_localState.getDaysBefore(NotificationType.depositSettlementDue).clamp(1, 30)} day(s) if settlement is pending',
              value: _localState.isEnabled(
                NotificationType.depositSettlementDue,
              ),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.depositSettlementDue, v),
              sliderValue: _localState
                  .getDaysBefore(NotificationType.depositSettlementDue)
                  .clamp(1, 30)
                  .toDouble(),
              sliderMin: 1,
              sliderMax: 30,
              onSliderChanged: (v) => _updateDaysBefore(
                NotificationType.depositSettlementDue,
                v.round(),
              ),
            ),
            _buildSimpleToggle(
              title: 'High utility usage anomaly',
              subtitle: 'Alerts when latest electricity usage spikes sharply',
              value: _localState.isEnabled(
                NotificationType.utilityUsageAnomaly,
              ),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.utilityUsageAnomaly, v),
            ),
            const Divider(height: 32),

            // General Settings Section
            _buildSectionHeader(
              icon: Icons.settings_outlined,
              title: l10n.generalSettingsLabel,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.notificationTime),
              subtitle: Text(_formatHour(_localState.notificationHour, l10n)),
              trailing: DropdownButton<int>(
                value: _localState.notificationHour,
                underline: const SizedBox(),
                items: [7, 8, 9, 10, 11, 12]
                    .map(
                      (h) => DropdownMenuItem(
                        value: h,
                        child: Text(_formatHour(h, l10n)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) _updateHour(v);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Test button (debug only)
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.notifications_active),
                    label: Text(l10n.sendTestNotification),
                    onPressed: () => _sendTestNotification(l10n),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarStatus() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_saveStatus) {
        _SaveStatus.saving => const SizedBox(
          key: ValueKey('saving'),
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        _SaveStatus.saved => Icon(
          Icons.check_circle_outline,
          key: const ValueKey('saved'),
          color: Colors.green.shade600,
        ),
        _SaveStatus.error => Icon(
          Icons.error_outline,
          key: const ValueKey('error'),
          color: Theme.of(context).colorScheme.error,
        ),
        _SaveStatus.idle => const SizedBox(key: ValueKey('idle')),
      },
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildToggleWithSlider({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required double sliderValue,
    required double sliderMin,
    required double sliderMax,
    required ValueChanged<double> onSliderChanged,
  }) {
    final safeValue = sliderValue.clamp(sliderMin, sliderMax).toDouble();

    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          subtitle: Text(subtitle),
          value: value,
          onChanged: onChanged,
        ),
        if (value)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Slider(
              value: safeValue,
              min: sliderMin,
              max: sliderMax,
              divisions: (sliderMax - sliderMin).round(),
              label: '${safeValue.round()} days',
              onChanged: onSliderChanged,
            ),
          ),
      ],
    );
  }

  String _formatHour(int hour, AppLocalizations l10n) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  Future<void> _sendTestNotification(AppLocalizations l10n) async {
    // ... same as before
    try {
      final notificationService = LocalNotificationService();
      // Ensure initialized
      await notificationService.initialize();
      final granted = await notificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.permissionDenied)));
        }
        return;
      }
      await notificationService.showNotification(
        id: 12345,
        title: l10n.testNotificationTitle,
        body: l10n.notificationsWorking,
        payload: 'test',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.errorPrefix}$e')));
      }
    }
  }
}
