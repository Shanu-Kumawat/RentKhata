/// Service for picking and handling images.
library;

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Basic quality reduction
      );

      if (pickedFile == null) return null;

      // Compress and save to app directory
      return await _compressAndSaveImage(File(pickedFile.path));
    } catch (e) {
      // Handle permission errors or other issues
      return null;
    }
  }

  /// Compress image and save to app documents directory
  Future<File?> _compressAndSaveImage(File file) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'images'));
      
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = p.join(imagesDir.path, fileName);

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result != null) {
        return File(result.path);
      }
      return null; 
    } catch (e) {
      return null;
    }
  }

  /// Delete an image file
  Future<void> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignore errors
    }
  }
}
