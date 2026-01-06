/// Extension methods for DateTime.
library;

import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Format as "Jan 2024"
  String toMonthYear() => DateFormat('MMM yyyy').format(this);

  /// Format as "15 Jan 2024"
  String toDayMonthYear() => DateFormat('dd MMM yyyy').format(this);

  /// Format as "15 Jan 2024, 2:30 PM"
  String toFullDateTime() => DateFormat('dd MMM yyyy, h:mm a').format(this);

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  /// Check if same month and year
  bool isSameMonthAs(DateTime other) =>
      year == other.year && month == other.month;
}
