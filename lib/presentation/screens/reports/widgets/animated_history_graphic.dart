import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedHistoryGraphic extends StatelessWidget {
  const AnimatedHistoryGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Document (Archived)
          Positioned(
            left: 15,
            top: 15,
            child:
                Container(
                      width: 75,
                      height: 95,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 6,
                              width: 30,
                              decoration: BoxDecoration(
                                color: colorScheme.outlineVariant,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 4,
                              width: 45,
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
                      end: -8,
                      duration: 2.2.seconds,
                      curve: Curves.easeInOut,
                    )
                    .rotate(begin: -0.05, end: -0.15, duration: 2.2.seconds),
          ),

          // Foreground Ledger Document
          Positioned(
            right: 15,
            bottom: 15,
            child:
                Container(
                      width: 80,
                      height: 105,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.secondary.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: colorScheme.secondaryContainer,
                        ),
                      ),
                      child: Center(
                        child:
                            Icon(
                                  Icons.history_edu,
                                  color: colorScheme.secondary,
                                  size: 42,
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .moveY(
                                  begin: 2,
                                  end: -2,
                                  duration: 1.5.seconds,
                                ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: -2,
                      end: 2,
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Floating Badge
          Positioned(
            left: 15,
            bottom: 5,
            child:
                Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 20,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(begin: 1.0, end: 1.15, duration: 2.seconds),
          ),
        ],
      ),
    );
  }
}
