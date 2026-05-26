import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../services/local_notification_service.dart';

enum PermissionVariant { biometrics, notifications }

class PremiumPermissionSheet extends StatelessWidget {
  final PermissionVariant variant;

  const PremiumPermissionSheet({super.key, required this.variant});

  static Future<void> showBiometrics(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasRequested = prefs.getBool('has_seen_biometrics_prompt') ?? false;

    if (!hasRequested && context.mounted) {
      prefs.setBool('has_seen_biometrics_prompt', true);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        isDismissible: false,
        enableDrag: false,
        builder: (context) =>
            const PremiumPermissionSheet(variant: PermissionVariant.biometrics),
      );
    }
  }

  static Future<void> showNotifications(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasRequested = prefs.getBool('has_seen_notification_prompt') ?? false;

    if (!hasRequested && context.mounted) {
      prefs.setBool('has_seen_notification_prompt', true);
      showModalBottomSheet(
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

  Future<void> _handlePermissions(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    if (variant == PermissionVariant.notifications) {
      final notifService = LocalNotificationService();
      await notifService.requestPermission();
    } else if (variant == PermissionVariant.biometrics) {
      try {
        final auth = LocalAuthentication();
        final canAuthenticate =
            await auth.canCheckBiometrics || await auth.isDeviceSupported();
        if (canAuthenticate) {
          final didAuthenticate = await auth.authenticate(
            localizedReason: 'Secure your financial ledger',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: false,
            ),
          );
          if (didAuthenticate) {
            await prefs.setBool('app_locked', true);
          }
        }
      } catch (_) {}
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isBio = variant == PermissionVariant.biometrics;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Illustration
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBio
                      ? Icons.fingerprint_rounded
                      : Icons.notifications_active_rounded,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ).animate().scale(
                delay: 200.ms,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),

              const SizedBox(height: 24),

              Text(
                    isBio ? 'Secure Your Ledger' : 'Stay Informed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),

              const SizedBox(height: 16),

              Text(
                    isBio
                        ? 'Keep your property data safe. Lock RentKhata with Fingerprint?'
                        : 'Want us to remind you when a tenant\'s rent is due?',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),

              const SizedBox(height: 40),

              SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () => _handlePermissions(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isBio ? 'Enable App Lock' : 'Enable Notifications',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Text(
                  'Not Now',
                  style: GoogleFonts.inter(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
