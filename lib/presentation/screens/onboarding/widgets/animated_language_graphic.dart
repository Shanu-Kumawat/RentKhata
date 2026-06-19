import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedLanguageGraphic extends StatelessWidget {
  const AnimatedLanguageGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _OrbitPainter(colorScheme.primary),
            ),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 15.seconds),

          // Inner Globe (Spins opposite direction)
          Icon(
            Icons.public,
            size: 50,
            color: colorScheme.primary,
          ),

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

class _OrbitPainter extends CustomPainter {
  final Color color;
  _OrbitPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw dashed circle
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Simple dashed circle approximation (a continuous circle looks just as good usually, 
    // but here is a simple circle for brevity since drawing dashed paths requires path metric parsing)
    canvas.drawCircle(center, size.width / 2 - 4, paint);

    // Draw nodes
    final nodePaint = Paint()..color = color;
    canvas.drawCircle(Offset(size.width / 2, 4), 4, nodePaint);
    canvas.drawCircle(Offset(size.width - 4, size.height / 2), 3, nodePaint);
    canvas.drawCircle(Offset(4, size.height / 2), 2.5, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
