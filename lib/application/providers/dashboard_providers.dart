/// Dashboard-related providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/property.dart';
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

  double get collectionRate =>
      (totalDue + totalCollected) > 0
          ? (totalCollected / (totalDue + totalCollected)) * 100
          : 0;
}

/// Provides dashboard summary.
@riverpod
Future<DashboardSummary> dashboardSummary(DashboardSummaryRef ref) async {
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
Stream<Landlord?> landlordStream(LandlordStreamRef ref) {
  final repo = ref.watch(landlordRepositoryProvider);
  return repo.watchLandlord();
}

/// Check if is first launch (no landlord profile).
@riverpod
Future<bool> isFirstLaunch(IsFirstLaunchRef ref) async {
  final repo = ref.watch(landlordRepositoryProvider);
  return !(await repo.hasLandlordProfile());
}

/// Get landlord profile.
@riverpod
Future<Landlord?> landlord(LandlordRef ref) {
  final repo = ref.watch(landlordRepositoryProvider);
  return repo.getLandlord();
}
