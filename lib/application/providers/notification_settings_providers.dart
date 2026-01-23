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
  final int? quietHoursStart;
  final int? quietHoursEnd;
  final bool isLoading;

  const NotificationSettingsState({
    this.enabledSettings = const {},
    this.daysBeforeSettings = const {},
    this.notificationHour = 9,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.isLoading = true,
  });

  NotificationSettingsState copyWith({
    Map<NotificationType, bool>? enabledSettings,
    Map<NotificationType, int>? daysBeforeSettings,
    int? notificationHour,
    int? quietHoursStart,
    int? quietHoursEnd,
    bool? isLoading,
  }) {
    return NotificationSettingsState(
      enabledSettings: enabledSettings ?? this.enabledSettings,
      daysBeforeSettings: daysBeforeSettings ?? this.daysBeforeSettings,
      notificationHour: notificationHour ?? this.notificationHour,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool isEnabled(NotificationType type) => enabledSettings[type] ?? true;
  int getDaysBefore(NotificationType type) => daysBeforeSettings[type] ?? 3;
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
      int? quietStart;
      int? quietEnd;

      for (final setting in settings) {
        enabledMap[setting.notificationType] = setting.enabled;
        daysMap[setting.notificationType] = setting.daysBefore;
        hour ??= setting.notificationHour;
        quietStart ??= setting.quietHoursStart;
        quietEnd ??= setting.quietHoursEnd;
      }

      state = state.copyWith(
        enabledSettings: enabledMap,
        daysBeforeSettings: daysMap,
        notificationHour: hour ?? 9,
        quietHoursStart: quietStart,
        quietHoursEnd: quietEnd,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
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
      daysBefore: days,
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

  Future<void> setQuietHours(int? start, int? end) async {
    final db = _db;
    if (db == null) return;

    state = state.copyWith(quietHoursStart: start, quietHoursEnd: end);

    // Update all existing settings
    await db
        .update(db.notificationSettings)
        .write(
          NotificationSettingsCompanion(
            quietHoursStart: Value(start),
            quietHoursEnd: Value(end),
          ),
        );
  }

  Future<void> _upsertSetting(
    NotificationType type, {
    required bool enabled,
    required int daysBefore,
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
          notificationHour: Value(state.notificationHour),
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
              notificationHour: Value(state.notificationHour),
            ),
          );
    }
  }

  Future<void> saveAllSettings({
    required Map<NotificationType, bool> enabledSettings,
    required Map<NotificationType, int> daysBeforeSettings,
    required int notificationHour,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) async {
    final db = _db;
    if (db == null) return;

    state = state.copyWith(
      enabledSettings: enabledSettings,
      daysBeforeSettings: daysBeforeSettings,
      notificationHour: notificationHour,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
    );

    // Persist all settings
    for (final type in enabledSettings.keys) {
      await _upsertSetting(
        type,
        enabled: enabledSettings[type] ?? true,
        daysBefore: daysBeforeSettings[type] ?? 3,
      );
    }
  }
}
