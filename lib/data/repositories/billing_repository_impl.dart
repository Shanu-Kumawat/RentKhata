/// Billing repository implementation.
library;

import 'package:drift/drift.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/billing_repository.dart';
import '../database/app_database.dart';
import '../database/daos/billing_dao.dart';
import '../database/daos/tenant_dao.dart';
import '../database/daos/property_dao.dart';
import '../database/tables/bill_table.dart' as db;
import '../database/tables/payment_table.dart' as db;

/// Implementation of [BillingRepository] using Drift database.
class BillingRepositoryImpl implements BillingRepository {
  final BillingDao _billingDao;
  final TenantDao _tenantDao;
  final PropertyDao _propertyDao;

  BillingRepositoryImpl(this._billingDao, this._tenantDao, this._propertyDao);

  /// Convert bill type from database to domain
  BillType _billTypeToDomain(db.BillType type) {
    switch (type) {
      case db.BillType.rent:
        return BillType.rent;
      case db.BillType.electricity:
        return BillType.electricity;
      case db.BillType.water:
        return BillType.water;
      case db.BillType.maintenance:
        return BillType.maintenance;
      case db.BillType.rentPlusElectricity:
        return BillType.rentPlusElectricity;
      case db.BillType.other:
        return BillType.other;
    }
  }

  /// Convert bill type from domain to database
  db.BillType _billTypeToDb(BillType type) {
    switch (type) {
      case BillType.rent:
        return db.BillType.rent;
      case BillType.electricity:
        return db.BillType.electricity;
      case BillType.water:
        return db.BillType.water;
      case BillType.maintenance:
        return db.BillType.maintenance;
      case BillType.rentPlusElectricity:
        return db.BillType.rentPlusElectricity;
      case BillType.other:
        return db.BillType.other;
    }
  }

  /// Convert payment mode from database to domain
  PaymentMode _paymentModeToDomain(db.PaymentMode mode) {
    switch (mode) {
      case db.PaymentMode.cash:
        return PaymentMode.cash;
      case db.PaymentMode.upi:
        return PaymentMode.upi;
      case db.PaymentMode.bankTransfer:
        return PaymentMode.bankTransfer;
      case db.PaymentMode.cheque:
        return PaymentMode.cheque;
      case db.PaymentMode.other:
        return PaymentMode.other;
    }
  }

  /// Convert payment mode from domain to database
  db.PaymentMode _paymentModeToDb(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash:
        return db.PaymentMode.cash;
      case PaymentMode.upi:
        return db.PaymentMode.upi;
      case PaymentMode.bankTransfer:
        return db.PaymentMode.bankTransfer;
      case PaymentMode.cheque:
        return db.PaymentMode.cheque;
      case PaymentMode.other:
        return db.PaymentMode.other;
    }
  }

  /// Convert bill entity to domain model with payment info
  Future<Bill> _billToDomain(BillEntity entity) async {
    final paidAmount = await _billingDao.getTotalPaidForBill(entity.id);
    final pendingAmount = entity.amount - paidAmount;

    // Get occupancy info for denormalized fields
    final occupancy = await _tenantDao.getActiveOccupancies().then(
      (list) => list.where((o) => o.id == entity.occupancyId).firstOrNull,
    );

    String? roomNumber;
    String? tenantName;
    String? propertyName;

    if (occupancy != null) {
      final room = await _propertyDao.getRoomById(occupancy.roomId);
      final tenant = await _tenantDao.getTenantById(occupancy.tenantId);
      roomNumber = room?.roomNumber;
      tenantName = tenant?.name;
      if (room != null) {
        final property = await _propertyDao.getPropertyById(room.propertyId);
        propertyName = property?.name;
      }
    }

    return Bill(
      id: entity.id,
      occupancyId: entity.occupancyId,
      billType: _billTypeToDomain(entity.billType),
      billingMonth: entity.billingMonth,
      billingYear: entity.billingYear,
      amount: entity.amount,
      electricityPrevReading: entity.electricityPrevReading,
      electricityCurrReading: entity.electricityCurrReading,
      electricityRateAtBilling: entity.electricityRateAtBilling,
      electricityCharges: entity.electricityCharges,
      meterPhotoPath: entity.meterPhotoPath,
      notes: entity.notes,
      createdAt: entity.createdAt,
      dueDate: entity.dueDate,
      periodStartDate: entity.periodStartDate,
      periodEndDate: entity.periodEndDate,
      paidAmount: paidAmount,
      pendingAmount: pendingAmount,
      roomNumber: roomNumber,
      tenantName: tenantName,
      propertyName: propertyName,
    );
  }

  /// Convert payment entity to domain model
  Payment _paymentToDomain(PaymentEntity entity) {
    return Payment(
      id: entity.id,
      billId: entity.billId,
      amount: entity.amount,
      paymentMode: _paymentModeToDomain(entity.paymentMode),
      notes: entity.notes,
      paymentDate: entity.paymentDate,
    );
  }

  // ========== Bill Operations ==========

  @override
  Future<List<Bill>> getAllBills() async {
    final entities = await _billingDao.getAllBills();
    return Future.wait(entities.map(_billToDomain));
  }

  @override
  Future<List<Bill>> getBillsForOccupancy(int occupancyId) async {
    final entities = await _billingDao.getBillsForOccupancy(occupancyId);
    return Future.wait(entities.map(_billToDomain));
  }

  @override
  Stream<List<Bill>> watchBillsForOccupancy(int occupancyId) {
    return _billingDao
        .watchBillsForOccupancy(occupancyId)
        .asyncMap((entities) => Future.wait(entities.map(_billToDomain)));
  }

  @override
  Future<Bill?> getBillById(int id) async {
    final entity = await _billingDao.getBillById(id);
    return entity != null ? _billToDomain(entity) : null;
  }

  @override
  Future<List<Bill>> getBillsForMonth(int month, int year) async {
    final entities = await _billingDao.getBillsForMonth(month, year);
    return Future.wait(entities.map(_billToDomain));
  }

  @override
  Future<Bill?> getLastElectricityBill(int occupancyId) async {
    final entity = await _billingDao.getLastElectricityBill(occupancyId);
    return entity != null ? _billToDomain(entity) : null;
  }

  @override
  Future<int> createBill({
    required int occupancyId,
    required BillType billType,
    required int billingMonth,
    required int billingYear,
    required double amount,
    double? electricityPrevReading,
    double? electricityCurrReading,
    double? electricityRateAtBilling,
    double? electricityCharges,
    String? meterPhotoPath,
    String? notes,
    DateTime? dueDate,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
  }) async {
    final bill = BillsCompanion(
      occupancyId: Value(occupancyId),
      billType: Value(_billTypeToDb(billType)),
      billingMonth: Value(billingMonth),
      billingYear: Value(billingYear),
      amount: Value(amount),
      electricityPrevReading: Value(electricityPrevReading),
      electricityCurrReading: Value(electricityCurrReading),
      electricityRateAtBilling: Value(electricityRateAtBilling),
      electricityCharges: Value(electricityCharges),
      meterPhotoPath: Value(meterPhotoPath),
      notes: Value(notes),
      dueDate: Value(dueDate),
      periodStartDate: Value(periodStartDate),
      periodEndDate: Value(periodEndDate),
    );
    return _billingDao.insertBill(bill);
  }

  @override
  Future<bool> updateBill(Bill bill) async {
    final entity = BillEntity(
      id: bill.id,
      occupancyId: bill.occupancyId,
      billType: _billTypeToDb(bill.billType),
      billingMonth: bill.billingMonth,
      billingYear: bill.billingYear,
      amount: bill.amount,
      electricityPrevReading: bill.electricityPrevReading,
      electricityCurrReading: bill.electricityCurrReading,
      electricityRateAtBilling: bill.electricityRateAtBilling,
      electricityCharges: bill.electricityCharges,
      meterPhotoPath: bill.meterPhotoPath,
      notes: bill.notes,
      createdAt: bill.createdAt,
      dueDate: bill.dueDate,
    );
    return _billingDao.updateBill(entity);
  }

  @override
  Future<bool> deleteBill(int id) async {
    final result = await _billingDao.deleteBill(id);
    return result > 0;
  }

  // ========== Payment Operations ==========

  @override
  Future<List<Payment>> getPaymentsForBill(int billId) async {
    final entities = await _billingDao.getPaymentsForBill(billId);
    return entities.map(_paymentToDomain).toList();
  }

  @override
  Stream<List<Payment>> watchPaymentsForBill(int billId) {
    return _billingDao
        .watchPaymentsForBill(billId)
        .map((entities) => entities.map(_paymentToDomain).toList());
  }

  @override
  Future<double> getTotalPaidForBill(int billId) async {
    return _billingDao.getTotalPaidForBill(billId);
  }

  @override
  Future<double> getPendingBalanceForBill(int billId) async {
    return _billingDao.getPendingBalanceForBill(billId);
  }

  @override
  Future<int> recordPayment({
    required int billId,
    required double amount,
    required PaymentMode paymentMode,
    String? notes,
    DateTime? paymentDate,
  }) async {
    final payment = PaymentsCompanion(
      billId: Value(billId),
      amount: Value(amount),
      paymentMode: Value(_paymentModeToDb(paymentMode)),
      notes: Value(notes),
      paymentDate: Value(paymentDate ?? DateTime.now()),
    );
    return _billingDao.insertPayment(payment);
  }

  @override
  Future<bool> deletePayment(int id) async {
    final result = await _billingDao.deletePayment(id);
    return result > 0;
  }

  // ========== Dashboard Queries ==========

  @override
  Future<List<Bill>> getUnpaidBills() async {
    final unpaidData = await _billingDao.getUnpaidBills();
    return Future.wait(unpaidData.map((data) => _billToDomain(data.bill)));
  }

  @override
  Future<List<Bill>> getBillsInDateRange(DateTime start, DateTime end) async {
    final entities = await _billingDao.getBillsInDateRange(start, end);
    return Future.wait(entities.map(_billToDomain));
  }

  @override
  Future<List<Payment>> getPaymentsInDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final entities = await _billingDao.getPaymentsInDateRange(start, end);
    return entities.map(_paymentToDomain).toList();
  }

  @override
  Future<double> getCurrentElectricityRate() async {
    final rate = await _billingDao.getCurrentElectricityRate();
    return rate?.ratePerUnit ?? 7.0;
  }

  @override
  Future<int> addElectricityRate(double rate, DateTime effectiveFrom) async {
    final rateEntry = ElectricityRatesCompanion(
      ratePerUnit: Value(rate),
      effectiveFrom: Value(effectiveFrom),
    );
    return _billingDao.insertElectricityRate(rateEntry);
  }
}
