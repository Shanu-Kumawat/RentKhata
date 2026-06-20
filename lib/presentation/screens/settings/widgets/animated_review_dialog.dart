import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:confetti/confetti.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../../../../application/providers/review_provider.dart';
import '../../../../application/providers/analytics_provider.dart';

enum ReviewTriggerContext { bill, payment, settings }

class AnimatedReviewDialog extends ConsumerStatefulWidget {
  final ReviewTriggerContext triggerContext;

  const AnimatedReviewDialog({
    super.key,
    required this.triggerContext,
  });

  /// Helper to show the dialog
  static Future<void> show(BuildContext context, {ReviewTriggerContext triggerContext = ReviewTriggerContext.settings}) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false, // Force them to interact, but X button allows escape
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedReviewDialog(triggerContext: triggerContext);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  ConsumerState<AnimatedReviewDialog> createState() => _AnimatedReviewDialogState();
}

class _AnimatedReviewDialogState extends ConsumerState<AnimatedReviewDialog> with TickerProviderStateMixin {
  late final AnimationController _starController;
  late final List<Animation<double>> _starAnimations;

  // Floating star animation
  late final AnimationController _floatController;
  late final AnimationController _sparkleController;

  // Confetti controller
  late final ConfettiController _confettiController;

  // Shimmer animation controller
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Log the impression
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logReviewPromptShown(context: widget.triggerContext.name);
    });

    // Staggered Stars Animation
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _starAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _starController,
          curve: Interval(start, start + 0.4, curve: Curves.elasticOut),
        ),
      );
    });

    // Continuous floating animation for stars
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000), // Slower cycle
    )..repeat();

    // Premium Shimmer Animation (loops)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        // Wait for a bit before looping the shimmer
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutSine),
      ),
    );

    // Setup confetti (short duration for a massive single burst)
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));

    // Start animations immediately
    _starController.forward();
    _confettiController.play();
  }

  bool _actionTaken = false;

  @override
  void dispose() {
    _starController.dispose();
    _floatController.dispose();
    _sparkleController.dispose();
    _shimmerController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _handleRate() async {
    _actionTaken = true;
    ref.read(analyticsServiceProvider).logReviewPromptRateClicked(context: widget.triggerContext.name);
    
    final service = ref.read(reviewServiceProvider);
    await service.triggerAppStoreReview();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _handleSuggestion() async {
    _actionTaken = true;
    ref.read(analyticsServiceProvider).logReviewPromptSuggestionClicked(context: widget.triggerContext.name);

    final service = ref.read(reviewServiceProvider);
    await service.recordSuggestionGiven();
    if (mounted) Navigator.of(context).pop();
    
    final uri = Uri.parse('https://forms.gle/RKqyK34Px2ggcrEm6');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Ignore
    }
  }

  Future<void> _handleClose() async {
    _actionTaken = true;
    ref.read(analyticsServiceProvider).logReviewPromptDismissed(context: widget.triggerContext.name);

    final service = ref.read(reviewServiceProvider);
    await service.recordDecline();
    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildRichText(String text, TextStyle defaultStyle, Color highlightColor) {
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        spans.add(TextSpan(
          text: parts[i],
          style: defaultStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: highlightColor,
          ),
        ));
      } else {
        spans.add(TextSpan(text: parts[i], style: defaultStyle));
      }
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use Theme Colors
    final bgColor = colorScheme.surface;
    final primaryColor = colorScheme.primary;
    final onPrimaryColor = colorScheme.onPrimary;
    
    // Create a subtle gradient based on the primary theme color without transparency
    // to keep the button fully opaque like before.
    final buttonGradient = LinearGradient(
      colors: [
        colorScheme.primary,
        // Slightly darken the primary color for a rich gradient effect instead of using opacity
        Color.lerp(colorScheme.primary, Colors.black, 0.15) ?? colorScheme.primary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop && !_actionTaken) {
          // The user dismissed the dialog using the system back button/gesture!
          // We must record this as a decline so the repeat cycle logic still applies.
          ref.read(analyticsServiceProvider).logReviewPromptDismissed(context: widget.triggerContext.name);
          final service = ref.read(reviewServiceProvider);
          await service.recordDecline();
        }
      },
      child: Stack(
      children: [
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
          // Reduced horizontal margin to make the container wider
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3), // Reverted to 0.3
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle background glow behind stars matching the primary color
              Positioned(
                top: -50,
                left: 0,
                right: 0,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.15), // Reverted to 0.15
                        blurRadius: 100,
                        spreadRadius: 20,
                      )
                    ],
                  ),
                ),
              ),

              // Confetti blast was moved to top level
              
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tiny close button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: _handleClose,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Bouncing Stars with Glow
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return ScaleTransition(
                            scale: _starAnimations[index],
                            child: AnimatedBuilder(
                              animation: Listenable.merge([_floatController, _sparkleController]),
                              builder: (context, child) {
                                // Add a floating sine wave offset, staggered by index so they wave
                                final floatOffset = math.sin((_floatController.value * math.pi * 2) + (index * 1.5)) * 4.0;
                                
                                // New sparkle logic (random-feeling pulse & spin)
                                // We use a continuous sine wave mixed with the star index to create unique moments of "sparkle"
                                final sparkleValue = math.sin(_sparkleController.value * math.pi * 2 + (index * 2.3));
                                
                                double extraScale = 1.0;
                                double extraRotation = 0.0;
                                
                                // Only sparkle when the sine wave peaks (lowered threshold to make it last longer)
                                if (sparkleValue > 0.7) {
                                  // Map 0.7 -> 1.0 to an intensity from 0.0 -> 1.0
                                  final intensity = (sparkleValue - 0.7) / 0.3;
                                  extraScale = 1.0 + (0.2 * intensity); // Grow up to 20%
                                  // Wiggle left and right based on intensity curve (slower wiggle)
                                  extraRotation = math.sin(intensity * math.pi * 3) * 0.15; 
                                }

                                return Transform.translate(
                                  // Keep the previous squeeze translation AND add the float offset
                                  offset: Offset((index - 2) * -4.0, floatOffset),
                                  child: Transform.scale(
                                    scale: extraScale,
                                    child: Transform.rotate(
                                      angle: extraRotation,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: RotationTransition(
                                turns: Tween<double>(begin: -0.2, end: 0).animate(_starAnimations[index]),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: const Color(0xFFFFC107), // Keep stars amber
                                  size: 56, // Increased size slightly to fill space
                                  shadows: [
                                    Shadow(
                                      color: const Color(0xFFFFC107).withValues(alpha: 0.6), // Reverted to 0.6
                                      blurRadius: 12, // Reverted to 12
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title
                    Text(
                      widget.triggerContext == ReviewTriggerContext.bill 
                        ? AppLocalizations.of(context)!.reviewTitleBill 
                        : widget.triggerContext == ReviewTriggerContext.payment 
                          ? AppLocalizations.of(context)!.reviewTitlePayment 
                          : AppLocalizations.of(context)!.reviewTitleDefault,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                        fontSize: widget.triggerContext != ReviewTriggerContext.settings ? 22 : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    _buildRichText(
                      widget.triggerContext != ReviewTriggerContext.settings 
                        ? AppLocalizations.of(context)!.reviewSubtitleBillPayment
                        : AppLocalizations.of(context)!.reviewSubtitleDefault,
                      theme.textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.6,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      colorScheme.primary,
                    ),
                    const SizedBox(height: 36),
                    
                    // Premium Shimmering Button with Wiggle & Badge
                    AnimatedBuilder(
                      animation: _shimmerAnimation,
                      builder: (context, child) {
                        // Wiggle slightly only when the shimmer beam is passing over the button
                        double angle = 0;
                        if (_shimmerAnimation.value > -0.2 && _shimmerAnimation.value < 1.2) {
                          angle = math.sin(_shimmerAnimation.value * math.pi * 6) * 0.025;
                        }
                        return Transform.rotate(
                          angle: angle,
                          child: child,
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.4), // Reverted to 0.4
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  // Base Button Gradient
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: buttonGradient,
                                    ),
                                    alignment: Alignment.center,
                                    constraints: const BoxConstraints(minHeight: 60),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.reviewRateButton,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w900,
                                            color: onPrimaryColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.star_rounded, color: onPrimaryColor, size: 24),
                                      ],
                                    ),
                                  ),
                                  
                                  // Shimmer Overlay
                                  Positioned.fill(
                                    child: AnimatedBuilder(
                                      animation: _shimmerAnimation,
                                      builder: (context, child) {
                                        return FractionallySizedBox(
                                          widthFactor: 0.3, // Width of the light beam
                                          alignment: Alignment(_shimmerAnimation.value, 0),
                                          child: Transform.scale(
                                            scale: 3.0,
                                            child: Transform.rotate(
                                              angle: 0.4, // Slant angle
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white.withValues(alpha: 0.0),
                                                      Colors.white.withValues(alpha: 0.4),
                                                      Colors.white.withValues(alpha: 0.0),
                                                    ],
                                                    stops: const [0.1, 0.5, 0.9],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  
                                  // InkWell for tap handling and ripple effects
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _handleRate,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Urgency / Microcopy Badge
                          Positioned(
                            top: -12,
                            right: -8,
                            child: Transform.rotate(
                              angle: 0.15,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4757), // Energetic Coral Red
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF4757).withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.reviewTakes5s,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const Icon(Icons.bolt_rounded, color: Colors.amber, size: 14),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Secondary Button
                    TextButton.icon(
                      onPressed: _handleSuggestion,
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      icon: const Icon(Icons.feedback_outlined, size: 18),
                      label: Text(
                        AppLocalizations.of(context)!.reviewSuggestionButton,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    
    // Confetti massive blast from the center covering the whole screen
    IgnorePointer(
      child: Align(
        alignment: const Alignment(0.0, -0.6), // 20% below top center
        child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive, // blast in all directions!
        maxBlastForce: 50, // huge blast force
        minBlastForce: 10,
        emissionFrequency: 0.1, // denser bursts
        numberOfParticles: 50, // lots of particles
        gravity: 0.25, // slightly heavier to fall beautifully
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          Color(0xFFFFC107)
        ],
      ),
    ),
    ),
    ],
    ),
    );
  }
}
