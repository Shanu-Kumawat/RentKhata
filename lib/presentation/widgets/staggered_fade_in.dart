import 'package:flutter/material.dart';

/// A lightweight widget that fades in and slides up its child after a delay.
class StaggeredFadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double verticalOffset;

  const StaggeredFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.verticalOffset = 20.0,
  });

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(StaggeredFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-trigger animation if the child is replaced in a way that should restart it,
    // but for simple dashboard layout we usually just want it to run once on load.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, widget.verticalOffset * (1 - _animation.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
