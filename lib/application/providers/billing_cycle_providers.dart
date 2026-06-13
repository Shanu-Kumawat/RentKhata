/// Billing cycle providers for date-to-date based billing logic.
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
/// occupancy's move-in date using date-to-date based logic.
@riverpod
BillingCycle currentBillingCycle(Ref ref, Occupancy occupancy) {
  return BillingCycleService.getCurrentCycle(
    occupancy.effectiveBillingStartDate,
  );
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
    return BillingCycleService.getCycleByNumber(
      occupancy.effectiveBillingStartDate,
      0,
    );
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
      occupancy.effectiveBillingStartDate,
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
  return BillingCycleService.getCurrentCycle(
    occupancy.effectiveBillingStartDate,
  );
}

/// Get the next billing cycle for a specific bill type.
///
/// Each bill type has its own cycle progression. For example:
/// - Rent might be on cycle 5 (advance payment)
/// - Electricity might be on cycle 2 (behind on bills)
///
/// This allows independent tracking per bill type.
@riverpod
Future<BillingCycle> nextBillingCycleForBillType(
  Ref ref,
  int occupancyId,
  BillType billType,
) async {
  final billingRepo = ref.watch(billingRepositoryProvider);

  // Get the occupancy to find move-in date
  final occupancy = await ref.watch(occupancyProvider(occupancyId).future);
  if (occupancy == null) {
    // Fallback: return a cycle starting today
    final now = DateTime.now();
    return BillingCycle(start: now, end: now.add(const Duration(days: 30)));
  }

  // Get all bills of this type for this occupancy
  final allBills = await billingRepo.getBillsForOccupancy(occupancyId);
  final typeBills = allBills.where((b) => b.billType == billType).toList();

  // If no bills of this type exist, return cycle 0 (first cycle from move-in)
  if (typeBills.isEmpty) {
    return BillingCycleService.getCycleByNumber(
      occupancy.effectiveBillingStartDate,
      0,
    );
  }

  // Build a set of billed period start dates for quick lookup
  final billedPeriodStarts = <DateTime>{};
  for (final bill in typeBills) {
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
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  for (int cycleNum = 0; cycleNum < 100; cycleNum++) {
    final cycle = BillingCycleService.getCycleByNumber(
      occupancy.effectiveBillingStartDate,
      cycleNum,
    );

    // Normalize cycle start for comparison
    final cycleStartNormalized = DateTime(
      cycle.start.year,
      cycle.start.month,
      cycle.start.day,
    );

    // Check if this cycle has a bill of this type
    if (!billedPeriodStarts.contains(cycleStartNormalized)) {
      // No bill for this cycle - this is the one that needs a bill
      return cycle;
    }

    // If we've gone past current date, stop looking
    if (cycle.end.isAfter(today)) {
      continue;
    }
  }

  // Fallback: return current cycle
  return BillingCycleService.getCurrentCycle(
    occupancy.effectiveBillingStartDate,
  );
}

/// Get ALL unbilled cycles for a specific bill type up to current date.
///
/// Returns a list of ALL cycles that are missing bills, allowing the
/// attention list to show multiple overdue cycles per bill type.
@riverpod
Future<List<BillingCycle>> allUnbilledCyclesForBillType(
  Ref ref,
  int occupancyId,
  BillType billType,
) async {
  final billingRepo = ref.watch(billingRepositoryProvider);

  // Get the occupancy to find move-in date
  final occupancy = await ref.watch(occupancyProvider(occupancyId).future);
  if (occupancy == null) {
    return [];
  }

  // Get all bills of this type for this occupancy
  final allBills = await billingRepo.getBillsForOccupancy(occupancyId);
  final typeBills = allBills.where((b) => b.billType == billType).toList();

  // Build a set of billed period start dates for quick lookup
  final billedPeriodStarts = <DateTime>{};
  for (final bill in typeBills) {
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

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final List<BillingCycle> unbilledCycles = [];

  // Iterate through cycles from 0 until we reach cycles ending after today
  for (int cycleNum = 0; cycleNum < 100; cycleNum++) {
    final cycle = BillingCycleService.getCycleByNumber(
      occupancy.effectiveBillingStartDate,
      cycleNum,
    );

    // Stop if this cycle ends far in the future (more than 30 days from today)
    // This prevents showing too many future cycles
    if (cycle.end.isAfter(today.add(const Duration(days: 30)))) {
      break;
    }

    // Normalize cycle start for comparison
    final cycleStartNormalized = DateTime(
      cycle.start.year,
      cycle.start.month,
      cycle.start.day,
    );

    // If this cycle doesn't have a bill, add it to unbilled list
    if (!billedPeriodStarts.contains(cycleStartNormalized)) {
      unbilledCycles.add(cycle);
    }
  }

  return unbilledCycles;
}

/// Get billing attention items for a single occupancy.
///
/// Returns a list of attention items - one for EACH unbilled cycle that:
/// - Has date-to-date billing enabled in settings
/// - Has a cycle needing attention (due soon or overdue)
@riverpod
Future<List<BillingAttentionItem>> billingStatusFor(
  Ref ref,
  int occupancyId,
) async {
  final config = await ref.watch(billingAttentionConfigProvider.future);
  final settings = await ref.watch(billSettingsProvider.future);
  final tenantRepo = ref.watch(tenantRepositoryProvider);
  final propertyRepo = ref.watch(propertyRepositoryProvider);

  // Get occupancy details
  final occupancy = await ref.watch(occupancyProvider(occupancyId).future);
  if (occupancy == null || !occupancy.isActive) {
    return [];
  }

  // Get room and property info
  final room = await propertyRepo.getRoomById(occupancy.roomId);
  if (room == null) return [];

  final property = await propertyRepo.getPropertyById(room.propertyId);

  // Get tenant info
  final tenant = await tenantRepo.getTenantById(occupancy.tenantId);
  if (tenant == null) return [];

  // Check which bill types have date-to-date enabled
  final enabledBillTypes = <BillType>[];
  if (settings.rentUsesDateToDate) enabledBillTypes.add(BillType.rent);
  if (settings.electricityUsesDateToDate) {
    enabledBillTypes.add(BillType.electricity);
  }
  if (settings.waterUsesDateToDate) enabledBillTypes.add(BillType.water);
  if (settings.maintenanceUsesDateToDate) {
    enabledBillTypes.add(BillType.maintenance);
  }
  if (settings.otherUsesDateToDate) enabledBillTypes.add(BillType.other);

  final List<BillingAttentionItem> attentionItems = [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Check each enabled bill type
  for (final billType in enabledBillTypes) {
    // Get ALL unbilled cycles for this bill type
    final unbilledCycles = await ref.watch(
      allUnbilledCyclesForBillTypeProvider(occupancyId, billType).future,
    );

    // Add an attention item for each unbilled cycle that needs attention
    for (final cycle in unbilledCycles) {
      // Calculate days until cycle end
      final daysUntilEnd = cycle.end.difference(today).inDays;

      // Determine status based on days until cycle end
      BillingCycleStatus status;
      if (daysUntilEnd < 0) {
        status = BillingCycleStatus.overdue;
      } else if (daysUntilEnd <= config.dueSoonThresholdDays) {
        status = BillingCycleStatus.dueSoon;
      } else {
        status = BillingCycleStatus.upToDate;
      }

      // Only add items that need attention
      if (status != BillingCycleStatus.upToDate) {
        attentionItems.add(
          BillingAttentionItem(
            occupancyId: occupancyId,
            roomId: room.id,
            roomNumber: room.roomNumber,
            tenantName: tenant.name,
            cycleStart: cycle.start,
            cycleEnd: cycle.end,
            status: status,
            billType: billType,
            daysUntilCycleEnd: daysUntilEnd,
            agreedRent: occupancy.agreedRent,
            propertyName: property?.name,
          ),
        );
      }
    }
  }

  return attentionItems;
}

/// Get all occupancies that need billing attention.
///
/// Returns a list of attention items across all occupancies and bill types.
/// Each item represents a specific bill type for an occupancy that needs attention.
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
    // billingStatusFor now returns a list of items (one per bill type)
    final items = await ref.watch(
      billingStatusForProvider(occupancy.id).future,
    );
    attentionItems.addAll(items);
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
