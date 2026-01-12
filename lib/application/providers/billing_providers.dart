/// Billing-related providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/payment.dart';
import 'repository_providers.dart';

part 'billing_providers.g.dart';

/// Watch all bills (auto-updates).
@riverpod
Stream<List<Bill>> billsStream(BillsStreamRef ref) {
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
Future<List<Bill>> bills(BillsRef ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getAllBills();
}

/// Get bills for an occupancy.
/// Auto-refreshes by watching the stream.
@riverpod
Future<List<Bill>> billsForOccupancy(BillsForOccupancyRef ref, int occupancyId) {
  // Watch the stream to auto-refresh
  ref.watch(billsForOccupancyStreamProvider(occupancyId));
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getBillsForOccupancy(occupancyId);
}

/// Watch bills for an occupancy (auto-updates).
@riverpod
Stream<List<Bill>> billsForOccupancyStream(
  BillsForOccupancyStreamRef ref,
  int occupancyId,
) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.watchBillsForOccupancy(occupancyId);
}

/// Get a single bill by ID.
@riverpod
Future<Bill?> bill(BillRef ref, int id) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getBillById(id);
}

/// Get last electricity bill for auto-fill.
@riverpod
Future<Bill?> lastElectricityBill(LastElectricityBillRef ref, int occupancyId) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getLastElectricityBill(occupancyId);
}

/// Get payments for a bill.
/// Auto-refreshes by watching the stream.
@riverpod
Future<List<Payment>> paymentsForBill(PaymentsForBillRef ref, int billId) {
  // Watch the stream to auto-refresh
  ref.watch(paymentsForBillStreamProvider(billId));
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getPaymentsForBill(billId);
}

/// Watch payments for a bill (auto-updates).
@riverpod
Stream<List<Payment>> paymentsForBillStream(
  PaymentsForBillStreamRef ref,
  int billId,
) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.watchPaymentsForBill(billId);
}

/// Get unpaid bills.
/// Auto-refreshes via periodic check.
@riverpod
Future<List<Bill>> unpaidBills(UnpaidBillsRef ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getUnpaidBills();
}

/// Get current electricity rate.
@riverpod
Future<double> currentElectricityRate(CurrentElectricityRateRef ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getCurrentElectricityRate();
}
