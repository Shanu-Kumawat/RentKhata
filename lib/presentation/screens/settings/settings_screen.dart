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
import '../../../data/database/app_database.dart';
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
                        color: AppColors.primary,
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
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: upiId != null
          ? Text(upiId!)
          : const Text(
              'Tap to add UPI ID',
              style: TextStyle(color: AppColors.onSurfaceVariant),
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
              color: AppColors.primary,
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
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.onSurface),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

/// Notification settings sheet
class _NotificationSettingsSheet extends ConsumerStatefulWidget {
  const _NotificationSettingsSheet();

  @override
  ConsumerState<_NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends ConsumerState<_NotificationSettingsSheet> {
  bool _dueSoon = true;
  bool _overdue = true;
  int _daysBefore = 3;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Settings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Due Soon Reminders'),
            subtitle: Text('Notify $_daysBefore days before due date'),
            value: _dueSoon,
            onChanged: (v) => setState(() => _dueSoon = v),
          ),
          if (_dueSoon)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Slider(
                value: _daysBefore.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: '$_daysBefore days',
                onChanged: (v) => setState(() => _daysBefore = v.round()),
              ),
            ),
          SwitchListTile(
            title: const Text('Overdue Reminders'),
            subtitle: const Text('Notify when bills are past due'),
            value: _overdue,
            onChanged: (v) => setState(() => _overdue = v),
          ),
          const SizedBox(height: 24),
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
                  : const Text('Save & Schedule Reminders'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndSchedule() async {
    setState(() => _isLoading = true);

    try {
      // Import notification service
      final notificationService = LocalNotificationService();

      // Request permission first
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

      // Cancel all existing notifications first
      await notificationService.cancelAll();

      // Get all unpaid bills
      final bills = await ref.read(unpaidBillsProvider.future);
      int scheduledCount = 0;

      for (final bill in bills) {
        // Schedule due soon reminder
        if (_dueSoon && bill.dueDate != null) {
          await notificationService.scheduleDueBillReminder(
            bill: bill,
            daysBefore: _daysBefore,
          );
          scheduledCount++;
        }

        // Schedule overdue reminder
        if (_overdue && bill.dueDate != null) {
          await notificationService.scheduleOverdueReminder(bill: bill);
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              scheduledCount > 0
                  ? 'Scheduled reminders for $scheduledCount bill(s)!'
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

      // Request permission first
      final granted = await notificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Notification permission denied. Please enable in Settings.',
              ),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Show immediate test notification
      await notificationService.showNotification(
        id: 12345,
        title: '🔔 Test Notification',
        body: 'Notifications are working! You will receive bill reminders.',
        payload: 'test',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Test notification sent! Check your notification tray.',
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

    return settingsAsync.when(
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
                color: AppColors.onSurfaceVariant,
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
                color: AppColors.onSurfaceVariant,
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
                  color: AppColors.primary,
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
                color: AppColors.onSurfaceVariant,
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
                  color: AppColors.warning,
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
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),

            _buildBillTypeToggle(
              label: 'Rent',
              subtitle: 'Monthly rent bills',
              value: settings.rentUsesAnniversary,
              onChanged: (v) => _updateSetting(rentUsesAnniversary: v),
              icon: Icons.home_outlined,
              color: AppColors.primary,
            ),
            _buildBillTypeToggle(
              label: 'Electricity',
              subtitle: 'Electricity meter bills',
              value: settings.electricityUsesAnniversary,
              onChanged: (v) => _updateSetting(electricityUsesAnniversary: v),
              icon: Icons.bolt_outlined,
              color: AppColors.warning,
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
