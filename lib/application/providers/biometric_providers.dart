/// Biometric authentication providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' show Value;
import '../../services/biometric_service.dart';
import '../providers/database_provider.dart';
import '../../data/database/app_database.dart';

part 'biometric_providers.g.dart';

/// Provider for biometric service instance.
@riverpod
BiometricService biometricService(Ref ref) {
  return BiometricService();
}

/// Provider to check device biometric support.
@riverpod
Future<BiometricSupport> biometricSupport(Ref ref) async {
  final service = ref.watch(biometricServiceProvider);
  return service.checkBiometricSupport();
}

/// Provider for biometric settings from database.
@riverpod
Stream<BiometricSetting?> biometricSettings(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.biometricSettings).watchSingleOrNull();
}

/// Notifier for managing app lock state.
@riverpod
class AppLockState extends _$AppLockState {
  @override
  bool build() {
    // Start locked if biometric is enabled
    // This will be checked on app startup
    return false;
  }

  /// Lock the app
  void lock() {
    state = true;
  }

  /// Unlock the app
  void unlock() {
    state = false;
  }
}

/// Notifier for managing biometric settings.
@riverpod
class BiometricSettingsNotifier extends _$BiometricSettingsNotifier {
  @override
  Future<BiometricSetting?> build() async {
    final db = ref.watch(appDatabaseProvider);
    return db.select(db.biometricSettings).getSingleOrNull();
  }

  /// Enable or disable biometric lock.
  Future<void> setEnabled(bool enabled) async {
    final db = ref.read(appDatabaseProvider);
    await db
        .update(db.biometricSettings)
        .write(
          BiometricSettingsCompanion(
            isEnabled: Value(enabled),
            updatedAt: Value(DateTime.now()),
          ),
        );
    ref.invalidateSelf();
  }

  /// Set lock on exit preference.
  Future<void> setLockOnExit(bool lockOnExit) async {
    final db = ref.read(appDatabaseProvider);
    await db
        .update(db.biometricSettings)
        .write(
          BiometricSettingsCompanion(
            lockOnExit: Value(lockOnExit),
            updatedAt: Value(DateTime.now()),
          ),
        );
    ref.invalidateSelf();
  }

  /// Set lock after inactivity timeout.
  Future<void> setLockAfterMinutes(int minutes) async {
    final db = ref.read(appDatabaseProvider);
    await db
        .update(db.biometricSettings)
        .write(
          BiometricSettingsCompanion(
            lockAfterMinutes: Value(minutes),
            updatedAt: Value(DateTime.now()),
          ),
        );
    ref.invalidateSelf();
  }
}
