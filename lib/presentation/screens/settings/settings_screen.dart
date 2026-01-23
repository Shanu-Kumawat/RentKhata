/// Settings screen.
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/theme_settings_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'edit_profile_screen.dart';
import 'electricity_rates_screen.dart';
import 'message_templates_screen.dart';
import 'billing_cycle_settings_screen.dart';
import 'notification_settings_screen.dart';

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
              photoPath: landlord?.photoPath,
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

          // Use animate container for stagger effect if needed, but here we can just do simple delayed animations
          // or just wrap things in build.
          // Since I can't add packages, I will implement a wrapper that animates on mount?
          // But stateless widgets don't mount in the same way.
          // Simpler: Just render the list. The user asked for animations.
          // I will use `TweenAnimationBuilder` or similar if I want simple ones.
          // But `ListView` items don't stagger automatically.
          _AnimatedSettingsSection(
            index: 0,
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

          _AnimatedSettingsSection(
            index: 1,
            title: 'Billing & Cycles',
            children: [
              _SettingsTile(
                icon: Icons.calendar_month_outlined,
                title: 'Anniversary Billing',
                subtitle: 'Configure billing cycles and due dates',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BillingCycleSettingsScreen(),
                  ),
                ),
              ),
            ],
          ),

          _AnimatedSettingsSection(
            index: 2,
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

          _AnimatedSettingsSection(
            index: 3,
            title: 'Notifications',
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Reminder Settings',
                subtitle: 'Due date and overdue reminders',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationSettingsScreen(),
                  ),
                ),
              ),
            ],
          ),

          _AnimatedSettingsSection(
            index: 4,
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

          _AnimatedSettingsSection(
            index: 5,
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

          const SizedBox(height: 32),
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
  final String? photoPath;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.name,
    this.upiId,
    this.photoPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.1),
        backgroundImage: photoPath != null && File(photoPath!).existsSync()
            ? FileImage(File(photoPath!))
            : null,
        child: photoPath == null || !File(photoPath!).existsSync()
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : null,
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

class _AnimatedSettingsSection extends StatefulWidget {
  final int index;
  final String title;
  final List<Widget> children;

  const _AnimatedSettingsSection({
    required this.index,
    required this.title,
    required this.children,
  });

  @override
  State<_AnimatedSettingsSection> createState() =>
      _AnimatedSettingsSectionState();
}

class _AnimatedSettingsSectionState extends State<_AnimatedSettingsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Stagger based on index
    final delay = Duration(milliseconds: widget.index * 100);
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(_animation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...widget.children,
          ],
        ),
      ),
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
