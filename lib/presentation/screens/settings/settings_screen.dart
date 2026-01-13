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
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Profile section
          landlordAsync.when(
            data: (landlord) =>             _ProfileTile(
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
                  MaterialPageRoute(builder: (_) => const ElectricityRatesScreen()),
                ),
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

  const _ProfileTile({
    required this.name,
    this.upiId,
    required this.onTap,
  });

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
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
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

  const _SettingsSection({
    required this.title,
    required this.children,
  });

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
      trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
