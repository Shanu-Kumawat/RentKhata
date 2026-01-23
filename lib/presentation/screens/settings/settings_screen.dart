/// Settings screen.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/notification_settings_providers.dart';
import '../../../application/providers/theme_settings_provider.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/tables/notification_setting_table.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/local_notification_service.dart';
import 'edit_profile_screen.dart';
import 'electricity_rates_screen.dart';
import 'message_templates_screen.dart';

/// Settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final landlordAsync = ref.watch(landlordProvider);
    final appTheme = ref.watch(themeSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Profile section
          landlordAsync.when(
            data: (landlord) => _ProfileTile(
              name: landlord?.name ?? 'Set up profile',
              upiId: landlord?.upiId,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),
            loading: () => const ListTile(
              leading: CircleAvatar(child: CircularProgressIndicator()),
              title: Text('Loading...'),
            ),
            error: (e, s) => ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.error,
                child: Icon(Icons.error, color: Colors.white),
              ),
              title: Text('Error: $e'),
            ),
          ),
          const Divider(),

          // Appearance section
          _SettingsSection(
            title: 'Appearance',
            children: [
              // Unified theme selector
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    appTheme.icon,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                title: const Text('Theme'),
                subtitle: Text(appTheme.displayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeSheet(context, ref, appTheme),
              ),
            ],
          ),

          // Settings sections
          _SettingsSection(
            title: 'Billing & Cycles',
            children: [
              _SettingsTile(
                icon: Icons.calendar_month_outlined,
                title: 'Anniversary Billing',
                subtitle: 'Configure billing cycles and due dates',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const _BillingCycleSettingsSheet(),
                  );
                },
              ),
            ],
          ),

          _SettingsSection(
            title: 'Billing',
            children: [
              _SettingsTile(
                icon: Icons.bolt_outlined,
                title: 'Electricity Rates',
                subtitle: 'View and update electricity rates',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ElectricityRatesScreen(),
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.message_outlined,
                title: 'Message Templates',
                subtitle: 'Customize invoice and receipt messages',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MessageTemplatesScreen(),
                  ),
                ),
              ),
            ],
          ),

          _SettingsSection(
            title: 'Notifications',
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Reminder Settings',
                subtitle: 'Due date and overdue reminders',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const _NotificationSettingsSheet(),
                  );
                },
              ),
            ],
          ),

          _SettingsSection(
            title: 'Data',
            children: [
              _SettingsTile(
                icon: Icons.backup_outlined,
                title: 'Backup & Restore',
                subtitle: 'Save or restore your data',
                onTap: () => context.push('/settings/backup'),
              ),
            ],
          ),

          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About RentKhata',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'RentKhata',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.home_work_rounded,
                        color: Colors.white,
                      ),
                    ),
                    children: [
                      const Text(
                        'Offline-first rental management app for Indian landlords.',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showThemeSheet(
    BuildContext context,
    WidgetRef ref,
    AppTheme currentTheme,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Choose Theme',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...AppTheme.values.map(
              (theme) => RadioListTile<AppTheme>(
                value: theme,
                groupValue: currentTheme,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeSettingsProvider.notifier).setTheme(value);
                    Navigator.pop(context);
                  }
                },
                title: Text(theme.displayName),
                subtitle: Text(theme.subtitle),
                secondary: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.previewColor,
                    borderRadius: BorderRadius.circular(8),
                    border: theme == AppTheme.system
                        ? Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          )
                        : null,
                  ),
                  child: theme == AppTheme.system
                      ? Icon(
                          Icons.brightness_auto,
                          size: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String name;
  final String? upiId;
  final VoidCallback onTap;

  const _ProfileTile({required this.name, this.upiId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.1),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: upiId != null
          ? Text(upiId!)
          : Text(
              'Tap to add UPI ID',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

/// Notification settings sheet with granular controls
class _NotificationSettingsSheet extends ConsumerStatefulWidget {
  const _NotificationSettingsSheet();

  @override
  ConsumerState<_NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends ConsumerState<_NotificationSettingsSheet> {
  // Billing reminders
  bool _cycleEndingSoon = true;
  bool _billDueSoon = true;
  bool _monthlySummary = true;
  int _cycleReminderDays = 3;
  int _dueSoonDays = 3;

  // Payment notifications
  bool _paymentReceived = true;
  bool _billFullyPaid = true;

  // Overdue escalation
  bool _overdue1Day = true;
  bool _overdue3Days = true;
  bool _overdue7Days = true;
  bool _overdue14Days = true;

  // General settings
  int _notificationHour = 9;
  bool _quietHoursEnabled = false;
  int _quietStart = 22;
  int _quietEnd = 7;

  bool _isLoading = false;
  bool _hasLoadedFromDb = false;

  @override
  void initState() {
    super.initState();
    _loadFromProvider();
  }

  void _loadFromProvider() {
    final settings = ref.read(notificationSettingsNotifierProvider);
    if (!settings.isLoading && settings.enabledSettings.isNotEmpty) {
      _applySettings(settings);
    }
  }

  void _applySettings(NotificationSettingsState settings) {
    if (_hasLoadedFromDb) return;
    _hasLoadedFromDb = true;
    setState(() {
      _cycleEndingSoon = settings.isEnabled(NotificationType.cycleEndingSoon);
      _billDueSoon = settings.isEnabled(NotificationType.billDueSoon);
      _monthlySummary = settings.isEnabled(NotificationType.monthlySummary);
      _cycleReminderDays = settings.getDaysBefore(
        NotificationType.cycleEndingSoon,
      );
      _dueSoonDays = settings.getDaysBefore(NotificationType.billDueSoon);
      _paymentReceived = settings.isEnabled(NotificationType.paymentReceived);
      _billFullyPaid = settings.isEnabled(NotificationType.billFullyPaid);
      _overdue1Day = settings.isEnabled(NotificationType.overdue1Day);
      _overdue3Days = settings.isEnabled(NotificationType.overdue3Days);
      _overdue7Days = settings.isEnabled(NotificationType.overdue7Days);
      _overdue14Days = settings.isEnabled(NotificationType.overdue14Days);
      _notificationHour = settings.notificationHour;
      _quietHoursEnabled = settings.quietHoursStart != null;
      _quietStart = settings.quietHoursStart ?? 22;
      _quietEnd = settings.quietHoursEnd ?? 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes from database loading
    ref.listen<NotificationSettingsState>(
      notificationSettingsNotifierProvider,
      (previous, next) {
        if (!next.isLoading && previous?.isLoading == true) {
          _applySettings(next);
        }
      },
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notification Settings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Billing Reminders Section
            _buildSectionHeader(
              icon: Icons.calendar_today_outlined,
              title: 'Billing Reminders',
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildToggleWithSlider(
              title: 'Billing cycle ending',
              subtitle: 'Remind $_cycleReminderDays days before cycle ends',
              value: _cycleEndingSoon,
              onChanged: (v) => setState(() => _cycleEndingSoon = v),
              sliderValue: _cycleReminderDays.toDouble(),
              sliderMin: 1,
              sliderMax: 7,
              onSliderChanged: (v) =>
                  setState(() => _cycleReminderDays = v.round()),
            ),
            _buildToggleWithSlider(
              title: 'Bill due soon',
              subtitle: 'Remind $_dueSoonDays days before due date',
              value: _billDueSoon,
              onChanged: (v) => setState(() => _billDueSoon = v),
              sliderValue: _dueSoonDays.toDouble(),
              sliderMin: 1,
              sliderMax: 7,
              onSliderChanged: (v) => setState(() => _dueSoonDays = v.round()),
            ),
            _buildSimpleToggle(
              title: 'Monthly summary',
              subtitle: 'Collection status on 1st of each month',
              value: _monthlySummary,
              onChanged: (v) => setState(() => _monthlySummary = v),
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
              value: _paymentReceived,
              onChanged: (v) => setState(() => _paymentReceived = v),
            ),
            _buildSimpleToggle(
              title: 'Bill fully paid',
              subtitle: 'Celebrate when bill is fully paid',
              value: _billFullyPaid,
              onChanged: (v) => setState(() => _billFullyPaid = v),
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
              value: _overdue1Day,
              onChanged: (v) => setState(() => _overdue1Day = v),
            ),
            _buildSimpleToggle(
              title: '3 days overdue',
              subtitle: 'Second reminder',
              value: _overdue3Days,
              onChanged: (v) => setState(() => _overdue3Days = v),
            ),
            _buildSimpleToggle(
              title: '1 week overdue',
              subtitle: 'Weekly reminder',
              value: _overdue7Days,
              onChanged: (v) => setState(() => _overdue7Days = v),
            ),
            _buildSimpleToggle(
              title: '2 weeks overdue',
              subtitle: 'Critical - urgent attention needed',
              value: _overdue14Days,
              onChanged: (v) => setState(() => _overdue14Days = v),
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
              subtitle: Text(_formatHour(_notificationHour)),
              trailing: DropdownButton<int>(
                value: _notificationHour,
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
                  if (v != null) setState(() => _notificationHour = v);
                },
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Quiet hours'),
              subtitle: _quietHoursEnabled
                  ? Text(
                      '${_formatHour(_quietStart)} - ${_formatHour(_quietEnd)}',
                    )
                  : const Text('Not enabled'),
              value: _quietHoursEnabled,
              onChanged: (v) => setState(() => _quietHoursEnabled = v),
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
                    onPressed: _isLoading ? null : _sendTestNotification,
                  ),
                ),
              ),

            // Scheduled test button (debug only) - for reboot testing
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: const Text('Schedule Test (15 min)'),
                    onPressed: _isLoading ? null : _scheduleTestNotification,
                  ),
                ),
              ),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _saveAndSchedule,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Settings'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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

  Future<void> _saveAndSchedule() async {
    setState(() => _isLoading = true);

    try {
      final notificationService = LocalNotificationService();
      final granted = await notificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification permission denied')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Save settings to database
      final enabledSettings = <NotificationType, bool>{
        NotificationType.cycleEndingSoon: _cycleEndingSoon,
        NotificationType.billDueSoon: _billDueSoon,
        NotificationType.monthlySummary: _monthlySummary,
        NotificationType.paymentReceived: _paymentReceived,
        NotificationType.billFullyPaid: _billFullyPaid,
        NotificationType.overdue1Day: _overdue1Day,
        NotificationType.overdue3Days: _overdue3Days,
        NotificationType.overdue7Days: _overdue7Days,
        NotificationType.overdue14Days: _overdue14Days,
      };

      final daysBeforeSettings = <NotificationType, int>{
        NotificationType.cycleEndingSoon: _cycleReminderDays,
        NotificationType.billDueSoon: _dueSoonDays,
      };

      await ref
          .read(notificationSettingsNotifierProvider.notifier)
          .saveAllSettings(
            enabledSettings: enabledSettings,
            daysBeforeSettings: daysBeforeSettings,
            notificationHour: _notificationHour,
            quietHoursStart: _quietHoursEnabled ? _quietStart : null,
            quietHoursEnd: _quietHoursEnabled ? _quietEnd : null,
          );

      // Cancel all existing notifications first
      await notificationService.cancelAll();

      // Get all unpaid bills and schedule based on settings
      final bills = await ref.read(unpaidBillsProvider.future);
      int scheduledCount = 0;

      for (final bill in bills) {
        if (bill.dueDate == null) continue;

        // Schedule due soon reminder
        if (_billDueSoon) {
          await notificationService.scheduleDueBillReminder(
            bill: bill,
            daysBefore: _dueSoonDays,
          );
          scheduledCount++;
        }

        // Schedule overdue escalation
        if (_overdue1Day || _overdue3Days || _overdue7Days || _overdue14Days) {
          await notificationService.scheduleOverdueEscalation(bill: bill);
        }
      }

      // Schedule cycle ending reminders if enabled
      if (_cycleEndingSoon) {
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

        await notificationService.scheduleAllCycleReminders(
          occupancies: cycleData,
          daysBefore: _cycleReminderDays,
        );
        scheduledCount += cycleData.length;
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              scheduledCount > 0
                  ? 'Settings saved! Reminders scheduled for $scheduledCount bill(s)'
                  : 'Settings saved. No pending bills to schedule.',
            ),
          ),
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

  Future<void> _sendTestNotification() async {
    setState(() => _isLoading = true);

    try {
      final notificationService = LocalNotificationService();
      await notificationService.initialize();

      final granted = await notificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Notification permission denied. Enable in Settings.',
              ),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      await notificationService.showNotification(
        id: 12345,
        title: '🔔 Test Notification',
        body: 'Notifications are working! You will receive bill reminders.',
        payload: 'test',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test notification sent!')),
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

  Future<void> _scheduleTestNotification() async {
    setState(() => _isLoading = true);

    try {
      final notificationService = LocalNotificationService();
      await notificationService.initialize();

      final granted = await notificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Notification permission denied. Enable in Settings.',
              ),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Schedule for 15 minutes from now
      final scheduledTime = DateTime.now().add(const Duration(minutes: 15));

      await notificationService.scheduleNotification(
        id: 99999,
        title: '⏰ Scheduled Test Notification',
        body:
            'This was scheduled 15 minutes ago! Notifications work even after reboot.',
        scheduledTime: scheduledTime,
        payload: 'scheduled_test',
      );

      if (mounted) {
        final timeStr =
            '${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notification scheduled for $timeStr. You can close the app or reboot now!',
            ),
            duration: const Duration(seconds: 5),
          ),
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
}

/// Billing cycle settings sheet for configuring anniversary billing
/// Auto-saves changes immediately without a save button
class _BillingCycleSettingsSheet extends ConsumerStatefulWidget {
  const _BillingCycleSettingsSheet();

  @override
  ConsumerState<_BillingCycleSettingsSheet> createState() =>
      _BillingCycleSettingsSheetState();
}

class _BillingCycleSettingsSheetState
    extends ConsumerState<_BillingCycleSettingsSheet> {
  /// Save settings to database and refresh providers
  Future<void> _updateSetting({
    int? dueDateOffsetDays,
    int? dueSoonThresholdDays,
    bool? rentUsesAnniversary,
    bool? electricityUsesAnniversary,
    bool? waterUsesAnniversary,
    bool? maintenanceUsesAnniversary,
    bool? otherUsesAnniversary,
  }) async {
    try {
      final db = ref.read(appDatabaseProvider);

      // Build companion with only changed values
      final companion = BillSettingsCompanion(
        dueDateOffsetDays: dueDateOffsetDays != null
            ? Value(dueDateOffsetDays)
            : const Value.absent(),
        dueSoonThresholdDays: dueSoonThresholdDays != null
            ? Value(dueSoonThresholdDays)
            : const Value.absent(),
        rentUsesAnniversary: rentUsesAnniversary != null
            ? Value(rentUsesAnniversary)
            : const Value.absent(),
        electricityUsesAnniversary: electricityUsesAnniversary != null
            ? Value(electricityUsesAnniversary)
            : const Value.absent(),
        waterUsesAnniversary: waterUsesAnniversary != null
            ? Value(waterUsesAnniversary)
            : const Value.absent(),
        maintenanceUsesAnniversary: maintenanceUsesAnniversary != null
            ? Value(maintenanceUsesAnniversary)
            : const Value.absent(),
        otherUsesAnniversary: otherUsesAnniversary != null
            ? Value(otherUsesAnniversary)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );

      await (db.update(
        db.billSettings,
      )..where((t) => t.id.equals(1))).write(companion);

      // Invalidate providers to refresh all dependent widgets
      ref.invalidate(billSettingsProvider);
      ref.invalidate(billingAttentionConfigProvider);
      ref.invalidate(billingAttentionListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(billSettingsProvider);

    // Use skipLoadingOnRefresh to prevent flicker when updating settings
    return settingsAsync.when(
      skipLoadingOnRefresh: true,
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (settings) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Billing Cycle Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Changes are saved automatically.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Due Date Offset
            Text(
              'Due Date',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Days after billing cycle ends before bill is due.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Slider(
              value: settings.dueDateOffsetDays.toDouble(),
              min: 1,
              max: 15,
              divisions: 14,
              label: '${settings.dueDateOffsetDays} days',
              onChangeEnd: (v) => _updateSetting(dueDateOffsetDays: v.round()),
              onChanged: (v) {}, // Required for slider to work
            ),
            Center(
              child: Text(
                'Due: ${settings.dueDateOffsetDays} days after cycle ends',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Due Soon Threshold
            Text(
              'Due Soon Alert',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Show "due soon" in Attention when cycle ends within this many days.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Slider(
              value: settings.dueSoonThresholdDays.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '${settings.dueSoonThresholdDays} days',
              onChangeEnd: (v) =>
                  _updateSetting(dueSoonThresholdDays: v.round()),
              onChanged: (v) {},
            ),
            Center(
              child: Text(
                'Alert: ${settings.dueSoonThresholdDays} days before cycle ends',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Anniversary Billing Toggles
            Text(
              'Anniversary Billing by Bill Type',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Enable to track billing cycles based on tenant move-in date.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),

            _buildBillTypeToggle(
              label: 'Rent',
              subtitle: 'Monthly rent bills',
              value: settings.rentUsesAnniversary,
              onChanged: (v) => _updateSetting(rentUsesAnniversary: v),
              icon: Icons.home_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildBillTypeToggle(
              label: 'Electricity',
              subtitle: 'Electricity meter bills',
              value: settings.electricityUsesAnniversary,
              onChanged: (v) => _updateSetting(electricityUsesAnniversary: v),
              icon: Icons.bolt_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            _buildBillTypeToggle(
              label: 'Water',
              subtitle: 'Water bills',
              value: settings.waterUsesAnniversary,
              onChanged: (v) => _updateSetting(waterUsesAnniversary: v),
              icon: Icons.water_drop_outlined,
              color: Colors.blue,
            ),
            _buildBillTypeToggle(
              label: 'Maintenance',
              subtitle: 'Maintenance charges',
              value: settings.maintenanceUsesAnniversary,
              onChanged: (v) => _updateSetting(maintenanceUsesAnniversary: v),
              icon: Icons.build_outlined,
              color: Colors.green,
            ),
            _buildBillTypeToggle(
              label: 'Other',
              subtitle: 'Other charges',
              value: settings.otherUsesAnniversary,
              onChanged: (v) => _updateSetting(otherUsesAnniversary: v),
              icon: Icons.receipt_outlined,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBillTypeToggle({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return SwitchListTile(
      title: Text(label),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
