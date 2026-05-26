/// Splash screen - entry point of the app.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/biometric_providers.dart';

/// Splash screen shown on app launch.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for the gorgeous animation to play
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    // Check if this is the first launch (no landlord profile)
    final isFirstLaunch = await ref.read(isFirstLaunchProvider.future);

    if (!mounted) return;

    if (isFirstLaunch) {
      context.go('/language');
      return;
    }

    // Check if biometric lock is enabled
    final biometricSettings = await ref.read(
      biometricSettingsNotifierProvider.future,
    );
    final isBiometricEnabled = biometricSettings?.isEnabled ?? false;

    if (!mounted) return;

    if (isBiometricEnabled) {
      // Lock the app and navigate to lock screen
      ref.read(appLockStateProvider.notifier).lock();
      context.go('/lock');
    } else {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface, // Matches the WelcomeScreen
      body: Stack(
        children: [
          // Background ambient blurs/glows matching WelcomeScreen
          Positioned(
            top: -100,
            left: -100,
            child:
                Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.15),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(
                      begin: 1.0,
                      end: 1.2,
                      duration: 4.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child:
                Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.secondary.withValues(alpha: 0.1),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(
                      begin: 1.0,
                      end: 1.3,
                      duration: 5.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Container
                Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.25),
                            blurRadius: 40,
                            spreadRadius: 10,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset(
                          'assets/logo/logo_primary_with_bg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .animate()
                    .scale(
                      delay: 200.ms,
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    )
                    .shimmer(
                      delay: 1.seconds,
                      duration: 1500.ms,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),

                const SizedBox(height: 32),

                // Title
                Text(
                      'RentKhata',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: colorScheme.onSurface,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                      'Manage your rentals with ease',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0.2,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
