/// High-fidelity animated welcome screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // We create a sophisticated "Glass/Glow" tech layout.
    // Instead of external assets right now, we use a beautifully orchestrated
    // sequence of Flutter native widgets with flutter_animate which guarantees 120fps.

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Background ambient blurs/glows
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
            bottom: 200,
            right: -150,
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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Premium Hero Asset Composition
                  Center(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Base glow ring
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 1.seconds),

                          // Front card (Ledger/Bills)
                          Positioned(
                                child:
                                    Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: colorScheme.primary
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              32,
                                            ),
                                            child: Image.asset(
                                              'assets/logo/logo_primary_with_bg.png',
                                              width: 140,
                                              height: 140,
                                            ),
                                          ),
                                        )
                                        .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(reverse: true),
                                        )
                                        .slideY(
                                          begin: -0.05,
                                          end: 0.05,
                                          duration: 3.seconds,
                                          curve: Curves.easeInOutSine,
                                        ),
                              )
                              .animate()
                              .scale(
                                delay: 200.ms,
                                duration: 800.ms,
                                curve: Curves.easeOutBack,
                              )
                              .shimmer(
                                delay: 1.seconds,
                                duration: 2.seconds,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 56),

                  // Typography
                  Column(
                    children: [
                      Text(
                            AppLocalizations.of(context)!.welcomeTitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                              height: 1.15,
                              letterSpacing: -1.0,
                            ),
                            textAlign: TextAlign.center,
                          )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 500.ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            curve: Curves.easeOutCubic,
                            duration: 500.ms,
                          ),

                      const SizedBox(height: 16),

                      Text(
                            AppLocalizations.of(context)!.welcomeSubtitle,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 500.ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            curve: Curves.easeOutCubic,
                            duration: 500.ms,
                          ),
                    ],
                  ),

                  const Spacer(),

                  // Premium CTA Button
                  SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => context.go('/add-first-property'),
                          child: Text(
                            AppLocalizations.of(context)!.startOrganizing,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 1000.ms, duration: 500.ms)
                      .slideY(
                        begin: 0.5,
                        end: 0,
                        curve: Curves.easeOutBack,
                        duration: 600.ms,
                      )
                      .shimmer(
                        delay: 2000.ms,
                        duration: 1500.ms,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),

                  const SizedBox(height: 24),
                  
                  // Agreement Text
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        children: [
                          TextSpan(text: AppLocalizations.of(context)!.byContinuingYouAgree),
                          TextSpan(
                            text: AppLocalizations.of(context)!.termsOfService,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final uri = Uri.parse('https://yourwebsite.com/terms');
                                try {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                } catch (e) {
                                  if (context.mounted) {
                                    final l10n = AppLocalizations.of(context)!;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(l10n.couldNotOpenLink(e.toString()))),
                                    );
                                  }
                                }
                              },
                          ),
                          TextSpan(text: AppLocalizations.of(context)!.and),
                          TextSpan(
                            text: AppLocalizations.of(context)!.privacyPolicy,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final uri = Uri.parse('https://yourwebsite.com/privacy');
                                try {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                } catch (e) {
                                  if (context.mounted) {
                                    final l10n = AppLocalizations.of(context)!;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(l10n.couldNotOpenLink(e.toString()))),
                                    );
                                  }
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 500.ms),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
