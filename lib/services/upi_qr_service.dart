/// UPI QR Service for generating dynamic payment QR codes.
library;

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Service for generating UPI QR codes and payment links.
class UpiQrService {
  /// Generate UPI deep link URL for payment.
  ///
  /// [upiId] - UPI VPA like "example@upi"
  /// [payeeName] - Name of the payee (landlord)
  /// [amount] - Payment amount in INR
  /// [transactionNote] - Note/reference for the transaction
  static String generateUpiLink({
    required String upiId,
    required String payeeName,
    double? amount,
    String? transactionNote,
  }) {
    // Build UPI URL according to NPCI spec
    final uri = Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': upiId, // Payee VPA
        'pn': payeeName, // Payee name
        if (amount != null && amount > 0) 'am': amount.toStringAsFixed(2),
        if (transactionNote != null && transactionNote.isNotEmpty)
          'tn': transactionNote, // Transaction note
        'cu': 'INR', // Currency
      },
    );

    return uri.toString();
  }

  /// Generate UPI QR code as a widget.
  ///
  /// Returns a widget that displays the QR code.
  static Widget generateQrWidget({
    required String upiId,
    required String payeeName,
    double? amount,
    String? transactionNote,
    double size = 200,
    Color backgroundColor = Colors.white,
    Color foregroundColor = Colors.black,
  }) {
    final upiLink = generateUpiLink(
      upiId: upiId,
      payeeName: payeeName,
      amount: amount,
      transactionNote: transactionNote,
    );

    return QrImageView(
      data: upiLink,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor,
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: foregroundColor),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor,
      ),
    );
  }

  /// Generate UPI QR code as image bytes.
  ///
  /// Useful for saving to file or sharing.
  static Future<Uint8List?> generateQrImageBytes({
    required String upiId,
    required String payeeName,
    double? amount,
    String? transactionNote,
    double size = 200,
  }) async {
    final upiLink = generateUpiLink(
      upiId: upiId,
      payeeName: payeeName,
      amount: amount,
      transactionNote: transactionNote,
    );

    final qrPainter = QrPainter(
      data: upiLink,
      version: QrVersions.auto,
      gapless: true,
      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF000000)),
      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color(0xFF000000)),
    );

    final imageSize = ui.Size(size, size);
    final image = await qrPainter.toImage(imageSize.width);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  /// Generate a formatted payment message with UPI link.
  static String generatePaymentMessage({
    required String upiId,
    required String payeeName,
    required double amount,
    required String billNumber,
    required String billType,
    required String period,
    required String tenantName,
  }) {
    final upiLink = generateUpiLink(
      upiId: upiId,
      payeeName: payeeName,
      amount: amount,
      transactionNote: '$billType - $period',
    );

    return '''
Dear $tenantName,

Your invoice is ready!

📋 Bill: $billType - $period
🔢 Invoice #: $billNumber
💰 Amount Due: ₹${amount.toStringAsFixed(0)}

Pay via UPI:
$upiLink

Or scan the QR code attached.

Thank you,
$payeeName
'''
        .trim();
  }
}
