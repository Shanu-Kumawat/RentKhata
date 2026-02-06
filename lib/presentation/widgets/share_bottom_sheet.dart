/// Share bottom sheet widget for consistent share UX.
library;

import 'package:flutter/material.dart';

/// Type of content being shared.
enum ShareContentType { invoice, receipt }

/// Bottom sheet with share options: Message (recommended) and PDF.
class ShareBottomSheet extends StatelessWidget {
  final ShareContentType contentType;
  final VoidCallback onShareAsMessage;
  final VoidCallback onShareAsPdf;

  const ShareBottomSheet({
    super.key,
    required this.contentType,
    required this.onShareAsMessage,
    required this.onShareAsPdf,
  });

  /// Show the share bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required ShareContentType contentType,
    required VoidCallback onShareAsMessage,
    required VoidCallback onShareAsPdf,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShareBottomSheet(
        contentType: contentType,
        onShareAsMessage: () {
          Navigator.pop(context);
          onShareAsMessage();
        },
        onShareAsPdf: () {
          Navigator.pop(context);
          onShareAsPdf();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentLabel = contentType == ShareContentType.invoice
        ? 'Invoice'
        : 'Receipt';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share $contentLabel',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Choose how you want to share',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Send as Message (Recommended)
            _ShareOption(
              icon: Icons.message_outlined,
              title: 'Send as Message',
              subtitle: 'Quick text with details',
              isRecommended: true,
              onTap: onShareAsMessage,
            ),
            const SizedBox(height: 12),

            // Share PDF
            _ShareOption(
              icon: Icons.picture_as_pdf_outlined,
              title: 'Share PDF',
              subtitle: 'Formal document',
              isRecommended: false,
              onTap: onShareAsPdf,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isRecommended;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isRecommended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: isRecommended
          ? theme.colorScheme.primary.withValues(alpha: 0.05)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
