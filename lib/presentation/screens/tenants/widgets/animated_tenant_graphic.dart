import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedTenantGraphic extends StatelessWidget {
  const AnimatedTenantGraphic({super.key});

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
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.2,
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),

          // Left Avatar
          Positioned(
                left: 20,
                top: 40,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 36,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -4,
                end: 4,
                duration: 2.5.seconds,
                curve: Curves.easeInOutSine,
              ),

          // Right Avatar
          Positioned(
                right: 20,
                top: 40,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.tertiaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 36,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: 4,
                end: -4,
                duration: 3.seconds,
                curve: Curves.easeInOutSine,
              ),

          // Front prominent avatar
          Positioned(
                bottom: 10,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 50,
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
            top: 20,
            right: 40,
            child:
                Icon(Icons.auto_awesome, color: colorScheme.secondary, size: 20)
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(begin: 0.8, end: 1.2, duration: 1.seconds)
                    .fade(begin: 0.3, end: 1.0),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child:
                Icon(Icons.star_rounded, color: colorScheme.tertiary, size: 16)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 4.seconds)
                    .fade(begin: 0.2, end: 0.8),
          ),
        ],
      ),
    );
  }
}
