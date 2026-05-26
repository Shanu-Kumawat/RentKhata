import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedLanguageGraphic extends StatelessWidget {
  const AnimatedLanguageGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryHex =
        (colorScheme.primary.r * 255)
            .toInt()
            .toRadixString(16)
            .padLeft(2, '0') +
        (colorScheme.primary.g * 255)
            .toInt()
            .toRadixString(16)
            .padLeft(2, '0') +
        (colorScheme.primary.b * 255).toInt().toRadixString(16).padLeft(2, '0');

    // Core structural globe lines
    final globeSvg =
        '''
<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#$primaryHex" stroke-width="4" fill="none" stroke-linecap="round">
    <circle cx="50" cy="50" r="40" />
    <ellipse cx="50" cy="50" rx="18" ry="40" />
    <path d="M 14 35 L 86 35" />
    <path d="M 14 65 L 86 65" />
    <path d="M 50 10 L 50 90" />
  </g>
</svg>
''';

    // A stylistic outer ring with orbit nodes
    final orbitalSvg =
        '''
<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#$primaryHex" fill="none" stroke-width="1.5" opacity="0.6">
    <circle cx="60" cy="60" r="56" stroke-dasharray="8 8" />
  </g>
  <circle cx="60" cy="4" r="4" fill="#$primaryHex" />
  <circle cx="116" cy="60" r="3" fill="#$primaryHex" />
  <circle cx="4" cy="60" r="2.5" fill="#$primaryHex" />
</svg>
''';

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft glow
          Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.secondary,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.05,
                duration: 2.seconds,
                curve: Curves.easeInOut,
              )
              .fade(begin: 0.8, end: 1.0),

          // Orbital Ring (Spins slowly)
          SizedBox(
            width: 130,
            height: 130,
            child: SvgPicture.string(orbitalSvg),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 15.seconds),

          // Inner Globe (Spins opposite direction)
          SizedBox(width: 60, height: 60, child: SvgPicture.string(globeSvg)),

          // Floating Language Characters (A)
          Positioned(
            top: 25,
            left: 25,
            child:
                Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        "A",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: -3,
                      end: 3,
                      duration: 1.5.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Floating Language Characters (अ)
          Positioned(
            bottom: 25,
            right: 20,
            child:
                Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        "अ",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: 3,
                      end: -3,
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),
        ],
      ),
    );
  }
}
