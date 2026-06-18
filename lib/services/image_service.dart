/// Service for picking and handling images.
library;

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Cached app documents directory path, initialized once at startup in main.dart.
  static late String appDocumentDirPath;

  /// Resolves a stored image filename (e.g. 'img_123.jpg') to its full
  /// absolute path on the current device. All callers must use this
  /// for any File I/O or display — never construct image paths manually.
  static String resolveImagePathSync(String? fileName) {
    if (fileName == null || fileName.isEmpty) return '';
    // p.basename is a safety net in case a full path is ever accidentally passed.
    return p.join(appDocumentDirPath, 'images', p.basename(fileName));
  }

  /// Picks an image, compresses it, saves it to the app's images directory,
  /// and returns the **relative filename** (e.g. 'img_1234.jpg') for DB storage.
  ///
  /// This is the canonical method to call when saving an image reference to
  /// the database. Use [resolveImagePathSync] to convert the filename back
  /// to an absolute path for display.
  Future<String?> pickAndSaveImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile == null) return null;
      return await _compressAndSave(File(pickedFile.path));
    } catch (e) {
      return null;
    }
  }

  /// Picks an image, compresses it, and returns a [File] pointing to the
  /// saved copy. Useful when you need the File object for in-session display
  /// before a DB save. The file's path can be passed to [resolveImagePathSync]
  /// or [p.basename] to get the storable filename.
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile == null) return null;
      final fileName = await _compressAndSave(File(pickedFile.path));
      if (fileName == null) return null;
      return File(resolveImagePathSync(fileName));
    } catch (e) {
      return null;
    }
  }

  /// Saves a raw file (like a PDF or pre-picked image) to the app's persistent
  /// storage directory so it is safely backed up. Returns the relative filename.
  Future<String?> saveFileToAppDirectory(File file, {bool isImage = true}) async {
    if (isImage) {
      return await _compressAndSave(file);
    } else {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory(p.join(appDir.path, 'images'));
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }
        final ext = p.extension(file.path);
        final fileName = 'doc_${DateTime.now().millisecondsSinceEpoch}$ext';
        final targetPath = p.join(imagesDir.path, fileName);
        
        final savedFile = await file.copy(targetPath);
        return p.basename(savedFile.path);
      } catch (e) {
        return null;
      }
    }
  }

  /// Compresses the image, saves it to the app's images directory,
  /// and returns only the relative filename for DB storage.
  Future<String?> _compressAndSave(File file) async {
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
        return p.basename(result.path); // Return ONLY the filename for DB
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Deletes an image by its stored filename (e.g. 'img_123.jpg').
  Future<void> deleteImage(String fileName) async {
    try {
      final file = File(resolveImagePathSync(fileName));
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignore errors
    }
  }
}
