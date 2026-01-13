/// Notification service for local notifications.
library;

/// Notification types for the app.
enum NotificationType {
  dueSoon,
  overdue,
  rentCollectionDay,
  depositPending,
  billsReadyToGenerate,
}

/// Represents a scheduled notification.
class ScheduledNotification {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final NotificationType type;
  final Map<String, dynamic>? payload;

  ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.type,
    this.payload,
  });
}

/// Service for handling local notifications.
/// Note: This is a placeholder service. Full implementation requires
/// flutter_local_notifications package setup with platform-specific config.
class NotificationService {
  static const int dueSoonDays = 3;
  static const int overdueDays = 1;

  /// Generate notification title for a bill.
  static String getBillDueTitle(String tenantName) {
    return 'Bill Due Soon - $tenantName';
  }

  /// Generate notification body for due bill.
  static String getBillDueBody({
    required String billType,
    required String period,
    required double amount,
    required int daysRemaining,
  }) {
    return '${billType.toUpperCase()} bill for $period (₹${amount.toStringAsFixed(0)}) is due in $daysRemaining days.';
  }

  /// Generate overdue notification.
  static String getOverdueBody({
    required String billType,
    required String period,
    required double amount,
  }) {
    return '${billType.toUpperCase()} bill for $period (₹${amount.toStringAsFixed(0)}) is overdue. Please collect payment.';
  }

  /// Generate rent collection day reminder.
  static String getRentCollectionBody(int roomCount) {
    return 'Today is rent collection day. You have $roomCount occupied rooms.';
  }

  /// Check if quiet hours apply.
  static bool isQuietHours({
    required DateTime time,
    required int quietStart,
    required int quietEnd,
  }) {
    final hour = time.hour;
    if (quietStart < quietEnd) {
      return hour >= quietStart && hour < quietEnd;
    } else {
      // Wraps around midnight
      return hour >= quietStart || hour < quietEnd;
    }
  }

  /// Get next non-quiet hour time.
  static DateTime getNextNonQuietTime({
    required DateTime from,
    required int quietStart,
    required int quietEnd,
  }) {
    if (!isQuietHours(time: from, quietStart: quietStart, quietEnd: quietEnd)) {
      return from;
    }
    // Move to end of quiet hours
    final next = DateTime(from.year, from.month, from.day, quietEnd, 0);
    if (next.isAfter(from)) return next;
    return next.add(const Duration(days: 1));
  }
}
