/// UPI QR Code widget for payment collection.
library;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

import '../../../core/utils/currency_formatter.dart';

/// Widget to display UPI QR code for rent collection.
class UpiQrWidget extends StatelessWidget {
  final String payeeName;
  final String? upiId;
  final double amount;
  final String? transactionNote;

  const UpiQrWidget({
    super.key,
    required this.payeeName,
    this.upiId,
    required this.amount,
    this.transactionNote,
  });

  /// Generate UPI payment URI
  String get _upiUri {
    if (upiId == null || upiId!.isEmpty) return '';

    final params = <String, String>{
      'pa': upiId!,
      'pn': payeeName,
      'am': amount.toStringAsFixed(2),
      'cu': 'INR',
    };

    if (transactionNote != null && transactionNote!.isNotEmpty) {
      params['tn'] = transactionNote!;
    }

    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return 'upi://pay?$query';
  }

  void _sharePaymentLink(BuildContext context) {
    if (_upiUri.isEmpty) return;

    final message =
        '''
Rent Payment Request

Amount: ${formatCurrency(amount)}
Payee: $payeeName
${transactionNote != null ? 'Note: $transactionNote\n' : ''}
Pay using UPI: $_upiUri
''';

    Share.share(message, subject: 'Rent Payment - $payeeName');
  }

  @override
  Widget build(BuildContext context) {
    if (upiId == null || upiId!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.errorContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.qr_code_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'UPI ID not configured',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your UPI ID in Settings to generate QR codes',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR Code
          QrImageView(
            data: _upiUri,
            version: QrVersions.auto,
            size: 200,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Theme.of(context).colorScheme.primary,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Amount
          Text(
            formatCurrency(amount),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),

          // UPI ID
          Text(
            upiId!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          if (transactionNote != null) ...[
            const SizedBox(height: 8),
            Text(
              transactionNote!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),

          // Share button
          TextButton.icon(
            onPressed: () => _sharePaymentLink(context),
            icon: const Icon(Icons.share_outlined),
            label: Text(AppLocalizations.of(context)!.sharePaymentLinkBtn),
          ),
        ],
      ),
    );
  }
}

/// Dialog to show UPI QR code.
class UpiQrDialog extends StatelessWidget {
  final String payeeName;
  final String? upiId;
  final double amount;
  final String? transactionNote;

  const UpiQrDialog({
    super.key,
    required this.payeeName,
    this.upiId,
    required this.amount,
    this.transactionNote,
  });

  static void show(
    BuildContext context, {
    required String payeeName,
    String? upiId,
    required double amount,
    String? transactionNote,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: UpiQrDialog(
          payeeName: payeeName,
          upiId: upiId,
          amount: amount,
          transactionNote: transactionNote,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collect Payment',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          UpiQrWidget(
            payeeName: payeeName,
            upiId: upiId,
            amount: amount,
            transactionNote: transactionNote,
          ),
        ],
      ),
    );
  }
}
