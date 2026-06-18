import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

/// A utility to preview files in-app if they are images, 
/// or use the system's default handler for other file types.
class FilePreviewDialog {
  static void show(BuildContext context, String absolutePath) {
    final isImage = absolutePath.toLowerCase().endsWith('.jpg') ||
                    absolutePath.toLowerCase().endsWith('.jpeg') ||
                    absolutePath.toLowerCase().endsWith('.png');

    if (isImage) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.file(
                      File(absolutePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  style: IconButton.styleFrom(backgroundColor: Colors.black45),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Fallback for non-image files, relies on OS intents.
      OpenFile.open(absolutePath);
    }
  }
}
