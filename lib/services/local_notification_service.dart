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
}
