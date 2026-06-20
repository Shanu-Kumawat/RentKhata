/// Notification scheduler service that auto-schedules notifications on app startup.
///
/// This service runs on app initialization to ensure all notifications
/// are scheduled, even after device reboots or app reinstalls.
library;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../application/providers/billing_providers.dart';
import '../application/providers/billing_cycle_providers.dart';
import '../application/providers/database_provider.dart';
import '../application/providers/repository_providers.dart';
import '../application/providers/tenant_providers.dart';
import '../application/providers/notification_settings_providers.dart';
import '../data/database/tables/notification_setting_table.dart';
import '../domain/entities/bill.dart';
import '../domain/entities/billing_status.dart';
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

  // Check if we have notification permission without requesting
  final hasPermission = await notificationService.checkPermission();
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

  final enabledOverdueDays = <int>{
    if (settings.isEnabled(NotificationType.overdue1Day)) 1,
    if (settings.isEnabled(NotificationType.overdue3Days)) 3,
    if (settings.isEnabled(NotificationType.overdue7Days)) 7,
    if (settings.isEnabled(NotificationType.overdue14Days)) 14,
  };

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
        notificationHour: settings.notificationHour,
      );
    }

    // Schedule overdue escalation if any overdue type is enabled
    if (enabledOverdueDays.isNotEmpty) {
      await notificationService.scheduleOverdueEscalation(
        bill: bill,
        escalationDays: enabledOverdueDays,
        notificationHour: settings.notificationHour,
        pauseOnPartialPayment: settings.isEnabled(
          NotificationType.partialPaymentPause,
        ),
        partialPaymentThresholdRatio: 0.5,
      );
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
      notificationHour: settings.notificationHour,
    );
  }

  if (settings.isEnabled(NotificationType.agreementExpiringSoon)) {
    final occupancies = await ref.read(activeOccupanciesProvider.future);
    final daysBefore = settings.getDaysBefore(
      NotificationType.agreementExpiringSoon,
    );

    final agreementData =
        <
          ({
            int occupancyId,
            String tenantName,
            String roomNumber,
            DateTime agreementEndDate,
          })
        >[];

    for (final occupancy in occupancies) {
      final endDate = occupancy.agreementEndDate;
      if (endDate == null) continue;

      agreementData.add((
        occupancyId: occupancy.id,
        tenantName: occupancy.tenantName ?? 'Tenant',
        roomNumber: occupancy.roomNumber ?? 'Room',
        agreementEndDate: endDate,
      ));
    }

    await notificationService.scheduleAllAgreementExpiryReminders(
      occupancies: agreementData,
      daysBefore: daysBefore,
      notificationHour: settings.notificationHour,
    );
  }

  if (settings.isEnabled(NotificationType.agreementExpired)) {
    final graceDays = settings.getDaysBefore(NotificationType.agreementExpired);
    final occupancies = await ref.read(activeOccupanciesProvider.future);

    for (final occupancy in occupancies) {
      final endDate = occupancy.agreementEndDate;
      if (endDate == null) continue;

      await notificationService.scheduleAgreementExpiredReminder(
        occupancyId: occupancy.id,
        tenantName: occupancy.tenantName ?? 'Tenant',
        roomNumber: occupancy.roomNumber ?? 'Room',
        agreementEndDate: endDate,
        graceDays: graceDays.clamp(0, 30),
        notificationHour: settings.notificationHour,
      );
    }
  }

  // Bill generation reminders for due-soon/overdue cycles.
  if (settings.isEnabled(NotificationType.billNotGenerated)) {
    final leadDays = settings
        .getDaysBefore(NotificationType.billNotGenerated)
        .clamp(0, 14);
    final attentionItems = await ref.read(billingAttentionListProvider.future);
    final scheduledKeys = <String>{};

    for (final item in attentionItems) {
      final shouldAlert =
          item.status == BillingCycleStatus.overdue ||
          item.daysUntilDueDate <= leadDays;
      if (!shouldAlert) continue;

      // Avoid duplicate alerts for multiple missed cycles of same type.
      final key = '${item.occupancyId}-${item.billType.index}';
      if (!scheduledKeys.add(key)) continue;

      await notificationService.scheduleBillGenerationReminder(
        occupancyId: item.occupancyId,
        billType: item.billType,
        tenantName: item.tenantName,
        roomNumber: item.roomNumber,
        cycleEndDate: item.cycleEnd,
        daysUntilDueDate: item.daysUntilDueDate,
        notificationHour: settings.notificationHour,
      );
    }
  }

  if (settings.isEnabled(NotificationType.depositSettlementDue)) {
    final daysAfterMoveOut = settings
        .getDaysBefore(NotificationType.depositSettlementDue)
        .clamp(1, 30);
    final db = ref.read(appDatabaseProvider);
    final unsettled =
        await (db.select(db.occupancies)..where(
              (o) =>
                  o.isActive.equals(false) &
                  o.moveOutDate.isNotNull() &
                  o.isSettled.equals(false),
            ))
            .get();

    for (final occupancy in unsettled) {
      if (occupancy.securityDeposit <= 0) continue;
      if (occupancy.moveOutDate == null) continue;

      final tenant = await db.tenantDao.getTenantById(occupancy.tenantId);
      final room = await db.propertyDao.getRoomById(occupancy.roomId);

      await notificationService.scheduleDepositSettlementDueReminder(
        occupancyId: occupancy.id,
        tenantName: tenant?.name ?? 'Tenant',
        roomNumber: room?.roomNumber ?? 'Room',
        moveOutDate: occupancy.moveOutDate!,
        daysAfterMoveOut: daysAfterMoveOut,
        notificationHour: settings.notificationHour,
      );
    }
  }

  if (settings.isEnabled(NotificationType.utilityUsageAnomaly)) {
    final occupancies = await ref.read(activeOccupanciesProvider.future);
    final billingRepo = ref.read(billingRepositoryProvider);

    for (final occupancy in occupancies) {
      final bills = await billingRepo.getBillsForOccupancy(occupancy.id);
      final electricityBills = bills
          .where(
            (b) =>
                b.billType == BillType.electricity &&
                b.electricityPrevReading != null &&
                b.electricityCurrReading != null &&
                b.electricityCurrReading! >= b.electricityPrevReading!,
          )
          .toList();

      if (electricityBills.length < 2) continue;

      electricityBills.sort((a, b) {
        final aDate = a.periodEndDate ?? a.createdAt;
        final bDate = b.periodEndDate ?? b.createdAt;
        return aDate.compareTo(bDate);
      });

      final latest = electricityBills[electricityBills.length - 1];
      final previous = electricityBills[electricityBills.length - 2];

      final latestUnits =
          (latest.electricityCurrReading! - latest.electricityPrevReading!)
              .round();
      final previousUnits =
          (previous.electricityCurrReading! - previous.electricityPrevReading!)
              .round();

      if (latestUnits <= 0 || previousUnits <= 0) continue;

      final increasePercent =
          ((latestUnits - previousUnits) / previousUnits) * 100;
      final hasSpike =
          increasePercent >= 50 && (latestUnits - previousUnits) >= 25;
      if (!hasSpike) continue;

      await notificationService.scheduleUtilityUsageAnomalyReminder(
        occupancyId: occupancy.id,
        tenantName: occupancy.tenantName ?? 'Tenant',
        roomNumber: occupancy.roomNumber ?? 'Room',
        currentUnits: latestUnits,
        previousUnits: previousUnits,
        increasePercent: increasePercent,
        notificationHour: settings.notificationHour,
      );
    }
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

    // Wait for settings to load before attempting to schedule
    final settings = ref.watch(notificationSettingsNotifierProvider);
    if (settings.isLoading) {
      return false; // Still loading, will re-trigger when loaded
    }

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
