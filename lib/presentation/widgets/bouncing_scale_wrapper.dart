import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that scales down slightly when pressed, providing tactile feedback.
/// Part of the RentKhata Design System.
class BouncingScaleWrapper extends StatefulWidget {
  final Widget child;
  final double scaleFactor;
  final Duration duration;
  final VoidCallback? onTap;

  const BouncingScaleWrapper({
    super.key,
    required this.child,
    this.scaleFactor = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.onTap,
  });

  @override
  State<BouncingScaleWrapper> createState() => _BouncingScaleWrapperState();
}

class _BouncingScaleWrapperState extends State<BouncingScaleWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
      value: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
