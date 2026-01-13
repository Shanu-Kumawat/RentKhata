/// Auto-billing service for automated bill generation.
library;

import '../domain/entities/bill.dart';
import '../domain/repositories/billing_repository.dart';

/// Service result from auto-billing operation.
class AutoBillingResult {
  final int totalGenerated;
  final int rentBills;
  final int electricityBills;
  final List<String> skipped;
  final List<String> errors;

  AutoBillingResult({
    required this.totalGenerated,
    required this.rentBills,
    required this.electricityBills,
    this.skipped = const [],
    this.errors = const [],
  });
}

/// Room billing settings for preview.
class RoomBillPreview {
  final int roomId;
  final String roomNumber;
  final String propertyName;
  final String tenantName;
  final int occupancyId;
  final double rentAmount;
  final bool canGenerateRent;
  final bool canGenerateElectricity;
  final String? skipReason;

  RoomBillPreview({
    required this.roomId,
    required this.roomNumber,
    required this.propertyName,
    required this.tenantName,
    required this.occupancyId,
    required this.rentAmount,
    required this.canGenerateRent,
    required this.canGenerateElectricity,
    this.skipReason,
  });
}

/// Service for auto-generating bills.
class AutoBillingService {
  final BillingRepository _billingRepo;

  AutoBillingService(this._billingRepo);

  /// Check if a bill already exists for the given occupancy, type, month, year.
  Future<bool> billExists({
    required int occupancyId,
    required BillType billType,
    required int month,
    required int year,
  }) async {
    final bills = await _billingRepo.getBillsForOccupancy(occupancyId);
    return bills.any(
      (b) =>
          b.billType == billType &&
          b.billingMonth == month &&
          b.billingYear == year,
    );
  }

  /// Generate a rent bill for an occupancy.
  Future<int?> generateRentBill({
    required int occupancyId,
    required int month,
    required int year,
    required double amount,
  }) async {
    // Check if already exists
    if (await billExists(
      occupancyId: occupancyId,
      billType: BillType.rent,
      month: month,
      year: year,
    )) {
      return null; // Already exists
    }

    // Calculate period dates
    final periodStart = DateTime(year, month, 1);
    final periodEnd = DateTime(year, month + 1, 0);
    final dueDate = periodStart.add(const Duration(days: 10));

    return await _billingRepo.createBill(
      occupancyId: occupancyId,
      billType: BillType.rent,
      billingMonth: month,
      billingYear: year,
      amount: amount,
      periodStartDate: periodStart,
      periodEndDate: periodEnd,
      dueDate: dueDate,
    );
  }

  /// Get current billing month and year.
  static ({int month, int year}) getCurrentBillingPeriod() {
    final now = DateTime.now();
    return (month: now.month, year: now.year);
  }

  /// Get previous billing month and year.
  static ({int month, int year}) getPreviousBillingPeriod() {
    final now = DateTime.now();
    final previous = DateTime(now.year, now.month - 1, 1);
    return (month: previous.month, year: previous.year);
  }

  /// Calculate pro-rata amount for partial month.
  static double calculateProRata({
    required double monthlyAmount,
    required int totalDaysInMonth,
    required int daysOccupied,
  }) {
    if (daysOccupied >= totalDaysInMonth) return monthlyAmount;
    return (monthlyAmount / totalDaysInMonth) * daysOccupied;
  }

  /// Get days in a month.
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
