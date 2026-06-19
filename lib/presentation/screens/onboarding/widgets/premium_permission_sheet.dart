import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

import '../../../../application/providers/biometric_providers.dart';
import '../../../../application/providers/notification_settings_providers.dart';
import '../../../../data/database/tables/notification_setting_table.dart';
import '../../../../services/local_notification_service.dart';
import '../../../../services/biometric_service.dart';
import '../../../../services/notification_scheduler.dart';
import '../../../router/app_router.dart';

enum PermissionVariant { biometrics, notifications }

class PremiumPermissionSheet extends ConsumerWidget {
  final PermissionVariant variant;

  const PremiumPermissionSheet({super.key, required this.variant});

  /// Check and show biometrics prompt bottom sheet if never shown before.
  static Future<void> showBiometrics(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();

    final hasRequested = prefs.getBool('has_seen_biometrics_prompt') ?? false;
    if (hasRequested) return;

    // Check if biometric/lock screen is supported on the device
    BiometricSupport support;
    try {
      support = await ref.read(biometricSupportProvider.future);
    } catch (e) {
      return;
    }

    final isSupported = support == BiometricSupport.available ||
        support == BiometricSupport.notEnrolled;

    if (!isSupported) {
      return;
    }

    await prefs.setBool('has_seen_biometrics_prompt', true);

    // Small delay to ensure the previous bottom sheet (MoveInSheet) has completely closed
    // and its animation has finished, preventing Navigator conflicts.
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Use the root navigator context to ensure it shows even if the original screen unmounted
    final safeContext = rootNavigatorKey.currentContext;
    if (safeContext == null) return;
    if (!safeContext.mounted) return;

    await showModalBottomSheet(
      context: safeContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isDismissible: false,
      enableDrag: false,
      builder: (context) => const PremiumPermissionSheet(
        variant: PermissionVariant.biometrics,
      ),
    );
    debugPrint('🔐 [showBiometrics] bottom sheet closed');
  }

  /// Check and show notifications bottom sheet if never shown before.
  static Future<void> showNotifications(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    final hasRequested = prefs.getBool('has_seen_notification_prompt') ?? false;

    if (!hasRequested) {
      await prefs.setBool('has_seen_notification_prompt', true);
      if (!context.mounted) return;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const PremiumPermissionSheet(
          variant: PermissionVariant.notifications,
        ),
      );
    }
  }

  Future<void> _handleAccept(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (variant == PermissionVariant.notifications) {
      final notifService = LocalNotificationService();
      final granted = await notifService.requestExactPermissions();
      
      if (context.mounted) {
        if (granted) {
          // Enable all notification settings in the database
          final notifier = ref.read(notificationSettingsNotifierProvider.notifier);
          for (final type in NotificationType.values) {
            await notifier.setEnabled(type, true);
          }
          await ref.read(notificationStartupSchedulerProvider.notifier).reschedule();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.notificationsEnabledSuccess),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // System permission was denied
          final notifier = ref.read(notificationSettingsNotifierProvider.notifier);
          for (final type in NotificationType.values) {
            await notifier.setEnabled(type, false);
          }
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.notificationsDeniedError),
              behavior: SnackBarBehavior.floating,
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      }
    } else if (variant == PermissionVariant.biometrics) {
      final biometricService = ref.read(biometricServiceProvider);
      final result = await biometricService.authenticate(
        reason: l10n.biometricPermissionBody,
      );

      if (context.mounted) {
        if (result == BiometricResult.success) {
          // Save in the biometric settings table
          await ref.read(biometricSettingsNotifierProvider.notifier).setEnabled(true);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.appLockEnabledSuccess),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // Failed or cancelled
          await ref.read(biometricSettingsNotifierProvider.notifier).setEnabled(false);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.appLockNotConfiguredError),
              behavior: SnackBarBehavior.floating,
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleDecline(BuildContext context, WidgetRef ref) async {
    if (variant == PermissionVariant.notifications) {
      // Disable all notification settings
      final notifier = ref.read(notificationSettingsNotifierProvider.notifier);
      for (final type in NotificationType.values) {
        await notifier.setEnabled(type, false);
      }
    } else if (variant == PermissionVariant.biometrics) {
      // Disable biometric settings
      await ref.read(biometricSettingsNotifierProvider.notifier).setEnabled(false);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;

    final isBio = variant == PermissionVariant.biometrics;

    final titleText = isBio ? l10n.biometricPermissionTitle : l10n.notificationPermissionTitle;
    final bodyText = isBio ? l10n.biometricPermissionBody : l10n.notificationPermissionBody;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomInset + 32),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Icon - Styled exactly like ContextualProfileSheet
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBio ? Icons.fingerprint_rounded : Icons.notifications_active_rounded,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ).animate().scale(
                delay: 100.ms,
                begin: const Offset(0, 0),
                curve: Curves.easeOutBack,
              ),

              const SizedBox(height: 16),

              Text(
                titleText,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.2),

              const SizedBox(height: 8),

              Text(
                bodyText,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.2),

              const SizedBox(height: 32),

              // Actions Layout
              FilledButton(
                onPressed: () => _handleAccept(context, ref),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  l10n.yesBtn,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms)
              .slideY(begin: 0.2),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () => _handleDecline(context, ref),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  isBio ? l10n.noBtn : l10n.notNowBtn,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
