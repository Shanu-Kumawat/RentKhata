/// Local notification service for Android.
/// Handles initialization, scheduling, and management of due/overdue bill reminders.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter/foundation.dart';
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
      '@mipmap/ic_launcher',
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

    // Auto-request notification permission on Android 13+
    final granted = await androidPlugin?.requestNotificationsPermission();
    debugPrint('Notification permission granted: $granted');

    // Also request exact alarm permission for scheduled notifications
    await androidPlugin?.requestExactAlarmsPermission();

    _isInitialized = true;
    debugPrint('LocalNotificationService initialized');
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
      icon: '@mipmap/ic_launcher',
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
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'bill_reminders',
      'Bill Reminders',
      channelDescription: 'Notifications for due and overdue bills',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule due bill reminder (X days before due date)
  Future<void> scheduleDueBillReminder({
    required Bill bill,
    required int daysBefore,
  }) async {
    if (bill.dueDate == null || bill.isFullyPaid) return;

    final reminderDate = bill.dueDate!.subtract(Duration(days: daysBefore));

    // Don't schedule if reminder date is in the past
    if (reminderDate.isBefore(DateTime.now())) return;

    // Set reminder for 9 AM
    final scheduledTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9, // 9 AM
      0,
    );

    await scheduleNotification(
      id: bill.id * 10 + 1, // Unique ID for due reminder
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

    // Set reminder for 10 AM
    final scheduledTime = DateTime(
      overdueDate.year,
      overdueDate.month,
      overdueDate.day,
      10, // 10 AM
      0,
    );

    await scheduleNotification(
      id: bill.id * 10 + 2, // Unique ID for overdue reminder
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
    await _plugin.cancel(billId * 10 + 1); // Due reminder
    await _plugin.cancel(billId * 10 + 2); // Overdue reminder
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
  }) async {
    if (!_isInitialized) await initialize();

    final reminderDate = cycleEndDate.subtract(Duration(days: daysBefore));

    // Don't schedule if reminder date is in the past
    if (reminderDate.isBefore(DateTime.now())) return;

    // Set reminder for 9 AM
    final scheduledTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9, // 9 AM
      0,
    );

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
      id: occupancyId * 100 + 50, // Unique ID for cycle reminder
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
    await _plugin.cancel(occupancyId * 100 + 50);
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
  }) async {
    for (final occ in occupancies) {
      await scheduleCycleEndReminder(
        occupancyId: occ.occupancyId,
        tenantName: occ.tenantName,
        roomNumber: occ.roomNumber,
        cycleEndDate: occ.cycleEndDate,
        daysBefore: daysBefore,
      );
    }
  }

  // ========== Payment Follow-up Notifications ==========

  /// Schedule escalating overdue reminders at 1, 3, 7, and 14 days overdue.
  ///
  /// These help landlords follow up with tenants who haven't paid.
  Future<void> scheduleOverdueEscalation({required Bill bill}) async {
    if (bill.dueDate == null || bill.isFullyPaid) return;
    if (!_isInitialized) await initialize();

    final tenantName = bill.tenantName ?? 'Tenant';
    final amount = bill.pendingAmount;
    final roomNumber = bill.roomNumber ?? 'Room';

    // 1-day overdue reminder (first reminder)
    await _scheduleOverdueReminder(
      bill: bill,
      daysOverdue: 1,
      title: '📋 Payment Due - $roomNumber',
      body: '$tenantName\'s ₹${amount.toStringAsFixed(0)} is now overdue.',
    );

    // 3-day overdue reminder
    await _scheduleOverdueReminder(
      bill: bill,
      daysOverdue: 3,
      title: '⏰ Payment Reminder - $roomNumber',
      body: '$tenantName\'s ₹${amount.toStringAsFixed(0)} is 3 days overdue.',
    );

    // 7-day overdue reminder (more urgent)
    await _scheduleOverdueReminder(
      bill: bill,
      daysOverdue: 7,
      title: '⚠️ Overdue 1 Week - $roomNumber',
      body: '₹${amount.toStringAsFixed(0)} from $tenantName is a week overdue.',
    );

    // 14-day overdue reminder (critical)
    await _scheduleOverdueReminder(
      bill: bill,
      daysOverdue: 14,
      title: '🚨 Critical: 2 Weeks Overdue - $roomNumber',
      body:
          '₹${amount.toStringAsFixed(0)} from $tenantName is 2 weeks overdue!',
    );
  }

  Future<void> _scheduleOverdueReminder({
    required Bill bill,
    required int daysOverdue,
    required String title,
    required String body,
  }) async {
    final reminderDate = bill.dueDate!.add(Duration(days: daysOverdue));

    // Don't schedule if reminder date is in the past
    if (reminderDate.isBefore(DateTime.now())) return;

    // Schedule for 10 AM
    final scheduledTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      10, // 10 AM
      0,
    );

    await scheduleNotification(
      id: bill.id * 10 + daysOverdue, // Unique ID per escalation level
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
    await _plugin.cancel(billId * 10 + 1); // 1-day
    await _plugin.cancel(billId * 10 + 3); // 3-day
    await _plugin.cancel(billId * 10 + 7); // 7-day
    await _plugin.cancel(billId * 10 + 14); // 14-day
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
}
