import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedVacantGraphic extends StatelessWidget {
  const AnimatedVacantGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient pulse (empty room feel)
          Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.15,
                duration: 3.seconds,
                curve: Curves.easeInOut,
              ),

          // Background right floating door (open)
          Positioned(
                right: 20,
                top: 30,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.meeting_room_outlined,
                    size: 36,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -3,
                end: 3,
                duration: 3.5.seconds,
                curve: Curves.easeInOutSine,
              ),

          // Background left floating keys
          Positioned(
                left: 20,
                top: 45,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.key,
                    size: 28,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: 4,
                end: -4,
                duration: 2.5.seconds,
                curve: Curves.easeInOutSine,
              )
              .rotate(begin: -0.05, end: 0.05, duration: 2.5.seconds),

          // Front prominent Add User graphic
          Positioned(
                bottom: 15,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 48,
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
                duration: 1.5.seconds,
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),

          // Waiting indicator (Dots)
          Positioned(
            top: 15,
            left: 65,
            child:
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.inverseSurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: colorScheme.onInverseSurface,
                        size: 16,
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fade(begin: 0.3, end: 1.0, duration: 1.seconds)
                    .moveY(begin: -2, end: 2, duration: 2.seconds),
          ),
        ],
      ),
    );
  }
}
