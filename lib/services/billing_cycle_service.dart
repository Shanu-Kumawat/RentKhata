/// Billing cycle service for anniversary-based date calculations.
/// Handles edge cases for billing cycles anchored to tenant move-in dates.
library;

/// Represents a billing cycle with start and end dates.
class BillingCycle {
  final DateTime start;
  final DateTime end;

  const BillingCycle({required this.start, required this.end});

  /// Duration of the cycle in days.
  int get durationDays => end.difference(start).inDays + 1;

  /// Check if a date falls within this cycle.
  bool contains(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return !normalizedDate.isBefore(start) && !normalizedDate.isAfter(end);
  }

  @override
  String toString() => 'BillingCycle($start to $end)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingCycle &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

/// Service for calculating anniversary-based billing cycles.
///
/// Key concept: Billing cycles are derived from the tenant's move-in date,
/// not the calendar month. If a tenant moves in on the 15th, each billing
/// cycle runs from the 15th to the 14th of the next month.
///
/// Edge cases handled:
/// - Move-in on 29th, 30th, or 31st
/// - Months with fewer days (February, 30-day months)
/// - February in leap years vs non-leap years
class BillingCycleService {
  /// The anchor day from the original move-in date.
  /// This is preserved for "recovery" when possible.
  final int _originalAnchorDay;

  BillingCycleService._(this._originalAnchorDay);

  /// Create a service anchored to a move-in date.
  factory BillingCycleService.fromMoveIn(DateTime moveInDate) {
    return BillingCycleService._(moveInDate.day);
  }

  /// Get the number of days in a given month.
  static int daysInMonth(int year, int month) {
    // Handle month overflow (e.g., month 13 -> next year January)
    if (month > 12) {
      year += (month - 1) ~/ 12;
      month = ((month - 1) % 12) + 1;
    }
    // Create the first day of the next month and subtract one day
    return DateTime(year, month + 1, 0).day;
  }

  /// Check if a year is a leap year.
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Add rental months to an anchor date.
  ///
  /// This handles edge cases by clamping to the last valid day of the
  /// target month when the anchor day doesn't exist, but attempts to
  /// "recover" to the original anchor day in subsequent months when possible.
  ///
  /// Examples:
  /// - Jan 31 + 1 month = Feb 28 (or 29 in leap year)
  /// - Feb 28 + 1 month = Mar 31 (recovers to original anchor day 31)
  /// - Jan 30 + 1 month = Feb 28 → Mar 30 (recovers to 30)
  /// - Mar 31 + 1 month = Apr 30 → May 31 (recovers to 31)
  static DateTime addRentalMonths(
    DateTime anchor,
    int months, {
    int? originalAnchorDay,
  }) {
    if (months == 0) return anchor;

    // Use the original anchor day for recovery if provided
    final targetDay = originalAnchorDay ?? anchor.day;

    // Calculate target year and month
    int newMonth = anchor.month + months;
    int newYear = anchor.year;

    // Handle month overflow/underflow
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    // Get the maximum valid day for the target month
    final maxDay = daysInMonth(newYear, newMonth);

    // Use the target day, clamped to the maximum valid day
    final clampedDay = targetDay > maxDay ? maxDay : targetDay;

    return DateTime(newYear, newMonth, clampedDay);
  }

  /// Get the billing cycle that ends on or after a specific date.
  ///
  /// Starting from [moveInDate], calculates successive billing cycles
  /// until finding the one that contains [targetDate].
  static BillingCycle getCycleForDate(
    DateTime moveInDate,
    DateTime targetDate,
  ) {
    final service = BillingCycleService.fromMoveIn(moveInDate);
    final normalizedMoveIn = DateTime(
      moveInDate.year,
      moveInDate.month,
      moveInDate.day,
    );
    final normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    // Start from move-in date
    DateTime cycleStart = normalizedMoveIn;

    // Iterate through cycles until we find the one containing targetDate
    while (true) {
      // Calculate cycle end (one day before the next cycle start)
      final nextCycleStart = addRentalMonths(
        cycleStart,
        1,
        originalAnchorDay: service._originalAnchorDay,
      );
      final cycleEnd = nextCycleStart.subtract(const Duration(days: 1));

      final cycle = BillingCycle(start: cycleStart, end: cycleEnd);

      // If target date is before this cycle starts, we've gone past
      // (This shouldn't happen if starting from move-in, but safety check)
      if (normalizedTarget.isBefore(cycleStart)) {
        return cycle;
      }

      // If target date falls within this cycle
      if (cycle.contains(normalizedTarget)) {
        return cycle;
      }

      // Move to next cycle
      cycleStart = nextCycleStart;

      // Safety: prevent infinite loop (100 years of cycles)
      if (cycleStart.year > moveInDate.year + 100) {
        return cycle;
      }
    }
  }

  /// Get the current billing cycle based on today's date.
  static BillingCycle getCurrentCycle(DateTime moveInDate) {
    return getCycleForDate(moveInDate, DateTime.now());
  }

  /// Get the next billing cycle after a given cycle end date.
  ///
  /// Used for determining the next cycle when the previous cycle's
  /// end date is known (e.g., from the last bill's periodEndDate).
  static BillingCycle getNextCycleAfter(
    DateTime moveInDate,
    DateTime lastCycleEnd,
  ) {
    // Next cycle starts the day after the last cycle ended
    final nextStart = lastCycleEnd.add(const Duration(days: 1));
    return getCycleForDate(moveInDate, nextStart);
  }

  /// Calculate how many complete cycles have passed since move-in.
  static int getCycleNumber(DateTime moveInDate, DateTime targetDate) {
    final service = BillingCycleService.fromMoveIn(moveInDate);
    final normalizedMoveIn = DateTime(
      moveInDate.year,
      moveInDate.month,
      moveInDate.day,
    );
    final normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    if (normalizedTarget.isBefore(normalizedMoveIn)) {
      return 0;
    }

    int cycleIndex = 0;
    DateTime cycleStart = normalizedMoveIn;

    while (true) {
      final nextCycleStart = addRentalMonths(
        cycleStart,
        1,
        originalAnchorDay: service._originalAnchorDay,
      );
      final cycleEnd = nextCycleStart.subtract(const Duration(days: 1));
      final cycle = BillingCycle(start: cycleStart, end: cycleEnd);

      if (normalizedTarget.isBefore(cycleStart) || cycle.contains(normalizedTarget)) {
        return cycleIndex;
      }

      cycleStart = nextCycleStart;
      cycleIndex++;

      if (cycleIndex > 1200) { // 100 years safety
        return cycleIndex;
      }
    }
  }

  /// Get the Nth billing cycle (0-indexed).
  ///
  /// Cycle 0 = first cycle starting from move-in date.
  static BillingCycle getCycleByNumber(DateTime moveInDate, int cycleNumber) {
    final service = BillingCycleService.fromMoveIn(moveInDate);
    final normalizedMoveIn = DateTime(
      moveInDate.year,
      moveInDate.month,
      moveInDate.day,
    );

    final cycleStart = addRentalMonths(
      normalizedMoveIn,
      cycleNumber,
      originalAnchorDay: service._originalAnchorDay,
    );

    final nextCycleStart = addRentalMonths(
      normalizedMoveIn,
      cycleNumber + 1,
      originalAnchorDay: service._originalAnchorDay,
    );

    final cycleEnd = nextCycleStart.subtract(const Duration(days: 1));

    return BillingCycle(start: cycleStart, end: cycleEnd);
  }
}
