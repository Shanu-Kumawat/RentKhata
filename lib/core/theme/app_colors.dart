/// App color palettes for RentKhata.
///
/// Defines semantic color palettes for light and dark themes.
/// Each palette follows a consistent structure:
/// - heading:    headings, titles, important text
/// - primary:    primary buttons, CTAs, active elements
/// - secondary:  cards, containers, secondary surfaces
/// - border:     borders, dividers, outlines
/// - bodyText:   body text, labels, helper text
/// - background: scaffold / app background
library;

import 'package:flutter/material.dart';

/// Base class for color palettes with semantic color roles.
abstract class AppPalette {
  /// Headings, titles, important text
  Color get heading;

  /// Primary buttons, CTAs, active elements
  Color get primary;

  /// Cards, containers, secondary surfaces
  Color get secondary;

  /// Borders, dividers, outlines
  Color get border;

  /// Body text, labels, helper text
  Color get bodyText;

  /// Scaffold / app background
  Color get background;
}

/// Light theme color palette.
///
/// A clean, professional palette with subtle blues and high contrast text.
class LightPalette implements AppPalette {
  const LightPalette();

  @override
  Color get heading => const Color(0xFF002055);

  @override
  Color get primary => const Color(0xFF756EF3);

  @override
  Color get secondary => const Color(0xFFD1E2FE);

  @override
  Color get border => const Color(0xFFE9F1FF);

  @override
  Color get bodyText => const Color(0xFF848A94);

  @override
  Color get background => const Color(0xFFFFFFFF);
}

/// Dark theme color palette with blue accent (default dark theme).
///
/// A modern dark palette with vibrant blue accents.
class DarkBluePalette implements AppPalette {
  const DarkBluePalette();

  @override
  Color get heading => const Color(0xFFFFFFFF);

  @override
  Color get primary => const Color(0xFF3580FF);

  @override
  Color get secondary => const Color(0xFF142545);

  @override
  Color get border => const Color(0xFF191D30);

  @override
  Color get bodyText => const Color(0xFF848A94);

  @override
  Color get background => const Color(0xFF0A0C16);
}

/// Dark theme color palette with gold/beige accent (optional).
///
/// A warm dark palette with elegant gold tones.
class DarkGoldPalette implements AppPalette {
  const DarkGoldPalette();

  @override
  Color get heading => const Color(0xFFFFFFFF);

  @override
  Color get primary => const Color(0xFFC5A059);

  @override
  Color get secondary => const Color(0xFF242934);

  @override
  Color get border => const Color(0xFF191D30);

  @override
  Color get bodyText => const Color(0xFF848A94);

  @override
  Color get background => const Color(0xFF000714);
}

/// Centralized access to app color palettes.
class AppColors {
  AppColors._();

  /// Light theme palette instance.
  static const AppPalette light = LightPalette();

  /// Dark theme palette instance (blue accent - default).
  static const AppPalette dark = DarkBluePalette();

  /// Optional dark theme with gold/beige accent.
  static const AppPalette darkGold = DarkGoldPalette();

  // ─────────────────────────────────────────────────────────────────────────
  // Theme-aware color getters
  // Use these with BuildContext to get proper theme-aware colors.
  // ─────────────────────────────────────────────────────────────────────────

  /// Get the current palette based on theme brightness.
  static AppPalette paletteOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  /// Primary accent color (theme-aware).
  static Color primaryOf(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  /// Secondary color (theme-aware).
  static Color secondaryOf(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  /// Surface color (theme-aware).
  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  /// On-surface color for text/icons (theme-aware).
  static Color onSurfaceOf(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  /// Outline color for borders (theme-aware).
  static Color outlineOf(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  // ─────────────────────────────────────────────────────────────────────────
  // Legacy color constants (backwards compatibility - PREFER THEME-AWARE)
  // WARNING: These return LIGHT theme colors. Use the getters above instead.
  // ─────────────────────────────────────────────────────────────────────────

  /// Primary accent color (from light palette).
  /// @Deprecated Use primaryOf(context) instead for theme-aware colors.
  static const Color primary = Color(0xFF756EF3);

  /// Lighter variant of primary for dark theme accents.
  static const Color primaryLight = Color(0xFF3580FF);

  /// Darker variant of primary.
  static const Color primaryDark = Color(0xFF5A54D8);

  /// Secondary accent color (emerald for success states).
  static const Color secondary = Color(0xFF10B981);

  /// Lighter secondary variant.
  static const Color secondaryLight = Color(0xFF34D399);

  /// Darker secondary variant.
  static const Color secondaryDark = Color(0xFF059669);

  /// Surface color (cards, containers).
  /// @Deprecated Use surfaceOf(context) instead.
  static const Color surface = Color(0xFFFFFFFF);

  /// Variant surface color (input fields, subtle backgrounds).
  /// @Deprecated Use Theme.of(context).colorScheme.surfaceContainerHighest.
  static const Color surfaceVariant = Color(0xFFD1E2FE);

  /// Text on surface.
  /// @Deprecated Use onSurfaceOf(context) instead.
  static const Color onSurface = Color(0xFF002055);

  /// Text on surface variant (labels, helper text).
  /// @Deprecated Use Theme.of(context).colorScheme.onSurfaceVariant.
  static const Color onSurfaceVariant = Color(0xFF848A94);

  /// Light mode background.
  static const Color background = Color(0xFFFFFFFF);

  /// Dark mode surface.
  static const Color surfaceDark = Color(0xFF142545);

  /// Dark mode surface variant.
  static const Color surfaceVariantDark = Color(0xFF191D30);

  /// Dark mode background.
  static const Color backgroundDark = Color(0xFF0A0C16);

  // ─────────────────────────────────────────────────────────────────────────
  // Semantic colors (theme-independent)
  // ─────────────────────────────────────────────────────────────────────────

  /// Success indicator color.
  static const Color success = Color(0xFF22C55E);

  /// Warning indicator color.
  static const Color warning = Color(0xFFF59E0B);

  /// Error indicator color.
  static const Color error = Color(0xFFEF4444);

  /// Informational indicator color.
  static const Color info = Color(0xFF3B82F6);

  // ─────────────────────────────────────────────────────────────────────────
  // High contrast semantic colors (for text on light backgrounds)
  // ─────────────────────────────────────────────────────────────────────────

  /// Success text color with high contrast.
  static const Color successText = Color(0xFF15803D);

  /// Warning text color with high contrast.
  static const Color warningText = Color(0xFFB45309);

  /// Error text color with high contrast.
  static const Color errorText = Color(0xFFB91C1C);

  // ─────────────────────────────────────────────────────────────────────────
  // Financial indicators
  // ─────────────────────────────────────────────────────────────────────────

  /// Color for received/collected money.
  static const Color moneyReceived = Color(0xFF22C55E);

  /// Color for pending payments.
  static const Color moneyPending = Color(0xFFF59E0B);

  /// Color for overdue payments.
  static const Color moneyOverdue = Color(0xFFEF4444);
}
