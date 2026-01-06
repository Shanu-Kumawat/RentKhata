/// App color palette.
library;

import 'package:flutter/material.dart';

/// RentKhata color scheme
class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF2563EB); // Blue 600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue 500
  static const Color primaryDark = Color(0xFF1D4ED8); // Blue 700

  // Secondary palette
  static const Color secondary = Color(0xFF10B981); // Emerald 500
  static const Color secondaryLight = Color(0xFF34D399); // Emerald 400
  static const Color secondaryDark = Color(0xFF059669); // Emerald 600

  // Semantic colors
  static const Color success = Color(0xFF22C55E); // Green 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Neutral palette
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color onSurface = Color(0xFF1E293B); // Slate 800
  static const Color onSurfaceVariant = Color(0xFF64748B); // Slate 500

  // Dark theme
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800
  static const Color surfaceVariantDark = Color(0xFF334155); // Slate 700

  // Financial indicators
  static const Color moneyReceived = Color(0xFF22C55E); // Green
  static const Color moneyPending = Color(0xFFF59E0B); // Amber
  static const Color moneyOverdue = Color(0xFFEF4444); // Red
}
