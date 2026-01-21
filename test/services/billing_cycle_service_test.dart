import 'package:flutter_test/flutter_test.dart';
import 'package:rent_khata/services/billing_cycle_service.dart';

void main() {
  group('BillingCycleService', () {
    group('daysInMonth', () {
      test('returns correct days for regular months', () {
        expect(BillingCycleService.daysInMonth(2026, 1), 31); // January
        expect(BillingCycleService.daysInMonth(2026, 4), 30); // April
        expect(BillingCycleService.daysInMonth(2026, 6), 30); // June
      });

      test('returns 28 days for February in non-leap year', () {
        expect(BillingCycleService.daysInMonth(2026, 2), 28);
        expect(BillingCycleService.daysInMonth(2025, 2), 28);
      });

      test('returns 29 days for February in leap year', () {
        expect(BillingCycleService.daysInMonth(2024, 2), 29);
        expect(BillingCycleService.daysInMonth(2028, 2), 29);
      });
    });

    group('isLeapYear', () {
      test('identifies leap years correctly', () {
        expect(BillingCycleService.isLeapYear(2024), true);
        expect(BillingCycleService.isLeapYear(2028), true);
        expect(BillingCycleService.isLeapYear(2000), true); // Divisible by 400
      });

      test('identifies non-leap years correctly', () {
        expect(BillingCycleService.isLeapYear(2025), false);
        expect(BillingCycleService.isLeapYear(2026), false);
        expect(
          BillingCycleService.isLeapYear(1900),
          false,
        ); // Divisible by 100 but not 400
      });
    });

    group('addRentalMonths', () {
      test('adds months to regular dates correctly', () {
        final anchor = DateTime(2026, 1, 15);
        final result = BillingCycleService.addRentalMonths(anchor, 1);
        expect(result, DateTime(2026, 2, 15));
      });

      test('handles crossing year boundary', () {
        final anchor = DateTime(2026, 11, 15);
        final result = BillingCycleService.addRentalMonths(anchor, 3);
        expect(result, DateTime(2027, 2, 15));
      });

      test('clamps 31st to end of shorter months', () {
        final anchor = DateTime(2026, 1, 31);

        // Jan 31 + 1 month = Feb 28 (2026 is not leap year)
        final feb = BillingCycleService.addRentalMonths(anchor, 1);
        expect(feb, DateTime(2026, 2, 28));

        // Jan 31 + 3 months = Apr 30
        final apr = BillingCycleService.addRentalMonths(anchor, 3);
        expect(apr, DateTime(2026, 4, 30));
      });

      test('clamps 31st to Feb 29 in leap year', () {
        final anchor = DateTime(2024, 1, 31);
        final result = BillingCycleService.addRentalMonths(anchor, 1);
        expect(result, DateTime(2024, 2, 29));
      });

      test('recovers to original anchor day when possible', () {
        final anchor = DateTime(2026, 1, 31);

        // Jan 31 -> Feb 28
        final feb = BillingCycleService.addRentalMonths(anchor, 1);
        expect(feb, DateTime(2026, 2, 28));

        // When calculating next cycle from Feb 28, we want to recover to 31
        // by passing originalAnchorDay
        final mar = BillingCycleService.addRentalMonths(
          feb,
          1,
          originalAnchorDay: 31,
        );
        expect(mar, DateTime(2026, 3, 31));
      });

      test('handles 30th in February', () {
        final anchor = DateTime(2026, 1, 30);
        final feb = BillingCycleService.addRentalMonths(anchor, 1);
        expect(feb, DateTime(2026, 2, 28));

        // Recovery
        final mar = BillingCycleService.addRentalMonths(
          feb,
          1,
          originalAnchorDay: 30,
        );
        expect(mar, DateTime(2026, 3, 30));
      });

      test('handles 29th in non-leap February', () {
        final anchor = DateTime(2026, 1, 29);
        final feb = BillingCycleService.addRentalMonths(anchor, 1);
        expect(feb, DateTime(2026, 2, 28));

        // Recovery
        final mar = BillingCycleService.addRentalMonths(
          feb,
          1,
          originalAnchorDay: 29,
        );
        expect(mar, DateTime(2026, 3, 29));
      });

      test('handles 29th in leap year February', () {
        final anchor = DateTime(2024, 1, 29);
        final feb = BillingCycleService.addRentalMonths(anchor, 1);
        expect(feb, DateTime(2024, 2, 29)); // No clamping needed
      });

      test('returns same date when adding 0 months', () {
        final anchor = DateTime(2026, 5, 15);
        final result = BillingCycleService.addRentalMonths(anchor, 0);
        expect(result, anchor);
      });
    });

    group('getCurrentCycle', () {
      test('returns correct cycle for date within first month', () {
        final moveIn = DateTime(2026, 1, 15);
        final today = DateTime(2026, 1, 20);

        final cycle = BillingCycleService.getCycleForDate(moveIn, today);
        expect(cycle.start, DateTime(2026, 1, 15));
        expect(cycle.end, DateTime(2026, 2, 14));
      });

      test('returns correct cycle for date in second month', () {
        final moveIn = DateTime(2026, 1, 15);
        final today = DateTime(2026, 2, 10);

        final cycle = BillingCycleService.getCycleForDate(moveIn, today);
        expect(cycle.start, DateTime(2026, 1, 15));
        expect(cycle.end, DateTime(2026, 2, 14));
      });

      test('returns next cycle when today is exactly on cycle boundary', () {
        final moveIn = DateTime(2026, 1, 15);
        final today = DateTime(2026, 2, 15);

        final cycle = BillingCycleService.getCycleForDate(moveIn, today);
        expect(cycle.start, DateTime(2026, 2, 15));
        expect(cycle.end, DateTime(2026, 3, 14));
      });

      test('handles 31st move-in crossing February', () {
        final moveIn = DateTime(2026, 1, 31);

        // Cycle 1: Jan 31 - Feb 27 (since Feb 28 is next cycle start)
        final jan31 = DateTime(2026, 1, 31);
        final cycle1 = BillingCycleService.getCycleForDate(moveIn, jan31);
        expect(cycle1.start, DateTime(2026, 1, 31));
        expect(cycle1.end, DateTime(2026, 2, 27)); // Day before Feb 28

        // Feb 28 should be start of cycle 2
        final cycle2 = BillingCycleService.getCycleForDate(
          moveIn,
          DateTime(2026, 2, 28),
        );
        expect(cycle2.start, DateTime(2026, 2, 28));
        expect(cycle2.end, DateTime(2026, 3, 30)); // Day before Mar 31
      });
    });

    group('getNextCycleAfter', () {
      test('returns cycle starting day after last period ended', () {
        final moveIn = DateTime(2026, 1, 15);
        final lastPeriodEnd = DateTime(2026, 2, 14);

        final nextCycle = BillingCycleService.getNextCycleAfter(
          moveIn,
          lastPeriodEnd,
        );
        expect(nextCycle.start, DateTime(2026, 2, 15));
        expect(nextCycle.end, DateTime(2026, 3, 14));
      });

      test('handles edge case at year boundary', () {
        final moveIn = DateTime(2025, 12, 15);
        final lastPeriodEnd = DateTime(2026, 1, 14);

        final nextCycle = BillingCycleService.getNextCycleAfter(
          moveIn,
          lastPeriodEnd,
        );
        expect(nextCycle.start, DateTime(2026, 1, 15));
        expect(nextCycle.end, DateTime(2026, 2, 14));
      });
    });
  });
}
