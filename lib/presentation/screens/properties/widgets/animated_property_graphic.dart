import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedPropertyGraphic extends StatelessWidget {
  const AnimatedPropertyGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient pulse
          Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.08),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.15,
                duration: 2.5.seconds,
                curve: Curves.easeInOut,
              ),

          // Background right building
          Positioned(
                right: 25,
                top: 30,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.apartment,
                    size: 36,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -3,
                end: 3,
                duration: 3.seconds,
                curve: Curves.easeInOutSine,
              ),

          // Background left house
          Positioned(
                left: 20,
                top: 45,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.home_work,
                    size: 30,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: 3,
                end: -3,
                duration: 2.5.seconds,
                curve: Curves.easeInOutSine,
              ),

          // Front prominent building
          Positioned(
                bottom: 15,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.location_city,
                    size: 42,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -5,
                end: 5,
                duration: 2.seconds,
                curve: Curves.easeInOutSine,
              )
              .shimmer(
                delay: 2.seconds,
                duration: 1.seconds,
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),

          // Sparkles
          Positioned(
            top: 15,
            right: 50,
            child:
                Icon(Icons.auto_awesome, color: colorScheme.primary, size: 24)
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(begin: 0.8, end: 1.2, duration: 1.2.seconds)
                    .fade(begin: 0.3, end: 1.0),
          ),
          Positioned(
            bottom: 35,
            left: 15,
            child:
                Icon(Icons.star_rounded, color: colorScheme.tertiary, size: 18)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 5.seconds)
                    .fade(begin: 0.2, end: 0.8),
          ),
        ],
      ),
    );
  }
}
