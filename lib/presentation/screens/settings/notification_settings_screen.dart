import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/notification_settings_providers.dart';
import '../../../data/database/tables/notification_setting_table.dart';
import '../../../services/local_notification_service.dart';
import 'dart:async';

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
      quietHoursStart: null,
      quietHoursEnd: null,
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
            quietHoursStart: _localState.quietHoursStart,
            quietHoursEnd: _localState.quietHoursEnd,
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving settings: $e')));
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

    bool overdue1Day = _localState.isEnabled(NotificationType.overdue1Day);
    bool overdue3Days = _localState.isEnabled(NotificationType.overdue3Days);
    bool overdue7Days = _localState.isEnabled(NotificationType.overdue7Days);
    bool overdue14Days = _localState.isEnabled(NotificationType.overdue14Days);

    for (final bill in bills) {
      if (bill.dueDate == null) continue;

      // Schedule due soon reminder
      if (billDueSoon) {
        await service.scheduleDueBillReminder(
          bill: bill,
          daysBefore: dueSoonDays,
        );
      }

      // Schedule overdue escalation
      if (overdue1Day || overdue3Days || overdue7Days || overdue14Days) {
        await service.scheduleOverdueEscalation(bill: bill);
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
      );
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

  // Helper to update quiet hours
  void _updateQuietHours(bool enabled) {
    HapticFeedback.lightImpact();
    if (enabled) {
      _updateLocalState(
        _localState.copyWith(quietHoursStart: 22, quietHoursEnd: 7),
      );
    } else {
      _updateLocalState(
        _localState.copyWithSimple(quietHoursStart: null, quietHoursEnd: null),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(notificationSettingsNotifierProvider);

    // Sync local state with provider state only once when loaded
    if (!_initialized && !providerState.isLoading) {
      _localState = providerState;
      _initialized = true;
    }

    // If completely loading for first time
    if (providerState.isLoading && !_initialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notification Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [_buildAppBarStatus(), const SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Changes are saved automatically.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Billing Reminders Section
            _buildSectionHeader(
              icon: Icons.calendar_today_outlined,
              title: 'Billing Reminders',
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildToggleWithSlider(
              title: 'Billing cycle ending',
              subtitle:
                  'Remind ${_localState.getDaysBefore(NotificationType.cycleEndingSoon)} days before cycle ends',
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
              title: 'Bill due soon',
              subtitle:
                  'Remind ${_localState.getDaysBefore(NotificationType.billDueSoon)} days before due date',
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
            _buildSimpleToggle(
              title: 'Monthly summary',
              subtitle: 'Collection status on 1st of each month',
              value: _localState.isEnabled(NotificationType.monthlySummary),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.monthlySummary, v),
            ),
            const Divider(height: 32),

            // Payment Notifications Section
            _buildSectionHeader(
              icon: Icons.payment_outlined,
              title: 'Payment Notifications',
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildSimpleToggle(
              title: 'Payment received',
              subtitle: 'Confirm when payment is recorded',
              value: _localState.isEnabled(NotificationType.paymentReceived),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.paymentReceived, v),
            ),
            _buildSimpleToggle(
              title: 'Bill fully paid',
              subtitle: 'Celebrate when bill is fully paid',
              value: _localState.isEnabled(NotificationType.billFullyPaid),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.billFullyPaid, v),
            ),
            const Divider(height: 32),

            // Overdue Escalation Section
            _buildSectionHeader(
              icon: Icons.warning_amber_outlined,
              title: 'Overdue Follow-ups',
              color: Theme.of(context).colorScheme.error,
            ),
            _buildSimpleToggle(
              title: '1 day overdue',
              subtitle: 'First reminder after due date',
              value: _localState.isEnabled(NotificationType.overdue1Day),
              onChanged: (v) => _toggleSetting(NotificationType.overdue1Day, v),
            ),
            _buildSimpleToggle(
              title: '3 days overdue',
              subtitle: 'Second reminder',
              value: _localState.isEnabled(NotificationType.overdue3Days),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.overdue3Days, v),
            ),
            _buildSimpleToggle(
              title: '1 week overdue',
              subtitle: 'Weekly reminder',
              value: _localState.isEnabled(NotificationType.overdue7Days),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.overdue7Days, v),
            ),
            _buildSimpleToggle(
              title: '2 weeks overdue',
              subtitle: 'Critical - urgent attention needed',
              value: _localState.isEnabled(NotificationType.overdue14Days),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.overdue14Days, v),
            ),
            const Divider(height: 32),

            // General Settings Section
            _buildSectionHeader(
              icon: Icons.settings_outlined,
              title: 'General',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notification time'),
              subtitle: Text(_formatHour(_localState.notificationHour)),
              trailing: DropdownButton<int>(
                value: _localState.notificationHour,
                underline: const SizedBox(),
                items: [7, 8, 9, 10, 11, 12]
                    .map(
                      (h) => DropdownMenuItem(
                        value: h,
                        child: Text(_formatHour(h)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) _updateHour(v);
                },
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Quiet hours'),
              subtitle: _localState.quietHoursStart != null
                  ? Text(
                      '${_formatHour(_localState.quietHoursStart!)} - ${_formatHour(_localState.quietHoursEnd!)}',
                    )
                  : const Text('Not enabled'),
              value: _localState.quietHoursStart != null,
              onChanged: _updateQuietHours,
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
                    label: const Text('Send Test Notification'),
                    onPressed: _sendTestNotification,
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
              value: sliderValue,
              min: sliderMin,
              max: sliderMax,
              divisions: (sliderMax - sliderMin).round(),
              label: '${sliderValue.round()} days',
              onChanged: onSliderChanged,
            ),
          ),
      ],
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  Future<void> _sendTestNotification() async {
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
          ).showSnackBar(const SnackBar(content: Text('Permission denied')));
        }
        return;
      }
      await notificationService.showNotification(
        id: 12345,
        title: '🔔 Test Notification',
        body: 'Notifications are working!',
        payload: 'test',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

// Extension to help with simple copyWith since State might not have it if it's not freezed
extension on NotificationSettingsState {
  NotificationSettingsState copyWithSimple({
    Map<NotificationType, bool>? enabledSettings,
    Map<NotificationType, int>? daysBeforeSettings,
    int? notificationHour,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) {
    // Use the existing copyWith but handle nulls manually if needed
    return copyWith(
      enabledSettings: enabledSettings ?? this.enabledSettings,
      daysBeforeSettings: daysBeforeSettings ?? this.daysBeforeSettings,
      notificationHour: notificationHour ?? this.notificationHour,
      quietHoursStart:
          quietHoursStart, // Directly pass since we might want to set it to null
      quietHoursEnd: quietHoursEnd,
    );
  }
}
