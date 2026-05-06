/// High-fidelity animated welcome screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            right: 20,
                            bottom: 30,
                            child: Transform.rotate(
                              angle: 0.15,
                              child:
                                  _FloatingCard(
                                        icon: Icons.receipt_long_rounded,
                                        color: colorScheme.secondaryContainer,
                                        iconColor: colorScheme.secondary,
                                      )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(reverse: true),
                                      )
                                      .slideY(
                                        begin: 0,
                                        end: -0.05,
                                        duration: 3.seconds,
                                        curve: Curves.easeInOutSine,
                                      ),
                            ),
                          ).animate().scale(
                            delay: 400.ms,
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          ),

                          // Main card (Property)
                          Positioned(
                            left: 20,
                            top: 20,
                            child: Transform.rotate(
                              angle: -0.1,
                              child:
                                  _FloatingCard(
                                        icon: Icons.apartment_rounded,
                                        color: colorScheme.primaryContainer,
                                        iconColor: colorScheme.primary,
                                        size: 100,
                                        iconSize: 52,
                                      )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(reverse: true),
                                      )
                                      .slideY(
                                        begin: 0,
                                        end: 0.04,
                                        duration: 2.5.seconds,
                                        curve: Curves.easeInOutSine,
                                      ),
                            ),
                          ).animate().scale(
                            delay: 200.ms,
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
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
                            'Effortless Rent Management',
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
                            'Track tenants, bills, and payments in one beautifully secure, offline ledger.',
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
                            'Start Organizing',
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

class _FloatingCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final double size;
  final double iconSize;

  const _FloatingCard({
    required this.icon,
    required this.color,
    required this.iconColor,
    this.size = 80,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
