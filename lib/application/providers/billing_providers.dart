/// Billing-related providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/message_template.dart';
import '../../domain/entities/payment.dart';
import '../../services/template_service.dart';
import 'repository_providers.dart';
import 'database_provider.dart';

part 'billing_providers.g.dart';

/// Get bill settings from database.
/// Returns cached settings, auto-refreshes from stream.
@riverpod
Future<BillSettingsEntity> billSettings(Ref ref) async {
  // Watch the stream to auto-refresh
  ref.watch(billSettingsStreamProvider);
  final db = ref.watch(appDatabaseProvider);
  final settings = await db.select(db.billSettings).getSingleOrNull();
  if (settings != null) return settings;

  // Return defaults if not found
  return BillSettingsEntity(
    id: 1,
    billNumberPrefix: 'INV',
    dueDateOffsetDays: 5,
    dueSoonThresholdDays: 5,
    autoReminders: true,
    rentUsesAnniversary: true,
    electricityUsesAnniversary: true,
    waterUsesAnniversary: false,
    maintenanceUsesAnniversary: false,
    otherUsesAnniversary: false,
    updatedAt: DateTime.now(),
  );
}

/// Stream bill settings for auto-refresh.
@riverpod
Stream<BillSettingsEntity?> billSettingsStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.billSettings).watchSingleOrNull();
}

/// Check if a bill type should use anniversary-based cycles.
@riverpod
Future<bool> shouldUseAnniversary(Ref ref, BillType billType) async {
  final settings = await ref.watch(billSettingsProvider.future);
  return switch (billType) {
    BillType.rent => settings.rentUsesAnniversary,
    BillType.electricity => settings.electricityUsesAnniversary,
    BillType.water => settings.waterUsesAnniversary,
    BillType.maintenance => settings.maintenanceUsesAnniversary,
    BillType.other => settings.otherUsesAnniversary,
  };
}

@riverpod
Stream<List<Bill>> billsStream(Ref ref) {
  // There's no direct stream for all bills in repository,
  // but we can create one by watching unpaid bills
  final repo = ref.watch(billingRepositoryProvider);
  // Return a stream that updates periodically
  return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    return repo.getAllBills();
  });
}

/// Get all bills.
/// Auto-refreshes when the stream emits.
@riverpod
Future<List<Bill>> bills(Ref ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getAllBills();
}

/// Get bills for an occupancy.
/// Auto-refreshes by watching the stream.
@riverpod
Future<List<Bill>> billsForOccupancy(Ref ref, int occupancyId) {
  // Watch the stream to auto-refresh
  ref.watch(billsForOccupancyStreamProvider(occupancyId));
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getBillsForOccupancy(occupancyId);
}

/// Watch bills for an occupancy (auto-updates).
@riverpod
Stream<List<Bill>> billsForOccupancyStream(Ref ref, int occupancyId) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.watchBillsForOccupancy(occupancyId);
}

/// Get a single bill by ID.
@riverpod
Future<Bill?> bill(Ref ref, int id) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getBillById(id);
}

/// Get a bill by ID with auto-refresh (watches occupancy stream for updates).
@riverpod
Future<Bill?> billById(Ref ref, int id) async {
  // Get the bill first to know its occupancy
  final repo = ref.watch(billingRepositoryProvider);
  final bill = await repo.getBillById(id);
  if (bill != null) {
    // Watch the occupancy bills stream to auto-refresh
    ref.watch(billsForOccupancyStreamProvider(bill.occupancyId));
  }
  return repo.getBillById(id);
}

/// Get last electricity bill for auto-fill.
@riverpod
Future<Bill?> lastElectricityBill(Ref ref, int occupancyId) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getLastElectricityBill(occupancyId);
}

/// Get payments for a bill.
/// Auto-refreshes by watching the stream.
@riverpod
Future<List<Payment>> paymentsForBill(Ref ref, int billId) {
  // Watch the stream to auto-refresh
  ref.watch(paymentsForBillStreamProvider(billId));
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getPaymentsForBill(billId);
}

/// Watch payments for a bill (auto-updates).
@riverpod
Stream<List<Payment>> paymentsForBillStream(Ref ref, int billId) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.watchPaymentsForBill(billId);
}

/// Get unpaid bills.
/// Auto-refreshes via periodic check.
@riverpod
Future<List<Bill>> unpaidBills(Ref ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getUnpaidBills();
}

/// Get current electricity rate.
@riverpod
Future<double> currentElectricityRate(Ref ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getCurrentElectricityRate();
}

/// Get all message templates.
@riverpod
Future<List<MessageTemplate>> messageTemplates(Ref ref) async {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getAllMessageTemplates();
}

/// Get message templates by type.
@riverpod
Future<List<MessageTemplate>> messageTemplatesByType(
  Ref ref,
  TemplateType type,
) async {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getTemplatesByType(type);
}

/// Get audit logs for a bill.
@riverpod
Future<List<AuditLog>> auditLogsForBill(Ref ref, int billId) async {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getAuditLogsForBill(billId);
}

/// Get default message template for a type.
@riverpod
Future<MessageTemplate?> defaultTemplate(Ref ref, TemplateType type) async {
  final repo = ref.read(billingRepositoryProvider);
  return repo.getDefaultTemplate(type);
}

/// Provider for TemplateService.
@riverpod
TemplateService templateService(Ref ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return TemplateService(repo);
}

/// Ensures default templates exist. Call this during app initialization.
/// Returns true when complete.
@riverpod
Future<bool> ensureDefaultTemplates(Ref ref) async {
  final service = ref.watch(templateServiceProvider);
  await service.ensureDefaultTemplatesExist();
  return true;
}

// ============================================================================
// FINANCIAL YEAR REPORTING PROVIDERS
// ============================================================================

/// Selected Financial Year for Reports
@riverpod
class ReportsFinancialYear extends _$ReportsFinancialYear {
  @override
  int build() {
    final now = DateTime.now();
    // Indian Financial Year: April 1 to March 31
    return now.month >= 4 ? now.year : now.year - 1;
  }

  void setYear(int year) {
    state = year;
  }
}

/// Bills filtered by the Selected Financial Year
@riverpod
Future<List<Bill>> billsByFinancialYear(Ref ref) async {
  final startYear = ref.watch(reportsFinancialYearProvider);
  final repo = ref.watch(billingRepositoryProvider);
  final startDate = DateTime(startYear, 4, 1);
  final endDate = DateTime(startYear + 1, 3, 31, 23, 59, 59);

  // Auto-refresh via unpaidBillsProvider
  ref.watch(unpaidBillsProvider);

  final allBills = await repo.getAllBills();
  return allBills.where((b) {
    final bStart = b.periodStartDate ?? b.createdAt;
    final bEnd = b.periodEndDate ?? b.createdAt;
    return bStart.isBefore(endDate) && bEnd.isAfter(startDate);
  }).toList();
}

class YearlyFinancialSummary {
  final double collected;
  final double pending;
  final int overdueCount;
  final int year;

  const YearlyFinancialSummary({
    required this.collected,
    required this.pending,
    required this.overdueCount,
    required this.year,
  });
}

/// Aggregated Financial metrics by Financial Year
@riverpod
Future<YearlyFinancialSummary> yearlyFinancials(Ref ref) async {
  final year = ref.watch(reportsFinancialYearProvider);
  final billingRepo = ref.watch(billingRepositoryProvider);
  final allBills = await ref.watch(billsByFinancialYearProvider.future);

  final startYearDate = DateTime(year, 4, 1);
  final endYearDate = DateTime(year + 1, 3, 31, 23, 59, 59);

  // Payments collected within this FY
  final payments = await billingRepo.getPaymentsInDateRange(
    startYearDate,
    endYearDate,
  );
  final totalCollected = payments.fold<double>(0, (sum, p) => sum + p.amount);

  // Pending strictly from bills generated in this FY
  double totalDue = 0;
  int overdueCount = 0;
  for (final bill in allBills) {
    if (!bill.isFullyPaid) {
      totalDue += bill.pendingAmount;
      if (bill.isOverdue) overdueCount++;
    }
  }

  return YearlyFinancialSummary(
    collected: totalCollected,
    pending: totalDue,
    overdueCount: overdueCount,
    year: year,
  );
}
