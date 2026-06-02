import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper to navigate to system settings.
class AppSettingsHelper {
  static const _channel = MethodChannel('com.rentkhata.rent_khata/settings');

  /// Open app settings on the device.
  static Future<void> openSettings() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('openAppSettings');
      } catch (e) {
        // Fallback or ignore
      }
    } else if (Platform.isIOS) {
      final url = Uri.parse('app-settings:');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }
}
