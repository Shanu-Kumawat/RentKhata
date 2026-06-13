/// Notification settings providers for managing notification preferences.
library;

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';
import '../../data/database/tables/notification_setting_table.dart';
import 'database_provider.dart';

part 'notification_settings_providers.g.dart';

/// Model class representing all notification settings for the UI
class NotificationSettingsState {
  final Map<NotificationType, bool> enabledSettings;
  final Map<NotificationType, int> daysBeforeSettings;
  final int notificationHour;
  final bool isLoading;

  const NotificationSettingsState({
    this.enabledSettings = const {},
    this.daysBeforeSettings = const {},
    this.notificationHour = 9,
    this.isLoading = true,
  });

  NotificationSettingsState copyWith({
    Map<NotificationType, bool>? enabledSettings,
    Map<NotificationType, int>? daysBeforeSettings,
    int? notificationHour,
    bool? isLoading,
  }) {
    return NotificationSettingsState(
      enabledSettings: enabledSettings ?? this.enabledSettings,
      daysBeforeSettings: daysBeforeSettings ?? this.daysBeforeSettings,
      notificationHour: notificationHour ?? this.notificationHour,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  static const Map<NotificationType, bool> _defaultEnabled = {
    NotificationType.cycleEndingSoon: true,
    NotificationType.billDueSoon: true,
    NotificationType.overdue1Day: true,
    NotificationType.overdue3Days: false,
    NotificationType.overdue7Days: true,
    NotificationType.overdue14Days: false,
    NotificationType.agreementExpiringSoon: true,
    NotificationType.agreementExpired: false,
    NotificationType.billNotGenerated: true,
    NotificationType.partialPaymentPause: true,
    NotificationType.depositSettlementDue: true,
    NotificationType.utilityUsageAnomaly: false,
  };

  static const Map<NotificationType, int> _defaultDaysBefore = {
    NotificationType.cycleEndingSoon: 3,
    NotificationType.billDueSoon: 3,
    NotificationType.agreementExpiringSoon: 30,
    NotificationType.agreementExpired: 0,
    NotificationType.billNotGenerated: 3,
    NotificationType.depositSettlementDue: 3,
  };

  bool isEnabled(NotificationType type) => enabledSettings[type] ?? _defaultEnabled[type] ?? true;
  int getDaysBefore(NotificationType type) => daysBeforeSettings[type] ?? _defaultDaysBefore[type] ?? 3;
}

/// Provider for managing notification settings
@riverpod
class NotificationSettingsNotifier extends _$NotificationSettingsNotifier {
  AppDatabase? _db;

  @override
  NotificationSettingsState build() {
    _db = ref.watch(appDatabaseProvider);
    _loadSettings();
    return const NotificationSettingsState();
  }

  Future<void> _loadSettings() async {
    final db = _db;
    if (db == null) return;

    try {
      final settings = await db.select(db.notificationSettings).get();

      final enabledMap = <NotificationType, bool>{};
      final daysMap = <NotificationType, int>{};
      int? hour;

      for (final setting in settings) {
        enabledMap[setting.notificationType] = setting.enabled;
        daysMap[setting.notificationType] = setting.daysBefore;
        hour ??= setting.notificationHour;
      }

      state = state.copyWith(
        enabledSettings: enabledMap,
        daysBeforeSettings: daysMap,
        notificationHour: hour ?? 9,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  int _normalizeDaysForType(NotificationType type, int days) {
    switch (type) {
      case NotificationType.agreementExpiringSoon:
        return days.clamp(7, 60);
      case NotificationType.agreementExpired:
        return days.clamp(0, 30);
      case NotificationType.billNotGenerated:
        return days.clamp(0, 14);
      case NotificationType.depositSettlementDue:
        return days.clamp(1, 30);
      default:
        return days;
    }
  }

  Future<void> setEnabled(NotificationType type, bool enabled) async {
    final db = _db;
    if (db == null) return;

    // Update local state optimistically
    final newEnabled = Map<NotificationType, bool>.from(state.enabledSettings);
    newEnabled[type] = enabled;
    state = state.copyWith(enabledSettings: newEnabled);

    // Persist to database
    await _upsertSetting(
      type,
      enabled: enabled,
      daysBefore: state.getDaysBefore(type),
    );
  }

  Future<void> setDaysBefore(NotificationType type, int days) async {
    final db = _db;
    if (db == null) return;

    // Update local state optimistically
    final newDays = Map<NotificationType, int>.from(state.daysBeforeSettings);
    newDays[type] = days;
    state = state.copyWith(daysBeforeSettings: newDays);

    // Persist to database
    await _upsertSetting(
      type,
      enabled: state.isEnabled(type),
      daysBefore: _normalizeDaysForType(type, days),
    );
  }

  Future<void> setNotificationHour(int hour) async {
    final db = _db;
    if (db == null) return;

    state = state.copyWith(notificationHour: hour);

    // Update all existing settings
    await db
        .update(db.notificationSettings)
        .write(NotificationSettingsCompanion(notificationHour: Value(hour)));
  }

  Future<void> _upsertSetting(
    NotificationType type, {
    required bool enabled,
    required int daysBefore,
  }) async {
    await _upsertSettingWithHour(
      type,
      enabled: enabled,
      daysBefore: daysBefore,
      notificationHour: state.notificationHour,
    );
  }

  Future<void> _upsertSettingWithHour(
    NotificationType type, {
    required bool enabled,
    required int daysBefore,
    required int notificationHour,
  }) async {
    final db = _db;
    if (db == null) return;

    final existing = await (db.select(
      db.notificationSettings,
    )..where((t) => t.notificationType.equalsValue(type))).getSingleOrNull();

    if (existing != null) {
      await (db.update(
        db.notificationSettings,
      )..where((t) => t.id.equals(existing.id))).write(
        NotificationSettingsCompanion(
          enabled: Value(enabled),
          daysBefore: Value(daysBefore),
          notificationHour: Value(notificationHour),
        ),
      );
    } else {
      await db
          .into(db.notificationSettings)
          .insert(
            NotificationSettingsCompanion.insert(
              notificationType: type,
              enabled: Value(enabled),
              daysBefore: Value(daysBefore),
              notificationHour: Value(notificationHour),
            ),
          );
    }
  }

  Future<void> saveAllSettings({
    required Map<NotificationType, bool> enabledSettings,
    required Map<NotificationType, int> daysBeforeSettings,
    required int notificationHour,
  }) async {
    final db = _db;
    if (db == null) return;

    state = state.copyWith(
      enabledSettings: enabledSettings,
      daysBeforeSettings: daysBeforeSettings,
      notificationHour: notificationHour,
    );

    // Persist all settings
    for (final type in NotificationType.values) {
      await _upsertSetting(
        type,
        enabled: enabledSettings[type] ?? NotificationSettingsState._defaultEnabled[type] ?? true,
        daysBefore: _normalizeDaysForType(type, daysBeforeSettings[type] ?? NotificationSettingsState._defaultDaysBefore[type] ?? 3),
      );
    }
  }
}
