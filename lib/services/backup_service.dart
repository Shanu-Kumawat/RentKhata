/// Backup and restore service.
library;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import '../data/database/app_database.dart';
import '../core/constants/app_constants.dart';

/// Service for backing up and restoring database.
class BackupService {
  final AppDatabase _database;

  BackupService(this._database);

  /// Get backup directory path
  Future<String> get _backupDir async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${appDir.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  /// Get database file path
  Future<String> get _databasePath async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/${DbConstants.databaseName}';
  }

  /// Create a backup of the database
  Future<File> createBackup() async {
    final dbPath = await _databasePath;
    final backupDirPath = await _backupDir;

    // Generate backup filename with timestamp
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupFileName = 'rentkhata_backup_$timestamp.zip';
    final backupPath = '$backupDirPath/$backupFileName';

    // Do not close database during backup to prevent breaking active Riverpod providers.
    // SQLite allows copying the file safely while open in most cases.
    
    try {
      // Read database file
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw Exception('Database file not found');
      }

      final dbBytes = await dbFile.readAsBytes();

      final archive = Archive();
      archive.addFile(
        ArchiveFile(DbConstants.databaseName, dbBytes.length, dbBytes),
      );

      // Add images directory if it exists
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'images'));
      if (await imagesDir.exists()) {
        final List<FileSystemEntity> imageFiles = await imagesDir
            .list()
            .toList();
        for (var entity in imageFiles) {
          if (entity is File) {
            final fileBytes = await entity.readAsBytes();
            final fileName = p.basename(entity.path);
            archive.addFile(
              ArchiveFile('images/$fileName', fileBytes.length, fileBytes),
            );
          }
        }
      }

      // Write zip file
      final zipBytes = ZipEncoder().encode(archive);

      final backupFile = File(backupPath);
      await backupFile.writeAsBytes(zipBytes);

      return backupFile;
    } finally {
      // Note: Database will be reopened when needed via provider system
    }
  }

  /// Save backup externally
  Future<bool> saveBackupExternally({String dialogTitle = 'Save Backup'}) async {
    final backupFile = await createBackup();
    final fileName = p.basename(backupFile.path);
    final bytes = await backupFile.readAsBytes();

    final result = await FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['zip'],
      bytes: bytes,
    );

    if (result == null) {
      // User cancelled the save operation
      // Delete the generated local backup to avoid clutter
      await backupFile.delete();
      return false;
    }

    return true;
  }

  /// Restore database from backup file
  Future<void> restoreBackup(File backupFile) async {
    final dbPath = await _databasePath;

    // Read backup archive
    final bytes = await backupFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Find database file in archive
    final dbArchiveFile = archive.files.firstWhere(
      (file) => file.name == DbConstants.databaseName,
      orElse: () => throw Exception('Invalid backup file'),
    );

    // Close current database
    await _database.close();

    // Restore database
    final dbFile = File(dbPath);
    await dbFile.writeAsBytes(dbArchiveFile.content as List<int>);

    // Restore images
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    for (final file in archive.files) {
      if (file.name.startsWith('images/') && file.isFile) {
        final fileName = p.basename(file.name);
        final extractedFile = File(p.join(imagesDir.path, fileName));
        await extractedFile.writeAsBytes(file.content as List<int>);
      }
    }
  }

  /// Restore database from an external backup file (e.g. from File Picker)
  Future<void> restoreFromExternalFile(File externalZipFile) async {
    final dbPath = await _databasePath;

    // Read external backup archive
    final bytes = await externalZipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Find database file in archive
    final dbArchiveFile = archive.files.firstWhere(
      (file) => file.name == DbConstants.databaseName,
      orElse: () => throw Exception(
        'Invalid backup file: rent_khata.db not found inside.',
      ),
    );

    // Close current database
    await _database.close();

    // Restore database
    final dbFile = File(dbPath);
    await dbFile.writeAsBytes(dbArchiveFile.content as List<int>);

    // Restore images
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    for (final file in archive.files) {
      if (file.name.startsWith('images/') && file.isFile) {
        final fileName = p.basename(file.name);
        final extractedFile = File(p.join(imagesDir.path, fileName));
        await extractedFile.writeAsBytes(file.content as List<int>);
      }
    }
  }

  /// Get list of local backups
  Future<List<File>> getLocalBackups() async {
    final backupDirPath = await _backupDir;
    final backupDir = Directory(backupDirPath);

    if (!await backupDir.exists()) {
      return [];
    }

    final files = await backupDir.list().toList();
    return files
        .whereType<File>()
        .where((f) => f.path.endsWith('.zip'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path)); // Most recent first
  }

  /// Delete a backup file
  Future<void> deleteBackup(File backupFile) async {
    if (await backupFile.exists()) {
      await backupFile.delete();
    }
  }
}
