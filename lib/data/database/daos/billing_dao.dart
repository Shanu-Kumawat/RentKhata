/// Billing Data Access Object.
library;

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/bill_table.dart';
import '../tables/payment_table.dart';
import '../tables/electricity_rate_table.dart';

part 'billing_dao.g.dart';

/// DAO for billing and payment operations.
@DriftAccessor(tables: [Bills, Payments, ElectricityRates])
class BillingDao extends DatabaseAccessor<AppDatabase> with _$BillingDaoMixin {
  BillingDao(super.db);

  // ========== Bill Operations ==========

  /// Get all bills
  Future<List<BillEntity>> getAllBills() => select(bills).get();

  /// Get bills for an occupancy
  Future<List<BillEntity>> getBillsForOccupancy(int occupancyId) =>
      (select(bills)
            ..where((b) => b.occupancyId.equals(occupancyId))
            ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
          .get();

  /// Watch bills for an occupancy
  Stream<List<BillEntity>> watchBillsForOccupancy(int occupancyId) =>
      (select(bills)
            ..where((b) => b.occupancyId.equals(occupancyId))
            ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
          .watch();

  /// Get bill by ID
  Future<BillEntity?> getBillById(int id) =>
      (select(bills)..where((b) => b.id.equals(id))).getSingleOrNull();

  /// Get bills for a month/year
  Future<List<BillEntity>> getBillsForMonth(int month, int year) =>
      (select(bills)..where(
            (b) => b.billingMonth.equals(month) & b.billingYear.equals(year),
          ))
          .get();

  /// Get last electricity bill for an occupancy (for fetching previous reading)
  Future<BillEntity?> getLastElectricityBill(int occupancyId) =>
      (select(bills)
            ..where(
              (b) =>
                  b.occupancyId.equals(occupancyId) &
                  b.billType.equals(BillType.electricity.name),
            )
            ..orderBy([(b) => OrderingTerm.desc(b.createdAt)])
            ..limit(1))
          .getSingleOrNull();

  /// Insert a bill
  Future<int> insertBill(BillsCompanion bill) => into(bills).insert(bill);

  /// Update a bill
  Future<bool> updateBill(BillEntity bill) => update(bills).replace(bill);

  /// Delete a bill
  Future<int> deleteBill(int id) =>
      (delete(bills)..where((b) => b.id.equals(id))).go();

  // ========== Payment Operations ==========

  /// Get payments for a bill
  Future<List<PaymentEntity>> getPaymentsForBill(int billId) =>
      (select(payments)
            ..where((p) => p.billId.equals(billId))
            ..orderBy([(p) => OrderingTerm.desc(p.paymentDate)]))
          .get();

  /// Watch payments for a bill
  Stream<List<PaymentEntity>> watchPaymentsForBill(int billId) =>
      (select(payments)
            ..where((p) => p.billId.equals(billId))
            ..orderBy([(p) => OrderingTerm.desc(p.paymentDate)]))
          .watch();

  /// Get total paid amount for a bill
  Future<double> getTotalPaidForBill(int billId) async {
    final paymentList = await getPaymentsForBill(billId);
    return paymentList.fold<double>(0.0, (double sum, p) => sum + p.amount);
  }

  /// Get pending balance for a bill
  Future<double> getPendingBalanceForBill(int billId) async {
    final bill = await getBillById(billId);
    if (bill == null) return 0.0;
    final paid = await getTotalPaidForBill(billId);
    return bill.amount - paid;
  }

  /// Insert a payment
  Future<int> insertPayment(PaymentsCompanion payment) =>
      into(payments).insert(payment);

  /// Update a payment
  Future<bool> updatePayment(PaymentsCompanion payment) async {
    return await (update(
          payments,
        )..where((p) => p.id.equals(payment.id.value))).write(payment) >
        0;
  }

  /// Delete a payment
  Future<int> deletePayment(int id) =>
      (delete(payments)..where((p) => p.id.equals(id))).go();

  // ========== Electricity Rate Operations ==========

  /// Get current electricity rate
  Future<ElectricityRateEntity?> getCurrentElectricityRate() =>
      (select(electricityRates)
            ..orderBy([(r) => OrderingTerm.desc(r.effectiveFrom)])
            ..limit(1))
          .getSingleOrNull();

  /// Get all electricity rates
  Future<List<ElectricityRateEntity>> getAllElectricityRates() => (select(
    electricityRates,
  )..orderBy([(r) => OrderingTerm.desc(r.effectiveFrom)])).get();

  /// Insert a new electricity rate
  Future<int> insertElectricityRate(ElectricityRatesCompanion rate) =>
      into(electricityRates).insert(rate);

  // ========== Dashboard Queries ==========

  /// Get all unpaid bills (bills with pending balance)
  Future<List<({BillEntity bill, double pendingAmount})>>
  getUnpaidBills() async {
    final allBills = await getAllBills();
    final unpaid = <({BillEntity bill, double pendingAmount})>[];

    for (final bill in allBills) {
      final pending = await getPendingBalanceForBill(bill.id);
      if (pending > 0) {
        unpaid.add((bill: bill, pendingAmount: pending));
      }
    }

    return unpaid;
  }

  /// Get bills for a date range
  Future<List<BillEntity>> getBillsInDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return (select(bills)
          ..where(
            (b) =>
                b.createdAt.isBiggerOrEqualValue(start) &
                b.createdAt.isSmallerOrEqualValue(end),
          )
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .get();
  }

  /// Get payments for a date range
  Future<List<PaymentEntity>> getPaymentsInDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return (select(payments)
          ..where(
            (p) =>
                p.paymentDate.isBiggerOrEqualValue(start) &
                p.paymentDate.isSmallerOrEqualValue(end),
          )
          ..orderBy([(p) => OrderingTerm.desc(p.paymentDate)]))
        .get();
  }
}
