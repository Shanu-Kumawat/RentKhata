import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedExpenseGraphic extends StatelessWidget {
  const AnimatedExpenseGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Document (Receipt)
          Positioned(
            right: 25,
            top: 10,
            child:
                Container(
                      width: 70,
                      height: 100,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(2),
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
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveX(
                      begin: 0,
                      end: 5,
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    )
                    .rotate(begin: 0.1, end: 0.2, duration: 2.seconds),
          ),

          // Foreground Document (Wallet/Expense Ledger)
          Positioned(
            left: 10,
            bottom: 15,
            child:
                Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.tertiary.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: colorScheme.tertiaryContainer,
                        ),
                      ),
                      child: Center(
                        child:
                            Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: colorScheme.tertiary,
                                  size: 40,
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scaleXY(
                                  begin: 0.95,
                                  end: 1.05,
                                  duration: 1.5.seconds,
                                ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: 2,
                      end: -2,
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Floating Coin 1
          Positioned(
            right: 15,
            bottom: 25,
            child:
                Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.currency_rupee,
                        size: 16,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: 5,
                      end: -15,
                      duration: 1.8.seconds,
                      curve: Curves.easeInOut,
                    )
                    .rotate(begin: -0.2, end: 0.2, duration: 1.8.seconds),
          ),

          // Floating Coin 2
          Positioned(
            left: 20,
            top: 5,
            child:
                Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer.withValues(
                          alpha: 0.6,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.attach_money,
                        size: 12,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: -5,
                      end: 10,
                      duration: 2.2.seconds,
                      curve: Curves.easeInOut,
                    )
                    .rotate(begin: 0.2, end: -0.2, duration: 2.2.seconds),
          ),
        ],
      ),
    );
  }
}
