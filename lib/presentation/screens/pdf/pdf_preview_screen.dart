library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

import 'package:file_picker/file_picker.dart';
import '../../widgets/share_bottom_sheet.dart';
import '../../../services/share_service.dart';

/// Unified in-app PDF preview with share and save actions.
class PdfPreviewScreen extends StatefulWidget {
  final File pdfFile;
  final String title;
  final String? shareSubject;
  final String? shareText;
  final String? suggestedFileName;
  final ShareContentType? shareContentType;
  final Future<void> Function()? onShareAsMessage;

  const PdfPreviewScreen({
    super.key,
    required this.pdfFile,
    required this.title,
    this.shareSubject,
    this.shareText,
    this.suggestedFileName,
    this.shareContentType,
    this.onShareAsMessage,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  late final Future<Uint8List> _bytesFuture;
  bool _isSharing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _bytesFuture = widget.pdfFile.readAsBytes();
  }

  Future<void> _sharePdfFile() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      final shareService = ShareService();
      await shareService.shareFiles(
        files: [widget.pdfFile],
        text: widget.shareText,
        subject: widget.shareSubject ?? widget.title,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.errorSharingPdf(e.toString()),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _withLoading(Future<void> Function() action) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await action();
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<void> _shareAsMessage() async {
    final onShareAsMessage = widget.onShareAsMessage;
    if (onShareAsMessage == null) return;
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      await onShareAsMessage();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.errorSharingMessage(e.toString()),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _handleShareTap() async {
    if (_isSharing) return;

    await _withLoading(() async {
      final shareType = widget.shareContentType;
      final messageShare = widget.onShareAsMessage;
      if (shareType != null && messageShare != null) {
        await ShareBottomSheet.show(
          context: context,
          contentType: shareType,
          onShareAsMessage: _shareAsMessage,
          onShareAsPdf: _sharePdfFile,
        );
        return;
      }

      await _sharePdfFile();
    });
  }

  String _normalizedPdfFileName(String rawName, String defaultPdfName) {
    final trimmed = rawName.trim();
    if (trimmed.isEmpty) return defaultPdfName;
    return trimmed.toLowerCase().endsWith('.pdf') ? trimmed : '$trimmed.pdf';
  }

  String _folderLabelFromName(String name, String fallbackDownloadsName) {
    final lowerName = name.toLowerCase();
    if (lowerName == 'download' || lowerName == 'downloads') {
      return fallbackDownloadsName;
    }
    if (name.trim().isEmpty) return fallbackDownloadsName;
    return name;
  }

  Future<void> _savePdf() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final l10n = AppLocalizations.of(context)!;
    final defaultName = _normalizedPdfFileName(
      widget.suggestedFileName ?? p.basename(widget.pdfFile.path),
      l10n.documentPdf,
    );

    await _withLoading(() async {
      try {
        final bytes = await widget.pdfFile.readAsBytes();
        
        // Let user choose directory & filename via native picker (SAF on Android, Files app on iOS)
        final outputPath = await FilePicker.platform.saveFile(
          dialogTitle: l10n.save,
          fileName: defaultName,
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          bytes: bytes,
        );

        if (outputPath != null) {
          // FilePicker writes the bytes to outputPath natively because we provided the `bytes` param.
          // outputPath might be a SAF URI string like `/document/primary:APKPure/Invoice.pdf`
          
          String folderName = l10n.downloadsFolder;
          String displayPath = outputPath;

          if (Platform.isAndroid && outputPath.contains('primary:')) {
            final split = outputPath.split('primary:');
            displayPath = split.last;
            
            final dirPath = p.dirname(displayPath);
            if (dirPath != '.') {
              folderName = _folderLabelFromName(p.basename(dirPath), l10n.downloadsFolder);
            } else {
              folderName = 'Storage';
            }
          } else {
            final targetFile = File(outputPath);
            folderName = _folderLabelFromName(p.basename(targetFile.parent.path), l10n.downloadsFolder);
            displayPath = _getDisplayPath(targetFile.path);
          }

          if (!mounted) return;
          _showSuccessToast(context, displayPath, folderName);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            content: Text('${l10n.couldNotSavePdf} - $e'),
          ),
        );
      }
    });

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<Uint8List>(
        future: _bytesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(AppLocalizations.of(context)!.unableToLoadPdfPreview),
            );
          }

          final bytes = snapshot.data!;

          return PdfPreview(
            build: (format) async => bytes,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            pdfFileName: widget.suggestedFileName,
            allowPrinting: false,
            allowSharing: false,
            useActions: false, // Disable default FAB to prevent Hero tag collisions
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSaving ? null : _savePdf,
                  icon: _isSaving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_outlined),
                  label: Text(l10n.save),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isSharing ? null : _handleShareTap,
                  icon: _isSharing
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(l10n.share),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _getDisplayPath(String path) {
    var display = path;
    const prefix = '/storage/emulated/0/';
    if (display.startsWith(prefix)) {
      display = display.substring(prefix.length);
    }
    
    // Strip Android/data/com.example/files/ prefix
    final appDataRegex = RegExp(r'^Android/data/[^/]+/files/');
    display = display.replaceFirst(appDataRegex, '');
    
    return display;
  }
}

void _showSuccessToast(
  BuildContext context,
  String displayPath,
  String folderName,
) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _AnimatedToast(
      displayPath: displayPath,
      folderName: folderName,
      onDismiss: () => overlayEntry.remove(),
    ),
  );

  overlay.insert(overlayEntry);
}

class _AnimatedToast extends StatefulWidget {
  final String displayPath;
  final String folderName;
  final VoidCallback onDismiss;

  const _AnimatedToast({
    required this.displayPath,
    required this.folderName,
    required this.onDismiss,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _showToast();
  }

  Future<void> _showToast() async {
    await _controller.forward();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      await _controller.reverse();
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.savedToFolder(widget.folderName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.displayPath,
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
