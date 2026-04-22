/// Main entry point for RentKhata app.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'services/local_notification_service.dart';
import 'services/image_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await LocalNotificationService().initialize();

  // Cache document directory for synchronous path resolution
  final appDir = await getApplicationDocumentsDirectory();
  ImageService.appDocumentDirPath = appDir.path;

  runApp(const ProviderScope(child: RentKhataApp()));
}
