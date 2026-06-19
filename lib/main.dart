/// Main entry point for RentKhata app.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'services/local_notification_service.dart';
import 'services/image_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await _runStartupStep(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  if (firebaseReady) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await _runStartupStep(() async {
    await LocalNotificationService().initialize();
  });

  // Cache document directory for synchronous path resolution
  await _runStartupStep(() async {
    final appDir = await getApplicationDocumentsDirectory();
    ImageService.appDocumentDirPath = appDir.path;
  });

  runApp(const ProviderScope(child: RentKhataApp()));
}

Future<bool> _runStartupStep(
  Future<void> Function() action,
) async {
  try {
    await action();
    return true;
  } catch (error, stackTrace) {
    debugPrint('Startup step failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}
