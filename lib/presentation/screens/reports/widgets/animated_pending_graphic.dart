import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedPendingGraphic extends StatelessWidget {
  const AnimatedPendingGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Document
          Positioned(
            right: 20,
            bottom: 25,
            child:
                Container(
                      width: 70,
                      height: 90,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 6,
                              width: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.outlineVariant,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 4,
                              width: 30,
                              decoration: BoxDecoration(
                                color: colorScheme.outlineVariant,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveX(
                      begin: 0,
                      end: 10,
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    )
                    .rotate(begin: 0.05, end: 0.1, duration: 2.seconds),
          ),

          // Foreground Checkmark / Celebration Document
          Positioned(
            left: 20,
            top: 20,
            child:
                Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: colorScheme.primaryContainer),
                      ),
                      child: Center(
                        child:
                            Icon(
                                  Icons.check_circle,
                                  color: colorScheme.primary,
                                  size: 40,
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scaleXY(
                                  begin: 1.0,
                                  end: 1.1,
                                  duration: 1.2.seconds,
                                ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: 2,
                      end: -2,
                      duration: 2.5.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Floating Badge
          Positioned(
            right: 10,
            top: 10,
            child:
                Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.celebration,
                        size: 20,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .shake(
                      hz: 2,
                      offset: const Offset(0.05, 0.05),
                      duration: 2.seconds,
                    )
                    .then(delay: 2.seconds),
          ),
        ],
      ),
    );
  }
}
