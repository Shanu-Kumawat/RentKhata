import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CelebrationOverlay {
  /// Shows a quick burst of confetti from the left and right sides of the screen.
  static void show(BuildContext context) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return const _DualConfettiWidget();
      },
    );

    overlayState.insert(overlayEntry);

    // Remove the overlay after the confetti has finished falling
    Future.delayed(const Duration(seconds: 4), () {
      overlayEntry.remove();
    });
  }
}

class _DualConfettiWidget extends StatefulWidget {
  const _DualConfettiWidget();

  @override
  State<_DualConfettiWidget> createState() => _DualConfettiWidgetState();
}

class _DualConfettiWidgetState extends State<_DualConfettiWidget> {
  late final ConfettiController _controllerLeft;
  late final ConfettiController _controllerRight;

  @override
  void initState() {
    super.initState();
    // 300ms duration spans multiple frames reliably even during page transitions
    _controllerLeft = ConfettiController(duration: const Duration(milliseconds: 300));
    _controllerRight = ConfettiController(duration: const Duration(milliseconds: 300));

    // Wait a tiny bit for the UI to settle before firing
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _controllerLeft.play();
        _controllerRight.play();
      }
    });
  }

  @override
  void dispose() {
    _controllerLeft.dispose();
    _controllerRight.dispose();
    super.dispose();
  }

  Path _drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (math.pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * math.cos(step),
          halfWidth + externalRadius * math.sin(step));
      path.lineTo(halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    // IgnorePointer ensures the confetti doesn't block any user interactions
    return IgnorePointer(
      child: Stack(
        children: [
          // Left emitter, shooting up and right
          Align(
            alignment: const Alignment(-1.0, 0.2), // Left side, slightly below center
            child: ConfettiWidget(
              confettiController: _controllerLeft,
              blastDirection: -math.pi / 4, // Up and right
              emissionFrequency: 1.0, // Guaranteed emission per frame
              numberOfParticles: 10, // Slightly reduced since it spans more frames
              maxBlastForce: 40,
              minBlastForce: 20,
              gravity: 0.2,
              createParticlePath: _drawStar,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Color(0xFFFFC107), // Amber
              ],
            ),
          ),
          
          // Right emitter, shooting up and left
          Align(
            alignment: const Alignment(1.0, 0.2), // Right side, slightly below center
            child: ConfettiWidget(
              confettiController: _controllerRight,
              blastDirection: -3 * math.pi / 4, // Up and left
              emissionFrequency: 1.0, // Guaranteed emission per frame
              numberOfParticles: 10, // Slightly reduced since it spans more frames
              maxBlastForce: 40,
              minBlastForce: 20,
              gravity: 0.2,
              createParticlePath: _drawStar,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Color(0xFFFFC107), // Amber
              ],
            ),
          ),
        ],
      ),
    );
  }
}
