/// Theme settings provider.
///
/// Manages app theme preferences with a single unified theme selector.
/// Persisted via SharedPreferences.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Available app themes.
enum AppTheme {
  /// System default - follows device setting
  system,

  /// Light theme - clean, professional
  light,

  /// Midnight Blue - modern dark with blue accents
  midnightBlue,

  /// Classic Gold - elegant dark with warm gold tones
  classicGold,
}

extension AppThemeExtension on AppTheme {
  /// Display name for the theme.
  String get displayName => switch (this) {
    AppTheme.system => 'System Default',
    AppTheme.light => 'Light',
    AppTheme.midnightBlue => 'Midnight Blue',
    AppTheme.classicGold => 'Classic Gold',
  };

  /// Subtitle description.
  String get subtitle => switch (this) {
    AppTheme.system => 'Follow device settings',
    AppTheme.light => 'Clean and professional',
    AppTheme.midnightBlue => 'Modern dark with blue accents',
    AppTheme.classicGold => 'Elegant dark with warm tones',
  };

  /// Icon for the theme.
  IconData get icon => switch (this) {
    AppTheme.system => Icons.brightness_auto,
    AppTheme.light => Icons.light_mode,
    AppTheme.midnightBlue => Icons.dark_mode,
    AppTheme.classicGold => Icons.auto_awesome,
  };

  /// Preview color for the theme.
  Color get previewColor => switch (this) {
    AppTheme.system => Colors.grey,
    AppTheme.light => const Color(0xFF756EF3),
    AppTheme.midnightBlue => const Color(0xFF3580FF),
    AppTheme.classicGold => const Color(0xFFC5A059),
  };

  /// Whether this is a dark theme.
  bool get isDark =>
      this == AppTheme.midnightBlue || this == AppTheme.classicGold;
}

/// Keys for SharedPreferences storage.
class _PrefsKeys {
  static const appTheme = 'app_theme';
}

/// Theme settings notifier that persists preferences.
class ThemeSettingsNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() {
    // Load saved settings asynchronously
    _loadFromPrefs();
    return AppTheme.system;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_PrefsKeys.appTheme);
    if (themeIndex != null && themeIndex < AppTheme.values.length) {
      state = AppTheme.values[themeIndex];
    }
  }

  /// Set the app theme and persist.
  Future<void> setTheme(AppTheme theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_PrefsKeys.appTheme, theme.index);
  }
}

/// Global theme settings provider.
final themeSettingsProvider = NotifierProvider<ThemeSettingsNotifier, AppTheme>(
  ThemeSettingsNotifier.new,
);
