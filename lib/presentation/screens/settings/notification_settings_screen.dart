import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/notification_settings_providers.dart';
import '../../../data/database/tables/notification_setting_table.dart';
import '../../../services/local_notification_service.dart';
import '../../../services/notification_scheduler.dart';
import 'dart:async';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../../../core/utils/app_settings_helper.dart';

enum _SaveStatus { idle, saving, saved, error }

/// Notification settings screen with granular controls
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> with WidgetsBindingObserver {
  // Local state for immediate UI feedback
  late NotificationSettingsState _localState;
  Timer? _debounceTimer;
  bool _initialized = false;
  _SaveStatus _saveStatus = _SaveStatus.idle;
  bool _systemNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize with default/empty state, will be updated from provider
    _localState = const NotificationSettingsState(
      enabledSettings: {},
      daysBeforeSettings: {},
      notificationHour: 9,
    );
    _checkSystemPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSystemPermission();
    }
  }

  Future<void> _checkSystemPermission() async {
    final enabled = await LocalNotificationService().checkPermission();
    if (mounted) {
      setState(() {
        _systemNotificationsEnabled = enabled;
      });
    }
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
      await _checkSystemPermission();
      if (hasPermission) {
        await ref.read(notificationStartupSchedulerProvider.notifier).reschedule();
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
            if (!_systemNotificationsEnabled) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_off_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.systemNotificationsDisabledTitle,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.systemNotificationsDisabledBody,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onErrorContainer.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      onPressed: () async {
                        final service = LocalNotificationService();
                        final granted = await service.requestPermission();
                        if (granted) {
                          await _checkSystemPermission();
                        } else {
                          AppSettingsHelper.openSettings();
                        }
                      },
                      child: Text(l10n.enableBtn),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
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
              title: l10n.smartAlerts,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            _buildToggleWithSlider(
              title: l10n.agreementExpiredAlert,
              subtitle: l10n.agreementExpiredAlertSubtitle(
                _localState.getDaysBefore(NotificationType.agreementExpired).clamp(0, 30),
              ),
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
              title: l10n.billNotGeneratedAlert,
              subtitle: l10n.billNotGeneratedAlertSubtitle(
                _localState.getDaysBefore(NotificationType.billNotGenerated).clamp(0, 14),
              ),
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
              title: l10n.partialPaymentPauseAlert,
              subtitle: l10n.partialPaymentPauseAlertSubtitle,
              value: _localState.isEnabled(
                NotificationType.partialPaymentPause,
              ),
              onChanged: (v) =>
                  _toggleSetting(NotificationType.partialPaymentPause, v),
            ),
            _buildToggleWithSlider(
              title: l10n.depositSettlementAlert,
              subtitle: l10n.depositSettlementAlertSubtitle(
                _localState.getDaysBefore(NotificationType.depositSettlementDue).clamp(1, 30),
              ),
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
              title: l10n.utilityAnomalyAlert,
              subtitle: l10n.utilityAnomalyAlertSubtitle,
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
                onChanged: _systemNotificationsEnabled
                    ? (v) {
                        if (v != null) _updateHour(v);
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Test button (debug only)
            if (kDebugMode) ...[
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
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.developer_board),
                    label: Text(l10n.debugViewScheduledNotifications),
                    onPressed: () => _showScheduledNotifications(),
                  ),
                ),
              ),
            ],
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
      onChanged: _systemNotificationsEnabled ? onChanged : null,
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
          onChanged: _systemNotificationsEnabled ? onChanged : null,
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
              onChanged: _systemNotificationsEnabled ? onSliderChanged : null,
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

  Future<void> _showScheduledNotifications() async {
    final service = LocalNotificationService();
    final pending = await service.getPendingNotifications();
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scheduled Notifications (${pending.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: pending.isEmpty
                      ? Center(child: Text(AppLocalizations.of(context)!.noNotificationsScheduled))
                      : ListView.separated(
                          controller: scrollController,
                          itemCount: pending.length,
                          separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final req = pending[index];
                              
                              String? rawPayload = req.payload;
                              String? debugTimeStr;
                              String? displayPayload = rawPayload;
                              
                              if (rawPayload != null && rawPayload.contains('debug_time:')) {
                                final parts = rawPayload.split('|debug_time:');
                                if (parts.length == 2) {
                                  displayPayload = parts[0].isEmpty ? null : parts[0];
                                  debugTimeStr = parts[1];
                                } else if (rawPayload.startsWith('debug_time:')) {
                                  displayPayload = null;
                                  debugTimeStr = rawPayload.replaceFirst('debug_time:', '');
                                }
                              }
                              
                              String formattedTime = 'Unknown Time';
                              if (debugTimeStr != null) {
                                try {
                                  final dt = DateTime.parse(debugTimeStr);
                                  // Simple manual format to avoid intl dependency issues
                                  formattedTime = '${dt.day}/${dt.month}/${dt.year} at '
                                      '${dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour)}:'
                                      '${dt.minute.toString().padLeft(2, '0')} '
                                      '${dt.hour >= 12 ? 'PM' : 'AM'}';
                                } catch (_) {}
                              }
                              
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  child: Icon(Icons.alarm, color: Theme.of(context).colorScheme.primary, size: 20),
                                ),
                                title: Text(req.title ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(req.body ?? 'No Body'),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withAlpha(26), // 0.1 opacity
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.green.withAlpha(77)), // 0.3 opacity
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.schedule, size: 14, color: Colors.green),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Fires on: $formattedTime',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ID: ${req.id}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                    if (displayPayload != null)
                                      Text(
                                        'Payload: $displayPayload',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Colors.blueGrey,
                                            ),
                                      ),
                                  ],
                                ),
                                isThreeLine: true,
                              );
                            },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
