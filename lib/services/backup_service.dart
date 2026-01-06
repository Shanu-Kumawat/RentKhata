/// Backup and restore service.
library;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:archive/archive.dart';
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
    return '${appDir.path}/${AppConstants.databaseName}';
  }

  /// Create a backup of the database
  Future<File> createBackup() async {
    final dbPath = await _databasePath;
    final backupDirPath = await _backupDir;
    
    // Generate backup filename with timestamp
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupFileName = 'rentkhata_backup_$timestamp.zip';
    final backupPath = '$backupDirPath/$backupFileName';
    
    // Close database before backup
    await _database.close();
    
    try {
      // Read database file
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw Exception('Database file not found');
      }
      
      final dbBytes = await dbFile.readAsBytes();
      
      // Create archive
      final archive = Archive();
      archive.addFile(ArchiveFile(
        AppConstants.databaseName,
        dbBytes.length,
        dbBytes,
      ));
      
      // Write zip file
      final zipBytes = ZipEncoder().encode(archive);
      if (zipBytes == null) {
        throw Exception('Failed to create backup archive');
      }
      
      final backupFile = File(backupPath);
      await backupFile.writeAsBytes(zipBytes);
      
      return backupFile;
    } finally {
      // Note: Database will be reopened when needed via provider system
    }
  }

  /// Share backup file
  Future<void> shareBackup() async {
    final backupFile = await createBackup();
    await Share.shareXFiles(
      [XFile(backupFile.path)],
      subject: 'RentKhata Backup',
      text: 'RentKhata database backup created on ${DateTime.now()}',
    );
  }

  /// Restore database from backup file
  Future<void> restoreBackup(File backupFile) async {
    final dbPath = await _databasePath;
    
    // Read backup archive
    final bytes = await backupFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    
    // Find database file in archive
    final dbArchiveFile = archive.files.firstWhere(
      (file) => file.name == AppConstants.databaseName,
      orElse: () => throw Exception('Invalid backup file'),
    );
    
    // Close current database
    await _database.close();
    
    // Restore database
    final dbFile = File(dbPath);
    await dbFile.writeAsBytes(dbArchiveFile.content as List<int>);
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
