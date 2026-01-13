/// Share service for WhatsApp and other sharing.
library;

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

/// Service for sharing content via WhatsApp and other apps.
class ShareService {
  /// Share text message to WhatsApp.
  /// If [phoneNumber] is provided, opens chat with that number.
  /// Otherwise opens WhatsApp to let user select a contact.
  Future<bool> shareToWhatsApp({
    required String message,
    String? phoneNumber,
  }) async {
    // Format phone number (remove spaces, ensure country code)
    String? formattedPhone;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      formattedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      // Add India country code if not present
      if (!formattedPhone.startsWith('+')) {
        if (formattedPhone.startsWith('0')) {
          formattedPhone = '+91${formattedPhone.substring(1)}';
        } else if (formattedPhone.length == 10) {
          formattedPhone = '+91$formattedPhone';
        }
      }
    }

    // Encode message for URL
    final encodedMessage = Uri.encodeComponent(message);

    // Build WhatsApp URL
    Uri uri;
    if (formattedPhone != null) {
      uri = Uri.parse(
        'whatsapp://send?phone=$formattedPhone&text=$encodedMessage',
      );
    } else {
      uri = Uri.parse('whatsapp://send?text=$encodedMessage');
    }

    // Try to launch WhatsApp
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Share files with optional text.
  Future<void> shareFiles({
    required List<File> files,
    String? text,
    String? subject,
  }) async {
    final xFiles = files.map((f) => XFile(f.path)).toList();
    await Share.shareXFiles(xFiles, text: text, subject: subject);
  }

  /// Share text only.
  Future<void> shareText({required String text, String? subject}) async {
    await Share.share(text, subject: subject);
  }

  /// Generate bill reminder message.
  static String billReminderMessage({
    required String tenantName,
    required String billType,
    required String period,
    required double amount,
    required DateTime dueDate,
    required String landlordName,
  }) {
    final dueDateStr = '${dueDate.day}/${dueDate.month}/${dueDate.year}';
    return '''
Dear $tenantName,

This is a reminder for your $billType bill for $period.

Amount Due: ₹${amount.toStringAsFixed(0)}
Due Date: $dueDateStr

Please make the payment at your earliest convenience.

Thank you,
$landlordName
'''
        .trim();
  }

  /// Generate payment receipt message.
  static String paymentReceiptMessage({
    required String tenantName,
    required String billType,
    required String period,
    required double amount,
    required String paymentMode,
    required DateTime paymentDate,
    required String landlordName,
  }) {
    final dateStr =
        '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}';
    return '''
Dear $tenantName,

Payment Received!

Bill: $billType - $period
Amount: ₹${amount.toStringAsFixed(0)}
Mode: $paymentMode
Date: $dateStr

Thank you for your payment.

$landlordName
'''
        .trim();
  }
}
