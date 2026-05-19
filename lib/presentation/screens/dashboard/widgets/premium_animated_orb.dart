import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumAnimatedOrb extends StatelessWidget {
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final double size;

  const PremiumAnimatedOrb({
    super.key,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft glowing blob 1
          _AnimatedBlob(
            color: secondaryColor.withValues(alpha: 0.15),
            size: size * 0.85,
            duration: 4.seconds,
            delay: 0.ms,
          ),
          
          // Background soft glowing blob 2
          _AnimatedBlob(
            color: primaryColor.withValues(alpha: 0.1),
            size: size * 0.75,
            duration: 3.5.seconds,
            delay: 1.seconds,
            reverse: true,
          ),

          // Core crisp ring
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.15),
                  blurRadius: 24,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: secondaryColor.withValues(alpha: 0.08),
                  blurRadius: 10,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scaleXY(begin: 1.0, end: 1.03, duration: 2.seconds, curve: Curves.easeInOut)
           .shimmer(duration: 3.seconds, color: primaryColor.withValues(alpha: 0.1)),

          // The Icon Itself
          Icon(
            icon,
            size: size * 0.3,
            color: primaryColor,
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .slideY(begin: -0.05, end: 0.05, duration: 1.5.seconds, curve: Curves.easeInOut)
           .scaleXY(begin: 0.98, end: 1.02, duration: 1.5.seconds, curve: Curves.easeInOut),

          // Orbiting particles
          ...List.generate(3, (index) => _OrbitingParticle(
            color: index % 2 == 0 ? primaryColor : secondaryColor,
            orbitSize: size * (0.4 + (index * 0.15)),
            duration: Duration(milliseconds: 3000 + (index * 1500)),
            particleSize: 4.0 + (index * 2),
            offsetAngle: index * (math.pi / 1.5),
          )),
        ],
      ),
    );
  }
}

class _AnimatedBlob extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;
  final Duration delay;
  final bool reverse;

  const _AnimatedBlob({
    required this.color,
    required this.size,
    required this.duration,
    required this.delay,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scaleXY(begin: 0.9, end: 1.1, duration: duration, delay: delay, curve: Curves.easeInOut)
     .rotate(begin: reverse ? 0.05 : -0.05, end: reverse ? -0.05 : 0.05, duration: duration, curve: Curves.easeInOut);
  }
}

class _OrbitingParticle extends StatefulWidget {
  final Color color;
  final double orbitSize;
  final Duration duration;
  final double particleSize;
  final double offsetAngle;

  const _OrbitingParticle({
    required this.color,
    required this.orbitSize,
    required this.duration,
    required this.particleSize,
    required this.offsetAngle,
  });

  @override
  State<_OrbitingParticle> createState() => _OrbitingParticleState();
}

class _OrbitingParticleState extends State<_OrbitingParticle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = (_controller.value * 2 * math.pi) + widget.offsetAngle;
        final x = math.cos(angle) * (widget.orbitSize / 2);
        final y = math.sin(angle) * (widget.orbitSize / 2);
        
        // Add a gentle bobbing effect to the particle size
        final pulse = 1.0 + (0.3 * math.sin(_controller.value * 4 * math.pi));

        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: widget.particleSize * pulse,
            height: widget.particleSize * pulse,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.6),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
