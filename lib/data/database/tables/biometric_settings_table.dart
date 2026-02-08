/// Biometric settings table for app lock preferences.
library;

import 'package:drift/drift.dart';

/// Table storing user biometric/app lock preferences.
class BiometricSettings extends Table {
  /// Single row ID (always 1)
  IntColumn get id => integer().autoIncrement()();

  /// Master toggle for biometric lock
  BoolColumn get isEnabled => boolean().withDefault(const Constant(false))();

  /// Lock immediately when app goes to background
  BoolColumn get lockOnExit => boolean().withDefault(const Constant(true))();

  /// Lock after N minutes of inactivity (0 = immediate)
  IntColumn get lockAfterMinutes => integer().withDefault(const Constant(0))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
