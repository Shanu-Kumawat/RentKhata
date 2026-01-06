/// Billing-related providers.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/payment.dart';
import 'repository_providers.dart';

part 'billing_providers.g.dart';

/// Get all bills.
@riverpod
Future<List<Bill>> bills(BillsRef ref) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getAllBills();
}

/// Get bills for an occupancy.
@riverpod
Future<List<Bill>> billsForOccupancy(BillsForOccupancyRef ref, int occupancyId) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getBillsForOccupancy(occupancyId);
}

/// Watch bills for an occupancy.
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
@riverpod
Future<List<Payment>> paymentsForBill(PaymentsForBillRef ref, int billId) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.getPaymentsForBill(billId);
}

/// Watch payments for a bill.
@riverpod
Stream<List<Payment>> paymentsForBillStream(
  PaymentsForBillStreamRef ref,
  int billId,
) {
  final repo = ref.watch(billingRepositoryProvider);
  return repo.watchPaymentsForBill(billId);
}

/// Get unpaid bills.
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
