/// App theme configuration.
///
/// Builds Material 3 themes from semantic color palettes.
/// Themes automatically switch based on system settings via [ThemeMode.system].
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Builds a [ThemeData] from the given [AppPalette].
///
/// This factory method creates consistent theme configurations using
/// the semantic color roles defined in each palette.
ThemeData _buildTheme(AppPalette palette, Brightness brightness) {
  final isLight = brightness == Brightness.light;

  // Text theme with semantic colors
  final baseTextTheme = isLight
      ? ThemeData.light().textTheme
      : ThemeData.dark().textTheme;

  final textTheme = GoogleFonts.interTextTheme(baseTextTheme).copyWith(
    // Headings use the heading color
    displayLarge: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      color: palette.heading,
      fontWeight: FontWeight.w500,
    ),
    // Body text uses the bodyText color
    bodyLarge: GoogleFonts.inter(color: palette.bodyText),
    bodyMedium: GoogleFonts.inter(color: palette.bodyText),
    bodySmall: GoogleFonts.inter(color: palette.bodyText),
    labelLarge: GoogleFonts.inter(color: palette.bodyText),
    labelMedium: GoogleFonts.inter(color: palette.bodyText),
    labelSmall: GoogleFonts.inter(color: palette.bodyText),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: isLight ? Colors.white : palette.heading,
      secondary: palette.secondary,
      onSecondary: palette.heading,
      surface: palette.background,
      onSurface: palette.heading,
      surfaceContainerHighest: palette.background,
      surfaceContainer: palette.background,
      surfaceContainerHigh: palette.background,
      surfaceContainerLow: palette.background,
      surfaceContainerLowest: palette.background,
      outline: palette.border,
      outlineVariant: palette.border,
      error: AppColors.error,
      onError: Colors.white,
    ),

    // Scaffold background
    scaffoldBackgroundColor: palette.background,

    // Primary color for backwards compatibility
    primaryColor: palette.primary,

    // Divider color
    dividerColor: palette.border,

    // Text theme
    textTheme: textTheme,

    // AppBar theme
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: palette.background,
      foregroundColor: palette.heading,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: palette.heading,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: palette.border),
      ),
      color: palette.background,
      surfaceTintColor: Colors.transparent,
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: palette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: palette.border),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: palette.primary,
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: palette.bodyText),
      hintStyle: GoogleFonts.inter(color: palette.bodyText),
      errorStyle: GoogleFonts.inter(color: AppColors.error),
    ),

    // Floating action button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: palette.primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: palette.background,
      selectedItemColor: palette.primary,
      unselectedItemColor: palette.bodyText,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Navigation bar theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: palette.background,
      indicatorColor: palette.primary.withAlpha(30),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            color: palette.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }
        return GoogleFonts.inter(
          color: palette.bodyText,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: palette.primary);
        }
        return IconThemeData(color: palette.bodyText);
      }),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(color: palette.border, thickness: 1),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Bottom sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: palette.background,
      side: BorderSide(color: palette.border),
      labelStyle: GoogleFonts.inter(color: palette.heading),
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      iconColor: palette.bodyText,
      textColor: palette.heading,
    ),

    // Icon theme
    iconTheme: IconThemeData(color: palette.bodyText),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return palette.bodyText;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.primary;
        }
        return palette.border;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: palette.border, width: 2),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.primary;
        }
        return palette.bodyText;
      }),
    ),

    // Progress indicator theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: palette.primary,
      linearTrackColor: palette.border,
      circularTrackColor: palette.border,
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isLight ? palette.heading : palette.secondary,
      contentTextStyle: GoogleFonts.inter(
        color: isLight ? Colors.white : palette.heading,
      ),
      actionTextColor: palette.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: palette.primary,
      unselectedLabelColor: palette.bodyText,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: palette.primary, width: 2),
      ),
    ),

    // Popup menu theme
    popupMenuTheme: PopupMenuThemeData(
      color: palette.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: palette.border),
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: isLight ? palette.heading : palette.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: isLight ? Colors.white : palette.heading,
        fontSize: 12,
      ),
    ),
  );
}

/// Light theme using the light color palette.
ThemeData lightTheme() {
  return _buildTheme(AppColors.light, Brightness.light);
}

/// Dark theme using the blue accent palette (default dark theme).
ThemeData darkTheme() {
  return _buildTheme(AppColors.dark, Brightness.dark);
}

/// Optional dark theme using the gold/beige accent palette.
ThemeData darkGoldTheme() {
  return _buildTheme(AppColors.darkGold, Brightness.dark);
}
