/// Billing-related providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/message_template.dart';
import '../../domain/entities/payment.dart';
import 'repository_providers.dart';

part 'billing_providers.g.dart';

/// Watch all bills (auto-updates).
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
