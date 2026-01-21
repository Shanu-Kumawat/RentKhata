/// Billing cycle providers for anniversary-based billing logic.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/billing_status.dart';
import '../../domain/entities/occupancy.dart';
import '../../domain/entities/bill.dart';
import '../../services/billing_cycle_service.dart';
import 'repository_providers.dart';
import 'tenant_providers.dart';
import 'occupancy_providers.dart';
import 'billing_providers.dart';

part 'billing_cycle_providers.g.dart';

/// Configuration provider for billing attention thresholds.
/// Uses settings from database.
@riverpod
Future<BillingAttentionConfig> billingAttentionConfig(Ref ref) async {
  final settings = await ref.watch(billSettingsProvider.future);
  return BillingAttentionConfig(
    dueSoonThresholdDays: settings.dueSoonThresholdDays,
  );
}

/// Get the current billing cycle for an occupancy.
///
/// Returns the cycle containing today's date, calculated from the
/// occupancy's move-in date using anniversary-based logic.
@riverpod
BillingCycle currentBillingCycle(Ref ref, Occupancy occupancy) {
  return BillingCycleService.getCurrentCycle(occupancy.moveInDate);
}

/// Get the next billing cycle that needs a bill.
///
/// Logic:
/// 1. Start from cycle 0 (first cycle from move-in date)
/// 2. For each cycle, check if a rent bill exists covering that period
/// 3. Return the first cycle that has no matching bill
@riverpod
Future<BillingCycle> nextBillingCycleFor(Ref ref, int occupancyId) async {
  final billingRepo = ref.watch(billingRepositoryProvider);

  // Get the occupancy to find move-in date
  final occupancy = await ref.watch(occupancyProvider(occupancyId).future);
  if (occupancy == null) {
    // Fallback: return a cycle starting today
    final now = DateTime.now();
    return BillingCycle(start: now, end: now.add(const Duration(days: 30)));
  }

  // Get all rent bills for this occupancy
  final allBills = await billingRepo.getBillsForOccupancy(occupancyId);
  final rentBills = allBills.where((b) => b.billType == BillType.rent).toList();

  // If no rent bills exist, return cycle 0 (first cycle from move-in)
  if (rentBills.isEmpty) {
    return BillingCycleService.getCycleByNumber(occupancy.moveInDate, 0);
  }

  // Build a set of billed period start dates for quick lookup
  final billedPeriodStarts = <DateTime>{};
  for (final bill in rentBills) {
    if (bill.periodStartDate != null) {
      billedPeriodStarts.add(
        DateTime(
          bill.periodStartDate!.year,
          bill.periodStartDate!.month,
          bill.periodStartDate!.day,
        ),
      );
    }
  }

  // Iterate through cycles from 0 until we find one without a bill
  // or until we're past the current date
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  for (int cycleNum = 0; cycleNum < 100; cycleNum++) {
    final cycle = BillingCycleService.getCycleByNumber(
      occupancy.moveInDate,
      cycleNum,
    );

    // Normalize cycle start for comparison
    final cycleStartNormalized = DateTime(
      cycle.start.year,
      cycle.start.month,
      cycle.start.day,
    );

    // Check if this cycle has a bill
    if (!billedPeriodStarts.contains(cycleStartNormalized)) {
      // No bill for this cycle - this is the one that needs a bill
      return cycle;
    }

    // If we've gone past current date, stop looking
    // (don't require bills for future cycles)
    if (cycle.end.isAfter(today)) {
      // The current cycle has a bill, check next cycle
      continue;
    }
  }

  // Fallback: return current cycle
  return BillingCycleService.getCurrentCycle(occupancy.moveInDate);
}

/// Get billing attention status for a single occupancy.
///
/// Returns null if the occupancy is up-to-date (no attention needed).
@riverpod
Future<BillingAttentionItem?> billingStatusFor(Ref ref, int occupancyId) async {
  final config = await ref.watch(billingAttentionConfigProvider.future);
  final tenantRepo = ref.watch(tenantRepositoryProvider);
  final propertyRepo = ref.watch(propertyRepositoryProvider);

  // Get occupancy details
  final occupancy = await ref.watch(occupancyProvider(occupancyId).future);
  if (occupancy == null || !occupancy.isActive) {
    return null;
  }

  // Get room and property info
  final room = await propertyRepo.getRoomById(occupancy.roomId);
  if (room == null) return null;

  final property = await propertyRepo.getPropertyById(room.propertyId);

  // Get tenant info
  final tenant = await tenantRepo.getTenantById(occupancy.tenantId);
  if (tenant == null) return null;

  // Get the next billing cycle that needs a bill
  final nextCycle = await ref.watch(
    nextBillingCycleForProvider(occupancyId).future,
  );

  // Calculate days until cycle end
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final daysUntilEnd = nextCycle.end.difference(today).inDays;

  // Determine status based on days until cycle end
  BillingCycleStatus status;
  if (daysUntilEnd < 0) {
    status = BillingCycleStatus.overdue;
  } else if (daysUntilEnd <= config.dueSoonThresholdDays) {
    status = BillingCycleStatus.dueSoon;
  } else {
    status = BillingCycleStatus.upToDate;
  }

  // Only return items that need attention
  if (status == BillingCycleStatus.upToDate) {
    return null;
  }

  return BillingAttentionItem(
    occupancyId: occupancyId,
    roomId: room.id,
    roomNumber: room.roomNumber,
    tenantName: tenant.name,
    cycleStart: nextCycle.start,
    cycleEnd: nextCycle.end,
    status: status,
    daysUntilCycleEnd: daysUntilEnd,
    agreedRent: occupancy.agreedRent,
    propertyName: property?.name,
  );
}

/// Get all occupancies that need billing attention.
///
/// Returns a list of occupancies where:
/// - Cycle is ending within the "due soon" threshold, OR
/// - Cycle has already ended (overdue)
///
/// Sorted by urgency (overdue first, then by days until due).
@riverpod
Future<List<BillingAttentionItem>> billingAttentionList(Ref ref) async {
  // Watch active occupancies stream to auto-refresh
  ref.watch(activeOccupanciesStreamProvider);

  final tenantRepo = ref.watch(tenantRepositoryProvider);

  // Get all active occupancies
  final activeOccupancies = await tenantRepo.getActiveOccupancies();

  // Get billing status for each
  final List<BillingAttentionItem> attentionItems = [];

  for (final occupancy in activeOccupancies) {
    final status = await ref.watch(
      billingStatusForProvider(occupancy.id).future,
    );
    if (status != null) {
      attentionItems.add(status);
    }
  }

  // Sort: overdue first, then by days until due (ascending)
  attentionItems.sort((a, b) {
    // Overdue items first
    if (a.status == BillingCycleStatus.overdue &&
        b.status != BillingCycleStatus.overdue) {
      return -1;
    }
    if (b.status == BillingCycleStatus.overdue &&
        a.status != BillingCycleStatus.overdue) {
      return 1;
    }
    // Then by days until due (most urgent first)
    return a.daysUntilCycleEnd.compareTo(b.daysUntilCycleEnd);
  });

  return attentionItems;
}

/// Count of occupancies needing billing attention.
@riverpod
Future<int> billingAttentionCount(Ref ref) async {
  final items = await ref.watch(billingAttentionListProvider.future);
  return items.length;
}

/// Count of overdue billing cycles.
@riverpod
Future<int> overdueBillingCount(Ref ref) async {
  final items = await ref.watch(billingAttentionListProvider.future);
  return items.where((i) => i.status == BillingCycleStatus.overdue).length;
}
