import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedRoomGraphic extends StatelessWidget {
  const AnimatedRoomGraphic({super.key});

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
                  color: colorScheme.secondary.withValues(alpha: 0.08),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.15,
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),

          // Background right key
          Positioned(
                right: 25,
                top: 40,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.vpn_key_rounded,
                    size: 28,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -3,
                end: 3,
                duration: 2.5.seconds,
                curve: Curves.easeInOutSine,
              )
              .rotate(
                begin: 0.05,
                end: -0.05,
                duration: 3.seconds,
                curve: Curves.easeInOutSine,
              ),

          // Background left door hanger
          Positioned(
                left: 25,
                top: 35,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.room_preferences,
                    size: 30,
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

          // Front prominent room
          Positioned(
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.meeting_room_rounded,
                    size: 32,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -4,
                end: 4,
                duration: 2.2.seconds,
                curve: Curves.easeInOut,
              )
              .shimmer(
                delay: 2.seconds,
                duration: 1.5.seconds,
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
              ),

          // Sparkles
          Positioned(
            top: 25,
            left: 55,
            child:
                Icon(Icons.auto_awesome, color: colorScheme.secondary, size: 22)
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(begin: 0.8, end: 1.2, duration: 1.5.seconds)
                    .fade(begin: 0.4, end: 1.0),
          ),
          Positioned(
            bottom: 35,
            right: 25,
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
