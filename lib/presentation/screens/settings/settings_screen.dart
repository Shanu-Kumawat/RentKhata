/// Settings screen.
library;

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/bouncing_scale_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/theme_settings_provider.dart';
import '../../../application/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'edit_profile_screen.dart';
import 'electricity_rates_screen.dart';
import 'message_templates_screen.dart';
import 'billing_cycle_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'biometric_settings_screen.dart';

/// Settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final landlordAsync = ref.watch(landlordProvider);
    final appTheme = ref.watch(themeSettingsProvider);
    final currentLocale = ref.watch(localeNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          // Profile section
          landlordAsync.when(
            data: (landlord) => BouncingScaleWrapper(
              child: _ProfileTile(
                name: landlord?.name ?? l10n.setUpProfile,
                upiId: landlord?.upiId,
                photoPath: landlord?.photoPath,
                tapToAddUpiIdText: l10n.tapToAddUpiId,
                onTap: () => Navigator.push(
                  context,
                  _createRoute(const EditProfileScreen()),
                ),
              ),
            ),
            loading: () => ListTile(
              leading: const CircleAvatar(child: CircularProgressIndicator()),
              title: Text(l10n.loading),
            ),
            error: (e, s) => ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.error,
                child: Icon(Icons.error, color: Colors.white),
              ),
              title: Text(l10n.error(e.toString())),
            ),
          ),
          const Divider(),

          _AnimatedSettingsSection(
            index: 0,
            title: l10n.appearance,
            children: [
              // Unified theme selector
              BouncingScaleWrapper(
                child: ListTile(
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
                  title: Text(l10n.theme),
                  subtitle: Text(appTheme.displayName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeSheet(context, ref, appTheme, l10n),
                ),
              ),
              // Language selector
              BouncingScaleWrapper(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.language,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(l10n.language),
                  subtitle: Text(currentLocale.languageCode == 'hi' ? 'हिंदी (Hindi)' : 'English'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageSheet(context, ref, currentLocale, l10n),
                ),
              ),
            ],
          ),

          _AnimatedSettingsSection(
            index: 1,
            title: l10n.security,
            children: [
              _SettingsTile(
                icon: Icons.fingerprint,
                title: l10n.appLock,
                subtitle: l10n.biometricAuthentication,
                onTap: () => Navigator.push(
                  context,
                  _createRoute(const BiometricSettingsScreen()),
                ),
              ),
            ],
          ),

          _AnimatedSettingsSection(
            index: 2,
            title: l10n.billingAndCycles,
            children: [
              _SettingsTile(
                icon: Icons.calendar_month_outlined,
                title: l10n.anniversaryBilling,
                subtitle: l10n.configureBillingCycles,
                onTap: () => Navigator.push(
                  context,
                  _createRoute(const BillingCycleSettingsScreen()),
                ),
              ),
            ],
          ),

          _AnimatedSettingsSection(
            index: 3,
            title: 'Billing',
            children: [
              _SettingsTile(
                icon: Icons.bolt_outlined,
                title: 'Electricity Rates',
                subtitle: 'View and update electricity rates',
                onTap: () => Navigator.push(
                  context,
                  _createRoute(const ElectricityRatesScreen()),
                ),
              ),
              _SettingsTile(
                icon: Icons.message_outlined,
                title: 'Message Templates',
                subtitle: 'Customize invoice and receipt messages',
                onTap: () => Navigator.push(
                  context,
                  _createRoute(const MessageTemplatesScreen()),
                ),
              ),
            ],
          ),

          _AnimatedSettingsSection(
            index: 4,
            title: 'Notifications',
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Reminder Settings',
                subtitle: 'Due date and overdue reminders',
                onTap: () => Navigator.push(
                  context,
                  _createRoute(const NotificationSettingsScreen()),
                ),
              ),
            ],
          ),

          _AnimatedSettingsSection(
            index: 5,
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
            index: 6,
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

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Shared Axis Z Transition
        // Incoming page: Scale up + Fade in
        final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
        );
        final scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
        );

        // Outgoing page (when pushing new route): Scale down + Fade out
        // We handle this by wrapping the CHILD in a Transition that reacts to secondaryAnimation
        final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.fastOutSlowIn,
          ),
        );
        final scaleOut = Tween<double>(begin: 1.0, end: 0.92).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.fastOutSlowIn,
          ),
        );

        return FadeTransition(
          opacity: fadeIn,
          child: ScaleTransition(
            scale: scaleIn,
            child: FadeTransition(
              opacity: fadeOut,
              child: ScaleTransition(scale: scaleOut, child: child),
            ),
          ),
        );
      },
    );
  }

  void _showThemeSheet(
    BuildContext context,
    WidgetRef ref,
    AppTheme currentTheme,
    AppLocalizations l10n,
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
                l10n.chooseTheme,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...AppTheme.values.map(
              (theme) {
                final isSelected = currentTheme == theme;
                return ListTile(
                  onTap: () {
                    ref.read(themeSettingsProvider.notifier).setTheme(theme);
                    Navigator.pop(context);
                  },
                  title: Text(theme.displayName),
                  subtitle: Text(theme.subtitle),
                  leading: Container(
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
                        ? Icon(Icons.brightness_auto, size: 18,
                            color: Theme.of(context).colorScheme.onSurface)
                        : null,
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary)
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
    AppLocalizations l10n,
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
                l10n.chooseLanguage,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              onTap: () {
                ref.read(localeNotifierProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
              title: const Text('English (English)'),
              leading: const Icon(Icons.language),
              trailing: currentLocale.languageCode == 'en'
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
            ),
            ListTile(
              onTap: () {
                ref.read(localeNotifierProvider.notifier).setLocale(const Locale('hi'));
                Navigator.pop(context);
              },
              title: const Text('हिंदी (Hindi)'),
              leading: const Icon(Icons.language),
              trailing: currentLocale.languageCode == 'hi'
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
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
  final String? tapToAddUpiIdText;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.name,
    this.upiId,
    this.photoPath,
    this.tapToAddUpiIdText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Hero(
        tag: 'landlord_profile_photo',
        child: CircleAvatar(
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
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: upiId != null
          ? Text(upiId!)
          : Text(
              tapToAddUpiIdText ?? 'Tap to add UPI ID',
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
    return BouncingScaleWrapper(
      child: ListTile(
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
      ),
    );
  }
}
