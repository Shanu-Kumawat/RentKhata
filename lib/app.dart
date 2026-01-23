/// RentKhata App root widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'application/providers/billing_providers.dart';
import 'core/theme/app_theme.dart';
import 'presentation/router/app_router.dart';
import 'services/notification_scheduler.dart';

/// The root application widget.
class RentKhataApp extends ConsumerWidget {
  const RentKhataApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Ensure default templates exist on startup
    ref.watch(ensureDefaultTemplatesProvider);

    // Auto-schedule notifications on app startup
    ref.watch(notificationStartupSchedulerProvider);

    return MaterialApp.router(
      title: 'RentKhata',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
