/// Billing Data Access Object.
library;

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/bill_table.dart';
import '../tables/payment_table.dart';
import '../tables/electricity_rate_table.dart';
import '../tables/meter_photo_table.dart';
import '../tables/audit_log_table.dart';
import '../tables/message_template_table.dart';

part 'billing_dao.g.dart';

/// DAO for billing and payment operations.
@DriftAccessor(tables: [Bills, Payments, ElectricityRates, MeterPhotos])
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

  /// Get payment by ID
  Future<PaymentEntity?> getPaymentById(int id) =>
      (select(payments)..where((p) => p.id.equals(id))).getSingleOrNull();

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
    // Only fetch bills that are not fully paid or voided
    final candidateBills = await (select(bills)
          ..where((b) => b.status.isNotIn([
                BillStatus.paid.name,
                BillStatus.voided.name,
              ])))
        .get();
        
    final unpaid = <({BillEntity bill, double pendingAmount})>[];

    for (final bill in candidateBills) {
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

  // ========== Meter Photo Operations ==========

  /// Get meter photos for a bill
  Future<List<MeterPhotoEntity>> getMeterPhotosForBill(int billId) =>
      (select(meterPhotos)..where((m) => m.billId.equals(billId))).get();

  /// Insert a meter photo
  Future<int> insertMeterPhoto(MeterPhotosCompanion photo) =>
      into(meterPhotos).insert(photo);

  /// Delete a meter photo
  Future<int> deleteMeterPhoto(int id) =>
      (delete(meterPhotos)..where((m) => m.id.equals(id))).go();

  /// Delete all photos for a bill
  Future<int> deleteMeterPhotosForBill(int billId) =>
      (delete(meterPhotos)..where((m) => m.billId.equals(billId))).go();

  /// Count photos for a bill
  Future<int> countMeterPhotosForBill(int billId) async {
    final photos = await getMeterPhotosForBill(billId);
    return photos.length;
  }

  // ========== Bill Number Generation ==========

  /// Generate next bill number for given month/year.
  /// Format: INV-YYYYMM-XXXX (sequential per month)
  Future<String> generateBillNumber(int month, int year) async {
    // Default prefix, can be made configurable from bill settings
    const prefix = 'INV';
    final monthStr = month.toString().padLeft(2, '0');
    final billPrefix = '$prefix-$year$monthStr-';

    // Query max existing number for this prefix
    final existingBills =
        await (select(bills)
              ..where((b) => b.billNumber.like('$billPrefix%'))
              ..orderBy([(b) => OrderingTerm.desc(b.billNumber)])
              ..limit(1))
            .get();

    int nextSeq = 1;
    if (existingBills.isNotEmpty) {
      final lastNumber = existingBills.first.billNumber;
      if (lastNumber != null && lastNumber.startsWith(billPrefix)) {
        final seqPart = lastNumber.substring(billPrefix.length);
        nextSeq = (int.tryParse(seqPart) ?? 0) + 1;
      }
    }

    return '$billPrefix${nextSeq.toString().padLeft(4, '0')}';
  }

  // ========== Duplicate Prevention ==========

  /// Check if a bill already exists for the given occupancy, type, and period.
  /// Returns the existing bill if found, null otherwise.
  Future<BillEntity?> checkDuplicateBill({
    required int occupancyId,
    required BillType billType,
    required int billingMonth,
    required int billingYear,
  }) async {
    return (select(bills)
          ..where(
            (b) =>
                b.occupancyId.equals(occupancyId) &
                b.billType.equals(billType.name) &
                b.billingMonth.equals(billingMonth) &
                b.billingYear.equals(billingYear) &
                b.status.isNotIn([BillStatus.voided.name]),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  // ========== Bill Status Updates ==========

  /// Update bill status
  Future<bool> updateBillStatus(int billId, BillStatus status) async {
    return await (update(bills)..where((b) => b.id.equals(billId))).write(
          BillsCompanion(status: Value(status)),
        ) >
        0;
  }

  /// Recalculate and update bill status based on payments
  Future<void> recalculateBillStatus(int billId) async {
    final bill = await getBillById(billId);
    if (bill == null) return;

    final paidAmount = await getTotalPaidForBill(billId);
    BillStatus newStatus;

    if (paidAmount >= bill.amount) {
      newStatus = BillStatus.paid;
    } else if (paidAmount > 0) {
      newStatus = BillStatus.partial;
    } else if (bill.dueDate != null && DateTime.now().isAfter(bill.dueDate!)) {
      newStatus = BillStatus.overdue;
    } else {
      newStatus = bill.status == BillStatus.sent
          ? BillStatus.sent
          : BillStatus.draft;
    }

    if (newStatus != bill.status) {
      await updateBillStatus(billId, newStatus);
    }
  }

  // ========== Audit Log Operations ==========

  /// Insert an audit log entry
  Future<int> insertAuditLog({
    required AuditEntityType entityType,
    required int entityId,
    required AuditAction action,
    String? fieldName,
    String? oldValue,
    String? newValue,
    String? notes,
  }) async {
    return into(db.auditLogs).insert(
      AuditLogsCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        action: action,
        fieldName: Value(fieldName),
        oldValue: Value(oldValue),
        newValue: Value(newValue),
        notes: Value(notes),
      ),
    );
  }

  /// Get audit logs for an entity
  Future<List<AuditLogEntity>> getAuditLogsForEntity({
    required AuditEntityType entityType,
    required int entityId,
  }) async {
    return (select(db.auditLogs)
          ..where(
            (a) =>
                a.entityType.equals(entityType.name) &
                a.entityId.equals(entityId),
          )
          ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]))
        .get();
  }

  // ========== Bill Settings Operations ==========

  /// Get bill settings (singleton row)
  Future<BillSettingsEntity?> getBillSettings() async {
    return (select(db.billSettings)..limit(1)).getSingleOrNull();
  }

  /// Update bill settings
  Future<bool> updateBillSettings(BillSettingsCompanion settings) async {
    // Ensure there's a row
    final existing = await getBillSettings();
    if (existing == null) {
      await into(db.billSettings).insert(BillSettingsCompanion.insert());
    }

    return await (update(
          db.billSettings,
        )).write(settings.copyWith(updatedAt: Value(DateTime.now()))) >
        0;
  }

  // ========== Message Template Operations ==========

  /// Get all message templates
  Future<List<MessageTemplateEntity>> getAllMessageTemplates() async {
    return select(db.messageTemplates).get();
  }

  /// Get templates by type
  Future<List<MessageTemplateEntity>> getTemplatesByType(
    TemplateType type,
  ) async {
    return (select(
      db.messageTemplates,
    )..where((t) => t.templateType.equals(type.name))).get();
  }

  /// Get default template for type
  Future<MessageTemplateEntity?> getDefaultTemplate(TemplateType type) async {
    return (select(db.messageTemplates)
          ..where(
            (t) => t.templateType.equals(type.name) & t.isDefault.equals(true),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  /// Insert message template
  Future<int> insertMessageTemplate(MessageTemplatesCompanion template) async {
    return into(db.messageTemplates).insert(template);
  }

  /// Update message template
  Future<bool> updateMessageTemplate(
    int id,
    MessageTemplatesCompanion template,
  ) async {
    return await (update(
          db.messageTemplates,
        )..where((t) => t.id.equals(id))).write(template) >
        0;
  }

  /// Delete message template
  Future<int> deleteMessageTemplate(int id) async {
    return (delete(db.messageTemplates)..where((t) => t.id.equals(id))).go();
  }
}
