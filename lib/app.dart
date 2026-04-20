/// RentKhata App root widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'application/providers/billing_providers.dart';
import 'application/providers/locale_provider.dart';
import 'application/providers/theme_settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/router/app_router.dart';
import 'presentation/widgets/activity_tracker.dart';
import 'services/notification_scheduler.dart';

/// The root application widget.
class RentKhataApp extends ConsumerWidget {
  const RentKhataApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appTheme = ref.watch(themeSettingsProvider);

    // Ensure default templates exist on startup
    ref.watch(ensureDefaultTemplatesProvider);

    // Auto-schedule notifications on app startup
    ref.watch(notificationStartupSchedulerProvider);

    // Watch Locale
    final locale = ref.watch(localeNotifierProvider);

    // Determine theme mode and dark theme based on selection
    final ThemeMode themeMode;
    final ThemeData darkThemeData;

    switch (appTheme) {
      case AppTheme.system:
        themeMode = ThemeMode.system;
        darkThemeData = darkTheme();
      case AppTheme.light:
        themeMode = ThemeMode.light;
        darkThemeData = darkTheme();
      case AppTheme.midnightBlue:
        themeMode = ThemeMode.dark;
        darkThemeData = darkTheme();
      case AppTheme.classicGold:
        themeMode = ThemeMode.dark;
        darkThemeData = darkGoldTheme();
    }

    // Wrap with ActivityTracker for inactivity-based locking
    return ActivityTracker(
      child: MaterialApp.router(
        title: 'RentKhata',
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        darkTheme: darkThemeData,
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('hi'),
        ],
        routerConfig: router,
      ),
    );
  }
}
