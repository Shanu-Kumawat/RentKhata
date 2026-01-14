/// Settings screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../core/theme/app_colors.dart';
import 'edit_profile_screen.dart';
import 'electricity_rates_screen.dart';

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
                icon: Icons.schedule_outlined,
                title: 'Auto-Billing',
                subtitle: 'Configure automatic bill generation',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const _AutoBillingSettingsSheet(),
                  );
                },
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

/// Auto-billing settings sheet
class _AutoBillingSettingsSheet extends StatefulWidget {
  const _AutoBillingSettingsSheet();

  @override
  State<_AutoBillingSettingsSheet> createState() =>
      _AutoBillingSettingsSheetState();
}

class _AutoBillingSettingsSheetState extends State<_AutoBillingSettingsSheet> {
  bool _enabled = false;
  int _generationDay = 1;
  int _dueDayOffset = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Auto-Billing Settings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Enable Auto-Billing'),
            subtitle: const Text('Generate bills automatically each month'),
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Generation Day'),
            subtitle: Text('Day $_generationDay of each month'),
            trailing: DropdownButton<int>(
              value: _generationDay,
              items: List.generate(
                28,
                (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
              ),
              onChanged: _enabled
                  ? (v) => setState(() => _generationDay = v!)
                  : null,
            ),
          ),
          ListTile(
            title: const Text('Due Date Offset'),
            subtitle: Text('$_dueDayOffset days after generation'),
            trailing: DropdownButton<int>(
              value: _dueDayOffset,
              items: [5, 7, 10, 15]
                  .map(
                    (d) => DropdownMenuItem(value: d, child: Text('$d days')),
                  )
                  .toList(),
              onChanged: _enabled
                  ? (v) => setState(() => _dueDayOffset = v!)
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Auto-billing settings saved!')),
                );
              },
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Notification settings sheet
class _NotificationSettingsSheet extends StatefulWidget {
  const _NotificationSettingsSheet();

  @override
  State<_NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends State<_NotificationSettingsSheet> {
  bool _dueSoon = true;
  bool _overdue = true;
  int _daysBefore = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings saved!')),
                );
              },
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
