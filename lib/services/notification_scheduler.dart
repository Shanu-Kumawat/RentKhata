/// Notification scheduler service that auto-schedules notifications on app startup.
///
/// This service runs on app initialization to ensure all notifications
/// are scheduled, even after device reboots or app reinstalls.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../application/providers/billing_providers.dart';
import '../application/providers/billing_cycle_providers.dart';
import '../application/providers/tenant_providers.dart';
import '../application/providers/notification_settings_providers.dart';
import '../data/database/tables/notification_setting_table.dart';
import 'local_notification_service.dart';

part 'notification_scheduler.g.dart';

/// Provider that schedules all notifications on app startup.
///
/// This should be watched in the app's root widget to ensure
/// notifications are always scheduled when the app starts.
@riverpod
Future<void> scheduleAllNotifications(Ref ref) async {
  final notificationService = LocalNotificationService();

  // Ensure notification service is initialized
  await notificationService.initialize();

  // Check if we have notification permission
  final hasPermission = await notificationService.requestPermission();
  if (!hasPermission) {
    return; // Can't schedule without permission
  }

  // Load notification settings from database
  final settings = ref.read(notificationSettingsNotifierProvider);

  // Wait for settings to load if still loading
  if (settings.isLoading) {
    // Settings are loading, we'll be triggered again when they're ready
    return;
  }

  // Cancel all existing notifications first to avoid duplicates
  await notificationService.cancelAll();

  // Schedule bill-related notifications
  final bills = await ref.read(unpaidBillsProvider.future);

  for (final bill in bills) {
    if (bill.dueDate == null) continue;

    // Schedule due soon reminder if enabled
    if (settings.isEnabled(NotificationType.billDueSoon)) {
      final daysBefore = settings.getDaysBefore(NotificationType.billDueSoon);
      await notificationService.scheduleDueBillReminder(
        bill: bill,
        daysBefore: daysBefore,
      );
    }

    // Schedule overdue escalation if any overdue type is enabled
    if (settings.isEnabled(NotificationType.overdue1Day) ||
        settings.isEnabled(NotificationType.overdue3Days) ||
        settings.isEnabled(NotificationType.overdue7Days) ||
        settings.isEnabled(NotificationType.overdue14Days)) {
      await notificationService.scheduleOverdueEscalation(bill: bill);
    }
  }

  // Schedule cycle ending reminders if enabled
  if (settings.isEnabled(NotificationType.cycleEndingSoon)) {
    final occupancies = await ref.read(activeOccupanciesProvider.future);
    final daysBefore = settings.getDaysBefore(NotificationType.cycleEndingSoon);

    final cycleData =
        <
          ({
            int occupancyId,
            String tenantName,
            String roomNumber,
            DateTime cycleEndDate,
          })
        >[];

    for (final occupancy in occupancies) {
      final cycle = ref.read(currentBillingCycleProvider(occupancy));
      cycleData.add((
        occupancyId: occupancy.id,
        tenantName: occupancy.tenantName ?? 'Tenant',
        roomNumber: occupancy.roomNumber ?? 'Room',
        cycleEndDate: cycle.end,
      ));
    }

    await notificationService.scheduleAllCycleReminders(
      occupancies: cycleData,
      daysBefore: daysBefore,
    );
  }
}

/// Provider that ensures notifications are scheduled on app startup.
///
/// This is a simple wrapper that triggers the scheduling once
/// and doesn't retry on failure.
@riverpod
class NotificationStartupScheduler extends _$NotificationStartupScheduler {
  bool _hasScheduled = false;

  @override
  Future<bool> build() async {
    if (_hasScheduled) return true;

    try {
      await ref.read(scheduleAllNotificationsProvider.future);
      _hasScheduled = true;
      return true;
    } catch (e) {
      // Log error but don't crash the app
      return false;
    }
  }

  /// Force reschedule all notifications (e.g., after settings change)
  Future<void> reschedule() async {
    _hasScheduled = false;
    ref.invalidateSelf();
  }
}
