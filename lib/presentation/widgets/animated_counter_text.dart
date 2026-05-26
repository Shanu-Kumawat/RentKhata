import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';

enum CounterFormat { currency, raw }

/// A widget that implicitly animates its numeric value counting from 0 to the target.
class AnimatedCounterText extends StatelessWidget {
  final double value;
  final Duration duration;
  final TextStyle? style;
  final CounterFormat format;
  final String? suffix;

  const AnimatedCounterText({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1000),
    this.style,
    this.format = CounterFormat.currency,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: value),
      duration: duration,
      curve: Curves.easeOutQuart,
      builder: (context, val, child) {
        String displayValue;
        if (format == CounterFormat.currency) {
          displayValue = formatCurrency(val);
        } else {
          displayValue = val.toStringAsFixed(0);
        }
        if (suffix != null) {
          displayValue += suffix!;
        }
        return Text(displayValue, style: style);
      },
    );
  }
}
