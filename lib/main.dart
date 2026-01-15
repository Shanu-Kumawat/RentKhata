/// Main entry point for RentKhata app.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await LocalNotificationService().initialize();

  runApp(const ProviderScope(child: RentKhataApp()));
}
