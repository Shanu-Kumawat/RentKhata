/// Dashboard-related providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/landlord.dart';
import 'repository_providers.dart';
import 'property_providers.dart';
import 'billing_providers.dart';

part 'dashboard_providers.g.dart';

/// Dashboard summary data.
class DashboardSummary {
  final double totalDue;
  final double totalCollected;
  final int unpaidBillCount;
  final int overdueBillCount;
  final int totalProperties;
  final int totalRooms;
  final int occupiedRooms;

  const DashboardSummary({
    required this.totalDue,
    required this.totalCollected,
    required this.unpaidBillCount,
    required this.overdueBillCount,
    required this.totalProperties,
    required this.totalRooms,
    required this.occupiedRooms,
  });

  double get occupancyRate =>
      totalRooms > 0 ? (occupiedRooms / totalRooms) * 100 : 0;

  double get collectionRate => (totalDue + totalCollected) > 0
      ? (totalCollected / (totalDue + totalCollected)) * 100
      : 0;
}

/// Provides dashboard summary.
/// Watches stream providers to auto-refresh when data changes.
@riverpod
Future<DashboardSummary> dashboardSummary(Ref ref) async {
  // Watch the stream providers to trigger auto-refresh
  ref.watch(propertiesStreamProvider);

  final properties = await ref.watch(propertiesProvider.future);
  final unpaidBills = await ref.watch(unpaidBillsProvider.future);
  final billingRepo = ref.watch(billingRepositoryProvider);

  // Calculate totals
  double totalDue = 0;
  int overdueBillCount = 0;

  for (final bill in unpaidBills) {
    totalDue += bill.pendingAmount;
    if (bill.isOverdue) overdueBillCount++;
  }

  // Calculate collected this month
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final payments = await billingRepo.getPaymentsInDateRange(startOfMonth, now);
  final totalCollected = payments.fold<double>(0, (sum, p) => sum + p.amount);

  // Calculate room stats
  int totalRooms = 0;
  int occupiedRooms = 0;

  for (final property in properties) {
    totalRooms += property.roomCount;
    occupiedRooms += property.occupiedRoomCount;
  }

  return DashboardSummary(
    totalDue: totalDue,
    totalCollected: totalCollected,
    unpaidBillCount: unpaidBills.length,
    overdueBillCount: overdueBillCount,
    totalProperties: properties.length,
    totalRooms: totalRooms,
    occupiedRooms: occupiedRooms,
  );
}

/// Watch landlord profile.
@riverpod
Stream<Landlord?> landlordStream(Ref ref) {
  final repo = ref.watch(landlordRepositoryProvider);
  return repo.watchLandlord();
}

/// Check if is first launch (no landlord profile).
@riverpod
Future<bool> isFirstLaunch(Ref ref) async {
  final repo = ref.watch(landlordRepositoryProvider);
  return !(await repo.hasLandlordProfile());
}

/// Get landlord profile.
@riverpod
Future<Landlord?> landlord(Ref ref) {
  final repo = ref.watch(landlordRepositoryProvider);
  return repo.getLandlord();
}

/// Selected dashboard month.
@riverpod
class DashboardMonth extends _$DashboardMonth {
  @override
  DateTime build() => DateTime.now();

  void setMonth(DateTime month) {
    state = month;
  }
}

/// Filtered financial summary data.
class FilteredFinancialSummary {
  final double collected;
  final double pending;
  final int overdueCount;
  final DateTime month;

  const FilteredFinancialSummary({
    required this.collected,
    required this.pending,
    required this.overdueCount,
    required this.month,
  });
}

/// Provides financial summary filtered by month.
@riverpod
Future<FilteredFinancialSummary> filteredFinancials(Ref ref) async {
  final month = ref.watch(dashboardMonthProvider);
  final billingRepo = ref.watch(billingRepositoryProvider);
  final unpaidBills = await ref.watch(unpaidBillsProvider.future);

  // Calculate collected for the selected month
  final startOfMonth = DateTime(month.year, month.month, 1);
  final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

  final payments = await billingRepo.getPaymentsInDateRange(
    startOfMonth,
    endOfMonth,
  );
  final totalCollected = payments.fold<double>(0, (sum, p) => sum + p.amount);

  // Calculate pending (Global pending is usually more relevant,
  // but if we want strictly "for this month's bills", we'd filter bills.
  // For now, based on "Collected vs Pending" usually meaning "Cash in vs Cash due",
  // we will show TOTAL pending because that's what needs attention regardless of month.
  // However, the prompt implies filtering. Let's stick to Total Pending for the "Right" side
  // because "Pending: 15,000" usually implies total debt.)

  double totalDue = 0;
  int overdueCount = 0;
  for (final bill in unpaidBills) {
    totalDue += bill.pendingAmount;
    if (bill.isOverdue) overdueCount++;
  }

  return FilteredFinancialSummary(
    collected: totalCollected,
    pending: totalDue,
    overdueCount: overdueCount,
    month: month,
  );
}

/// Start of "Live Status" data structures
enum RoomStatusType {
  paid, // Green
  dueSoon, // Yellow
  overdue, // Red
}

class RoomStatusItem {
  final int roomId;
  final String roomNumber;
  final String tenantName;
  final RoomStatusType status;
  final String statusLabel;

  const RoomStatusItem({
    required this.roomId,
    required this.roomNumber,
    required this.tenantName,
    required this.status,
    required this.statusLabel,
  });
}

/// Provides list of rooms with their status.
@riverpod
Future<List<RoomStatusItem>> roomStatusList(Ref ref) async {
  // Watch streams to auto-refresh
  ref.watch(propertiesStreamProvider);
  // Watch unpaid bills to update status when bills change
  // Note: unpaidBillsProvider is auto-refreshing periodically via its own implementation or when we invalidate it
  final unpaidBills = await ref.watch(unpaidBillsProvider.future);
  final rooms = await ref.watch(allRoomsProvider.future);

  // Filter only occupied rooms for "Live Status"
  final activeRooms = rooms.where((r) => r.isOccupied).toList();

  // Sort by room number alphanumerically roughly
  activeRooms.sort((a, b) => a.roomNumber.compareTo(b.roomNumber));

  return activeRooms.map((room) {
    // Check for unpaid bills
    final roomBills = unpaidBills
        .where((b) => b.occupancyId == room.currentOccupancyId)
        .toList();

    RoomStatusType status = RoomStatusType.paid;
    String label = 'Paid';

    if (roomBills.isNotEmpty) {
      status = RoomStatusType.overdue; // Using overdue for "Red" generically
      label = 'Due';
      if (roomBills.any((b) => b.isOverdue)) {
        label = 'Overdue';
      }
    } else {
      // Logic for Yellow (Cycle ending soon) can be added here
      status = RoomStatusType.paid;
      label = 'Paid';
    }

    return RoomStatusItem(
      roomId: room.id,
      roomNumber: room.roomNumber,
      tenantName: room.currentTenantName ?? 'Unknown',
      status: status,
      statusLabel: label,
    );
  }).toList();
}
