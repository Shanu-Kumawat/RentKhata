/// Local notification service for Android.
/// Handles initialization, scheduling, and management of due/overdue bill reminders.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import '../domain/entities/bill.dart';

/// Service for managing local notifications.
class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const int _dueReminderBaseId = 1000000;
  static const int _overdueReminderBaseId = 2000000;
  static const int _cycleReminderBaseId = 3000000;
  static const int _agreementReminderBaseId = 4000000;
  static const int _agreementExpiredReminderBaseId = 5000000;
  static const int _billGenerationReminderBaseId = 6000000;
  static const int _depositSettlementReminderBaseId = 7000000;
  static const int _utilityAnomalyReminderBaseId = 8000000;

  int _dueReminderId(int billId) => _dueReminderBaseId + billId;
  int _overdueReminderId(int billId, int daysOverdue) =>
      _overdueReminderBaseId + (billId * 20) + daysOverdue;
  int _cycleReminderId(int occupancyId) => _cycleReminderBaseId + occupancyId;
  int _agreementReminderId(int occupancyId) =>
      _agreementReminderBaseId + occupancyId;
  int _agreementExpiredReminderId(int occupancyId) =>
      _agreementExpiredReminderBaseId + occupancyId;
  int _billGenerationReminderId(int occupancyId, BillType billType) =>
      _billGenerationReminderBaseId + (occupancyId * 10) + billType.index;
  int _depositSettlementReminderId(int occupancyId) =>
      _depositSettlementReminderBaseId + occupancyId;
  int _utilityAnomalyReminderId(int occupancyId) =>
      _utilityAnomalyReminderBaseId + occupancyId;

  DateTime _atHour(DateTime date, int hour) {
    final safeHour = hour.clamp(0, 23);
    return DateTime(date.year, date.month, date.day, safeHour, 0);
  }

  DateTime _nextAtHour(int hour) {
    final now = DateTime.now();
    final candidate = _atHour(now, hour);
    if (candidate.isAfter(now)) return candidate;
    return candidate.add(const Duration(days: 1));
  }

  /// Android notification channel for bill reminders
  static const AndroidNotificationChannel _billChannel =
      AndroidNotificationChannel(
        'bill_reminders',
        'Bill Reminders',
        description: 'Notifications for due and overdue bills',
        importance: Importance.high,
      );

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );

    // Initialize plugin
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_billChannel);

    _isInitialized = true;
    debugPrint('LocalNotificationService initialized (Permissions deferred)');
  }

  /// Request notification permissions explicitly when needed
  Future<bool> requestExactPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
      return granted ?? false;
    }
    return true;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Could navigate to reports screen or specific bill
  }

  /// Request notification permissions (Android 13+)
  Future<bool> requestPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  /// Check if notification permissions are granted without requesting them
  Future<bool> checkPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final granted = await androidPlugin.areNotificationsEnabled();
      return granted ?? false;
    }
    return true;
  }

  /// Get all currently scheduled notifications (useful for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  /// Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'bill_reminders',
      'Bill Reminders',
      channelDescription: 'Notifications for due and overdue bills',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      color: Color(0xFF3580FF),
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(id, title, body, details, payload: payload);
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    bool repeatDaily = false,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'bill_reminders',
      'Bill Reminders',
      channelDescription: 'Notifications for due and overdue bills',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      color: Color(0xFF3580FF),
    );

    const details = NotificationDetails(android: androidDetails);

    final enrichedPayload = payload != null
        ? '$payload|debug_time:${scheduledTime.toIso8601String()}'
        : 'debug_time:${scheduledTime.toIso8601String()}';

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
      payload: enrichedPayload,
    );
  }

  /// Schedule due bill reminder (X days before due date)
  Future<void> scheduleDueBillReminder({
    required Bill bill,
    required int daysBefore,
    int notificationHour = 9,
  }) async {
    if (bill.dueDate == null || bill.isFullyPaid) return;

    final reminderDate = bill.dueDate!.subtract(Duration(days: daysBefore));

    // Don't schedule if reminder date is in the past
    if (reminderDate.isBefore(DateTime.now())) return;

    final scheduledTime = _atHour(reminderDate, notificationHour);

    await scheduleNotification(
      id: _dueReminderId(bill.id),
      title: 'Bill Due Soon - ${bill.tenantName ?? 'Tenant'}',
      body:
          '₹${bill.pendingAmount.toStringAsFixed(0)} due in $daysBefore days for ${bill.billingPeriod}',
      scheduledTime: scheduledTime,
      payload: 'bill:${bill.id}',
    );

    debugPrint('Scheduled due reminder for bill ${bill.id} at $scheduledTime');
  }

  /// Schedule overdue reminder (1 day after due date)
  Future<void> scheduleOverdueReminder({required Bill bill}) async {
    if (bill.dueDate == null || bill.isFullyPaid) return;

    final overdueDate = bill.dueDate!.add(const Duration(days: 1));

    // Don't schedule if overdue date is in the past
    if (overdueDate.isBefore(DateTime.now())) return;

    final scheduledTime = _atHour(overdueDate, 10);

    await scheduleNotification(
      id: _overdueReminderId(bill.id, 1),
      title: '⚠️ Bill Overdue - ${bill.tenantName ?? 'Tenant'}',
      body:
          '₹${bill.pendingAmount.toStringAsFixed(0)} is overdue for ${bill.billingPeriod}. Please collect payment.',
      scheduledTime: scheduledTime,
      payload: 'bill:${bill.id}',
    );

    debugPrint(
      'Scheduled overdue reminder for bill ${bill.id} at $scheduledTime',
    );
  }

  /// Cancel notification for a specific bill
  Future<void> cancelBillNotifications(int billId) async {
    await _plugin.cancel(_dueReminderId(billId));
    await _plugin.cancel(_overdueReminderId(billId, 1));
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Check and show immediate notifications for any overdue bills
  Future<void> checkAndNotifyOverdue(List<Bill> bills) async {
    if (!_isInitialized) await initialize();

    final overdueBills = bills
        .where((b) => b.isOverdue && !b.isFullyPaid)
        .toList();

    if (overdueBills.isEmpty) return;

    final totalOverdue = overdueBills.fold<double>(
      0,
      (sum, b) => sum + b.pendingAmount,
    );

    await showNotification(
      id: 999, // Fixed ID for summary
      title: '⚠️ ${overdueBills.length} Overdue Bill(s)',
      body: '₹${totalOverdue.toStringAsFixed(0)} total pending. Tap to view.',
      payload: 'overdue',
    );
  }

  // ========== Billing Cycle Reminders ==========

  /// Schedule reminder for billing cycle ending soon.
  ///
  /// Schedules a notification [daysBefore] days before the cycle ends
  /// to remind the landlord to create a bill.
  Future<void> scheduleCycleEndReminder({
    required int occupancyId,
    required String tenantName,
    required String roomNumber,
    required DateTime cycleEndDate,
    int daysBefore = 3,
    int notificationHour = 9,
  }) async {
    if (!_isInitialized) await initialize();

    final reminderDate = cycleEndDate.subtract(Duration(days: daysBefore));

    // Don't schedule if reminder date is in the past
    if (reminderDate.isBefore(DateTime.now())) return;

    final scheduledTime = _atHour(reminderDate, notificationHour);

    // Format date nicely
    final shortMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final endDateStr =
        '${shortMonths[cycleEndDate.month - 1]} ${cycleEndDate.day}';

    await scheduleNotification(
      id: _cycleReminderId(occupancyId),
      title: '📅 Billing Cycle Ending - Room $roomNumber',
      body:
          '$tenantName\'s billing cycle ends on $endDateStr. Create their bill now.',
      scheduledTime: scheduledTime,
      payload: 'cycle:$occupancyId',
    );

    debugPrint(
      'Scheduled cycle end reminder for occupancy $occupancyId at $scheduledTime',
    );
  }

  /// Cancel cycle end reminder for an occupancy
  Future<void> cancelCycleReminder(int occupancyId) async {
    await _plugin.cancel(_cycleReminderId(occupancyId));
  }

  /// Schedule reminders for all occupancies with cycles ending soon
  Future<void> scheduleAllCycleReminders({
    required List<
      ({
        int occupancyId,
        String tenantName,
        String roomNumber,
        DateTime cycleEndDate,
      })
    >
    occupancies,
    int daysBefore = 3,
    int notificationHour = 9,
  }) async {
    for (final occ in occupancies) {
      await scheduleCycleEndReminder(
        occupancyId: occ.occupancyId,
        tenantName: occ.tenantName,
        roomNumber: occ.roomNumber,
        cycleEndDate: occ.cycleEndDate,
        daysBefore: daysBefore,
        notificationHour: notificationHour,
      );
    }
  }

  /// Schedule reminder for agreement expiring soon.
  Future<void> scheduleAgreementExpiryReminder({
    required int occupancyId,
    required String tenantName,
    required String roomNumber,
    required DateTime agreementEndDate,
    int daysBefore = 30,
    int notificationHour = 9,
  }) async {
    if (!_isInitialized) await initialize();

    final reminderDate = agreementEndDate.subtract(Duration(days: daysBefore));
    if (reminderDate.isBefore(DateTime.now())) return;

    final scheduledTime = _atHour(reminderDate, notificationHour);
    final shortMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final endDateStr =
        '${shortMonths[agreementEndDate.month - 1]} ${agreementEndDate.day}';

    await scheduleNotification(
      id: _agreementReminderId(occupancyId),
      title: '📝 Agreement Expiring - Room $roomNumber',
      body: '$tenantName\'s agreement ends on $endDateStr. Plan renewal.',
      scheduledTime: scheduledTime,
      payload: 'agreement:$occupancyId',
    );
  }

  /// Schedule agreement expiry reminders for all active occupancies.
  Future<void> scheduleAllAgreementExpiryReminders({
    required List<
      ({
        int occupancyId,
        String tenantName,
        String roomNumber,
        DateTime agreementEndDate,
      })
    >
    occupancies,
    int daysBefore = 30,
    int notificationHour = 9,
  }) async {
    for (final occ in occupancies) {
      await scheduleAgreementExpiryReminder(
        occupancyId: occ.occupancyId,
        tenantName: occ.tenantName,
        roomNumber: occ.roomNumber,
        agreementEndDate: occ.agreementEndDate,
        daysBefore: daysBefore,
        notificationHour: notificationHour,
      );
    }
  }

  /// Schedule reminder for agreements that are already expired.
  Future<void> scheduleAgreementExpiredReminder({
    required int occupancyId,
    required String tenantName,
    required String roomNumber,
    required DateTime agreementEndDate,
    int graceDays = 0,
    int notificationHour = 9,
  }) async {
    if (!_isInitialized) await initialize();

    final alertDate = agreementEndDate.add(Duration(days: graceDays));
    final now = DateTime.now();
    
    final scheduledTime = now.isBefore(alertDate) 
        ? _atHour(alertDate, notificationHour) 
        : _nextAtHour(notificationHour);

    final daysExpired = now.difference(agreementEndDate).inDays;
    // Fix text if it's not expired yet
    final expiredLabel = now.isBefore(agreementEndDate)
        ? 'has expired'
        : (daysExpired <= 1 ? 'expired yesterday' : 'expired $daysExpired days ago');

    await scheduleNotification(
      id: _agreementExpiredReminderId(occupancyId),
      title: 'Agreement Expired - Room $roomNumber',
      body: '$tenantName\'s agreement $expiredLabel. Renew or close occupancy.',
      scheduledTime: scheduledTime,
      repeatDaily: true,
      payload: 'agreement_expired:$occupancyId',
    );
  }

  /// Schedule reminder when a bill is not generated for the current cycle.
  Future<void> scheduleBillGenerationReminder({
    required int occupancyId,
    required BillType billType,
    required String tenantName,
    required String roomNumber,
    required DateTime cycleEndDate,
    required int daysUntilDueDate,
    int notificationHour = 9,
  }) async {
    if (!_isInitialized) await initialize();

    final scheduledTime = _nextAtHour(notificationHour);
    final typeLabel = billType.name.toUpperCase();
    final shortMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final cycleEndLabel =
        '${shortMonths[cycleEndDate.month - 1]} ${cycleEndDate.day}';
    final urgencyLabel = daysUntilDueDate < 0
        ? 'overdue by ${daysUntilDueDate.abs()} days'
        : daysUntilDueDate == 0
        ? 'due today'
        : 'due in $daysUntilDueDate days';

    await scheduleNotification(
      id: _billGenerationReminderId(occupancyId, billType),
      title: 'Bill Pending - $typeLabel • Room $roomNumber',
      body:
          '$tenantName\'s cycle $urgencyLabel (end: $cycleEndLabel). Create the bill now.',
      scheduledTime: scheduledTime,
      repeatDaily: true,
      payload: 'bill_generation:$occupancyId:${billType.index}',
    );
  }

  /// Schedule reminder for move-out deposit settlement that is still pending.
  Future<void> scheduleDepositSettlementDueReminder({
    required int occupancyId,
    required String tenantName,
    required String roomNumber,
    required DateTime moveOutDate,
    int daysAfterMoveOut = 3,
    int notificationHour = 9,
  }) async {
    if (!_isInitialized) await initialize();

    final alertDate = moveOutDate.add(Duration(days: daysAfterMoveOut));
    final now = DateTime.now();
    if (now.isBefore(alertDate)) {
      final scheduledTime = _atHour(alertDate, notificationHour);
      await scheduleNotification(
        id: _depositSettlementReminderId(occupancyId),
        title: 'Deposit Settlement Due - Room $roomNumber',
        body: 'Settle deposit for $tenantName after move-out.',
        scheduledTime: scheduledTime,
        payload: 'deposit_settlement:$occupancyId',
      );
      return;
    }

    await scheduleNotification(
      id: _depositSettlementReminderId(occupancyId),
      title: 'Deposit Settlement Pending - Room $roomNumber',
      body: 'Deposit settlement for $tenantName is still pending.',
      scheduledTime: _nextAtHour(notificationHour),
      payload: 'deposit_settlement:$occupancyId',
    );
  }

  /// Schedule alert when electricity usage spikes abnormally.
  Future<void> scheduleUtilityUsageAnomalyReminder({
    required int occupancyId,
    required String tenantName,
    required String roomNumber,
    required int currentUnits,
    required int previousUnits,
    required double increasePercent,
    int notificationHour = 9,
  }) async {
    if (!_isInitialized) await initialize();

    final scheduledTime = _nextAtHour(notificationHour);

    await scheduleNotification(
      id: _utilityAnomalyReminderId(occupancyId),
      title: 'High Utility Usage - Room $roomNumber',
      body:
          '$tenantName used $currentUnits units vs $previousUnits last cycle (${increasePercent.toStringAsFixed(0)}% higher).',
      scheduledTime: scheduledTime,
      payload: 'utility_anomaly:$occupancyId',
    );
  }

  // ========== Payment Follow-up Notifications ==========

  /// Schedule escalating overdue reminders at 1, 3, 7, and 14 days overdue.
  ///
  /// These help landlords follow up with tenants who haven't paid.
  Future<void> scheduleOverdueEscalation({
    required Bill bill,
    Set<int> escalationDays = const {1, 3, 7, 14},
    int notificationHour = 10,
    bool pauseOnPartialPayment = true,
    double partialPaymentThresholdRatio = 0.5,
  }) async {
    if (bill.dueDate == null || bill.isFullyPaid) return;

    if (pauseOnPartialPayment && bill.amount > 0) {
      final paidRatio = bill.paidAmount / bill.amount;
      if (paidRatio >= partialPaymentThresholdRatio) {
        debugPrint(
          'Skipping overdue escalation for bill ${bill.id} because paid ratio is ${(paidRatio * 100).toStringAsFixed(0)}%',
        );
        return;
      }
    }

    if (!_isInitialized) await initialize();

    final allowedDays = escalationDays.where((d) => d > 0).toSet();
    if (allowedDays.isEmpty) return;

    final tenantName = bill.tenantName ?? 'Tenant';
    final amount = bill.pendingAmount;
    final roomNumber = bill.roomNumber ?? 'Room';

    for (final daysOverdue in allowedDays) {
      String title;
      String bodyPrefix;
      
      if (daysOverdue == 1) {
        title = '📋 Payment Due - $roomNumber';
        bodyPrefix = 'is now overdue';
      } else if (daysOverdue <= 3) {
        title = '⏰ Payment Reminder - $roomNumber';
        bodyPrefix = 'is $daysOverdue days overdue';
      } else if (daysOverdue <= 7) {
        title = '⚠️ Overdue $daysOverdue Days - $roomNumber';
        bodyPrefix = 'is $daysOverdue days overdue';
      } else {
        title = '🚨 Critical: $daysOverdue Days Overdue - $roomNumber';
        bodyPrefix = 'is $daysOverdue days overdue!';
      }

      await _scheduleOverdueReminder(
        bill: bill,
        daysOverdue: daysOverdue,
        title: title,
        body: '$tenantName\'s ₹${amount.toStringAsFixed(0)} $bodyPrefix.',
        notificationHour: notificationHour,
      );
    }
  }

  Future<void> _scheduleOverdueReminder({
    required Bill bill,
    required int daysOverdue,
    required String title,
    required String body,
    required int notificationHour,
  }) async {
    final reminderDate = bill.dueDate!.add(Duration(days: daysOverdue));

    // Don't schedule if reminder date is in the past
    if (reminderDate.isBefore(DateTime.now())) return;

    final scheduledTime = _atHour(reminderDate, notificationHour);

    await scheduleNotification(
      id: _overdueReminderId(bill.id, daysOverdue),
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      payload: 'overdue:${bill.id}',
    );

    debugPrint(
      'Scheduled $daysOverdue-day overdue reminder for bill ${bill.id}',
    );
  }

  /// Cancel all escalation reminders for a bill (when paid)
  Future<void> cancelOverdueEscalation(int billId) async {
    await _plugin.cancel(_overdueReminderId(billId, 1));
    await _plugin.cancel(_overdueReminderId(billId, 3));
    await _plugin.cancel(_overdueReminderId(billId, 7));
    await _plugin.cancel(_overdueReminderId(billId, 14));
  }

  // ========== Summary Notifications ==========

  /// Show immediate summary of collection status.
  Future<void> showCollectionSummary({
    required int totalTenants,
    required int paidCount,
    required int pendingCount,
    required double collectedAmount,
    required double pendingAmount,
    String? periodLabel,
  }) async {
    if (!_isInitialized) await initialize();

    final title = '📊 ${periodLabel ?? 'Monthly'} Collection Summary';
    final body =
        '$paidCount/$totalTenants paid • '
        '₹${collectedAmount.toStringAsFixed(0)} collected • '
        '₹${pendingAmount.toStringAsFixed(0)} pending';

    await showNotification(
      id: 998, // Fixed ID for summary
      title: title,
      body: body,
      payload: 'summary',
    );
  }

  /// Show confirmation when a new bill is created.
  Future<void> showBillCreatedConfirmation({
    required String roomNumber,
    required String tenantName,
    required double amount,
    required String period,
  }) async {
    if (!_isInitialized) await initialize();

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: '✅ Bill Created - Room $roomNumber',
      body: '₹${amount.toStringAsFixed(0)} for $tenantName ($period)',
      payload: 'bill_created',
    );
  }

  /// Show confirmation when a payment is recorded.
  Future<void> showPaymentRecordedConfirmation({
    required String roomNumber,
    required String tenantName,
    required double amount,
    required bool isFullyPaid,
  }) async {
    if (!_isInitialized) await initialize();

    final title = isFullyPaid
        ? '✅ Bill Fully Paid - Room $roomNumber'
        : '💰 Payment Received - Room $roomNumber';
    final body = isFullyPaid
        ? '$tenantName has paid in full!'
        : '₹${amount.toStringAsFixed(0)} received from $tenantName';

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: 'payment_recorded',
    );
  }

  /// Show notification when overdue follow-ups are paused after partial payment.
  Future<void> showPartialPaymentPauseNotice({
    required String roomNumber,
    required String tenantName,
    required double paidRatio,
  }) async {
    if (!_isInitialized) await initialize();

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Follow-ups Paused - Room $roomNumber',
      body:
          '$tenantName has paid ${(paidRatio * 100).toStringAsFixed(0)}%. Overdue reminders paused.',
      payload: 'partial_payment_pause',
    );
  }
}
