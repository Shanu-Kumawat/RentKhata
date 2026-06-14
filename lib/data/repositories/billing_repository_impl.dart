/// Billing repository implementation.
library;

import 'package:drift/drift.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/message_template.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/billing_repository.dart';
import '../database/app_database.dart';
import '../database/daos/billing_dao.dart';
import '../database/daos/tenant_dao.dart';
import '../database/daos/property_dao.dart';
import '../database/tables/bill_table.dart' as db;
import '../database/tables/payment_table.dart' as db;
import '../database/tables/message_template_table.dart' as db;
import '../database/tables/audit_log_table.dart' as db_audit;

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
      case BillType.other:
        return db.BillType.other;
    }
  }

  /// Convert bill status from database to domain
  BillStatus _billStatusToDomain(db.BillStatus status) {
    switch (status) {
      case db.BillStatus.draft:
        return BillStatus.draft;
      case db.BillStatus.sent:
        return BillStatus.sent;
      case db.BillStatus.partial:
        return BillStatus.partial;
      case db.BillStatus.paid:
        return BillStatus.paid;
      case db.BillStatus.overdue:
        return BillStatus.overdue;
      case db.BillStatus.voided:
        return BillStatus.voided;
    }
  }

  /// Convert bill status from domain to database
  db.BillStatus _billStatusToDb(BillStatus status) {
    switch (status) {
      case BillStatus.draft:
        return db.BillStatus.draft;
      case BillStatus.sent:
        return db.BillStatus.sent;
      case BillStatus.partial:
        return db.BillStatus.partial;
      case BillStatus.paid:
        return db.BillStatus.paid;
      case BillStatus.overdue:
        return db.BillStatus.overdue;
      case BillStatus.voided:
        return db.BillStatus.voided;
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
      billNumber: entity.billNumber,
      status: _billStatusToDomain(entity.status),
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
    // Generate bill number
    final billNumber = await _billingDao.generateBillNumber(
      billingMonth,
      billingYear,
    );

    final bill = BillsCompanion(
      occupancyId: Value(occupancyId),
      billNumber: Value(billNumber),
      status: Value(db.BillStatus.draft),
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
    final billId = await _billingDao.insertBill(bill);

    // Log audit entry for bill creation
    await _billingDao.insertAuditLog(
      entityType: db_audit.AuditEntityType.bill,
      entityId: billId,
      action: db_audit.AuditAction.create,
      notes:
          'Bill created: ${billType.name} for $billingMonth/$billingYear, amount: $amount',
    );

    return billId;
  }

  @override
  Future<bool> updateBill(Bill bill) async {
    // Get old bill for diff logging
    final oldBill = await _billingDao.getBillById(bill.id);

    final entity = BillEntity(
      id: bill.id,
      occupancyId: bill.occupancyId,
      billNumber: bill.billNumber,
      status: _billStatusToDb(bill.status),
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
    final result = await _billingDao.updateBill(entity);

    // Log audit entry for bill update with diff
    if (result && oldBill != null) {
      final changes = <String>[];
      if (oldBill.amount != bill.amount) {
        changes.add('amount: ${oldBill.amount} → ${bill.amount}');
      }
      if (oldBill.status != _billStatusToDb(bill.status)) {
        changes.add('status: ${oldBill.status.name} → ${bill.status.name}');
      }
      if (oldBill.notes != bill.notes) {
        changes.add('notes updated');
      }

      // Track meter photo changes
      if (oldBill.meterPhotoPath != bill.meterPhotoPath) {
        if ((oldBill.meterPhotoPath == null ||
                oldBill.meterPhotoPath!.isEmpty) &&
            (bill.meterPhotoPath != null && bill.meterPhotoPath!.isNotEmpty)) {
          changes.add('meter photo added');
        } else if ((oldBill.meterPhotoPath != null &&
                oldBill.meterPhotoPath!.isNotEmpty) &&
            (bill.meterPhotoPath != null && bill.meterPhotoPath!.isNotEmpty)) {
          changes.add('meter photo updated');
        } else if ((oldBill.meterPhotoPath != null &&
                oldBill.meterPhotoPath!.isNotEmpty) &&
            (bill.meterPhotoPath == null || bill.meterPhotoPath!.isEmpty)) {
          changes.add('meter photo removed');
        }
      }

      await _billingDao.insertAuditLog(
        entityType: db_audit.AuditEntityType.bill,
        entityId: bill.id,
        action: db_audit.AuditAction.update,
        fieldName: changes.isNotEmpty ? 'multiple' : null,
        oldValue: oldBill.amount.toString(),
        newValue: bill.amount.toString(),
        notes: changes.isNotEmpty ? changes.join(', ') : 'Bill updated',
      );
    }

    return result;
  }

  @override
  Future<bool> deleteBill(int id) async {
    // Check if bill has payments
    final payments = await _billingDao.getPaymentsForBill(id);
    if (payments.isNotEmpty) {
      throw StateError('Cannot delete a bill that has recorded payments. Please delete the payments first.');
    }

    // Cascade delete meter photos
    await _billingDao.deleteMeterPhotosForBill(id);

    // Get bill info before deletion for audit
    final bill = await _billingDao.getBillById(id);

    final result = await _billingDao.deleteBill(id);

    // Log audit entry for bill deletion
    if (result > 0 && bill != null) {
      await _billingDao.insertAuditLog(
        entityType: db_audit.AuditEntityType.bill,
        entityId: id,
        action: db_audit.AuditAction.delete,
        notes:
            'Bill deleted: ${bill.billType.name} for ${bill.billingMonth}/${bill.billingYear}, amount: ${bill.amount}',
      );
    }

    return result > 0;
  }

  @override
  Future<bool> markBillAsSent(int id) async {
    final bill = await _billingDao.getBillById(id);
    if (bill == null) return false;

    // Only allow transition from Draft
    if (bill.status != db.BillStatus.draft) return false;

    final updated = await _billingDao.updateBillStatus(id, db.BillStatus.sent);

    if (updated) {
      await _billingDao.insertAuditLog(
        entityType: db_audit.AuditEntityType.bill,
        entityId: id,
        action: db_audit.AuditAction.update,
        oldValue: 'draft',
        newValue: 'sent',
        notes: 'Bill marked as sent',
      );
    }
    return updated;
  }

  @override
  Future<bool> voidBill(int id, String reason) async {
    final bill = await _billingDao.getBillById(id);
    if (bill == null) return false;

    // Don't allow voiding if already paid/partial
    if (bill.status == db.BillStatus.paid ||
        bill.status == db.BillStatus.partial) {
      return false;
    }

    final updated = await _billingDao.updateBillStatus(
      id,
      db.BillStatus.voided,
    );

    if (updated) {
      await _billingDao.insertAuditLog(
        entityType: db_audit.AuditEntityType.bill,
        entityId: id,
        action: db_audit.AuditAction.void_,
        oldValue: bill.status.name,
        newValue: 'voided',
        notes: 'Bill voided: $reason',
      );
    }
    return updated;
  }

  @override
  Future<bool> updateBillSettings(dynamic settings) async {
    return _billingDao.updateBillSettings(settings);
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
    final paymentId = await _billingDao.insertPayment(payment);

    // Recalculate bill status after payment
    await _billingDao.recalculateBillStatus(billId);

    // Log audit entry for payment
    await _billingDao.insertAuditLog(
      entityType: db_audit.AuditEntityType.payment,
      entityId: paymentId,
      action: db_audit.AuditAction.create,
      notes:
          'Payment recorded: $amount via ${paymentMode.name} for bill #$billId',
    );

    return paymentId;
  }

  @override
  Future<bool> updatePayment({
    required int paymentId,
    required double amount,
    required PaymentMode paymentMode,
    String? notes,
    DateTime? paymentDate,
  }) async {
    // Get billId from existing payment record by querying all bills
    int? billId;
    final allBills = await _billingDao.getAllBills();
    for (final bill in allBills) {
      final payments = await _billingDao.getPaymentsForBill(bill.id);
      if (payments.any((p) => p.id == paymentId)) {
        billId = bill.id;
        final oldP = payments.firstWhere((p) => p.id == paymentId);
        // Store old amount for audit
        final oldAmount = oldP.amount;

        final payment = PaymentsCompanion(
          id: Value(paymentId),
          amount: Value(amount),
          paymentMode: Value(_paymentModeToDb(paymentMode)),
          notes: Value(notes),
          paymentDate: Value(paymentDate ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          originalAmount: Value(oldAmount.toString()),
        );
        final result = await _billingDao.updatePayment(payment);

        if (result) {
          // Recalculate bill status
          await _billingDao.recalculateBillStatus(billId);

          // Log audit entry
          await _billingDao.insertAuditLog(
            entityType: db_audit.AuditEntityType.payment,
            entityId: paymentId,
            action: db_audit.AuditAction.update,
            oldValue: oldAmount.toString(),
            newValue: amount.toString(),
            notes: 'Payment updated: $oldAmount → $amount',
          );
        }
        return result;
      }
    }

    // Fallback if payment not found in any bill
    final payment = PaymentsCompanion(
      id: Value(paymentId),
      amount: Value(amount),
      paymentMode: Value(_paymentModeToDb(paymentMode)),
      notes: Value(notes),
      paymentDate: Value(paymentDate ?? DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    return _billingDao.updatePayment(payment);
  }

  @override
  Future<bool> deletePayment(int id) async {
    // Find the payment and its bill for audit and status update
    int? billId;
    double? oldAmount;
    final allBills = await _billingDao.getAllBills();
    for (final bill in allBills) {
      final payments = await _billingDao.getPaymentsForBill(bill.id);
      final payment = payments.where((p) => p.id == id).firstOrNull;
      if (payment != null) {
        billId = bill.id;
        oldAmount = payment.amount;
        break;
      }
    }

    final result = await _billingDao.deletePayment(id);

    if (result > 0) {
      // Recalculate bill status
      if (billId != null) {
        await _billingDao.recalculateBillStatus(billId);
      }

      // Log audit entry
      await _billingDao.insertAuditLog(
        entityType: db_audit.AuditEntityType.payment,
        entityId: id,
        action: db_audit.AuditAction.delete,
        notes:
            'Payment deleted: ${oldAmount ?? 'unknown'} from bill #${billId ?? 'unknown'}',
      );
    }

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
    // Get current rate for audit
    final currentRate = await _billingDao.getCurrentElectricityRate();

    final rateEntry = ElectricityRatesCompanion(
      ratePerUnit: Value(rate),
      effectiveFrom: Value(effectiveFrom),
    );
    final id = await _billingDao.insertElectricityRate(rateEntry);

    // Log audit entry for rate change
    await _billingDao.insertAuditLog(
      entityType: db_audit.AuditEntityType.electricityRate,
      entityId: id,
      action: db_audit.AuditAction.create,
      oldValue: currentRate?.ratePerUnit.toString(),
      newValue: rate.toString(),
      notes:
          'Electricity rate changed: ${currentRate?.ratePerUnit ?? 'none'} → $rate per unit',
    );

    return id;
  }

  // ========== Message Template Operations ==========

  /// Get all message templates
  @override
  Future<List<MessageTemplate>> getAllMessageTemplates() async {
    final entities = await _billingDao.getAllMessageTemplates();
    return entities.map(_messageTemplateToDomain).toList();
  }

  /// Get templates by type
  @override
  Future<List<MessageTemplate>> getTemplatesByType(TemplateType type) async {
    final dbType = _templateTypeToDb(type);
    final entities = await _billingDao.getTemplatesByType(dbType);
    return entities.map(_messageTemplateToDomain).toList();
  }

  /// Get default template for type
  @override
  Future<MessageTemplate?> getDefaultTemplate(TemplateType type) async {
    final dbType = _templateTypeToDb(type);
    final entity = await _billingDao.getDefaultTemplate(dbType);
    return entity != null ? _messageTemplateToDomain(entity) : null;
  }

  /// Create a message template
  @override
  Future<int> createMessageTemplate({
    required TemplateType templateType,
    required String name,
    required String body,
    bool isDefault = false,
  }) async {
    final template = MessageTemplatesCompanion(
      templateType: Value(_templateTypeToDb(templateType)),
      name: Value(name),
      body: Value(body),
      isDefault: Value(isDefault),
    );
    return _billingDao.insertMessageTemplate(template);
  }

  /// Update a message template
  @override
  Future<bool> updateMessageTemplate({
    required int id,
    String? name,
    String? body,
    bool? isDefault,
  }) async {
    final template = MessageTemplatesCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      body: body != null ? Value(body) : const Value.absent(),
      isDefault: isDefault != null ? Value(isDefault) : const Value.absent(),
    );
    return _billingDao.updateMessageTemplate(id, template);
  }

  /// Delete a message template
  @override
  Future<int> deleteMessageTemplate(int id) async {
    return _billingDao.deleteMessageTemplate(id);
  }

  // Helper methods for MessageTemplate
  MessageTemplate _messageTemplateToDomain(MessageTemplateEntity entity) {
    return MessageTemplate(
      id: entity.id,
      templateType: _templateTypeToDomain(entity.templateType),
      name: entity.name,
      body: entity.body,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
    );
  }

  TemplateType _templateTypeToDomain(db.TemplateType type) {
    return switch (type) {
      db.TemplateType.invoice => TemplateType.invoice,
      db.TemplateType.receipt => TemplateType.receipt,
    };
  }

  db.TemplateType _templateTypeToDb(TemplateType type) {
    return switch (type) {
      TemplateType.invoice => db.TemplateType.invoice,
      TemplateType.receipt => db.TemplateType.receipt,
    };
  }

  // ========== Audit Log Operations ==========

  @override
  Future<List<AuditLog>> getAuditLogsForBill(int billId) async {
    final entities = await _billingDao.getAuditLogsForEntity(
      entityType: db_audit.AuditEntityType.bill,
      entityId: billId,
    );
    return entities.map(_auditLogToDomain).toList();
  }

  @override
  Future<List<AuditLog>> getAuditLogsForPayment(int paymentId) async {
    final entities = await _billingDao.getAuditLogsForEntity(
      entityType: db_audit.AuditEntityType.payment,
      entityId: paymentId,
    );
    return entities.map(_auditLogToDomain).toList();
  }

  // Helper method for AuditLog conversion
  AuditLog _auditLogToDomain(AuditLogEntity entity) {
    return AuditLog(
      id: entity.id,
      entityType: _auditEntityTypeToDomain(entity.entityType),
      entityId: entity.entityId,
      action: _auditActionToDomain(entity.action),
      fieldName: entity.fieldName,
      oldValue: entity.oldValue,
      newValue: entity.newValue,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  AuditEntityType _auditEntityTypeToDomain(db_audit.AuditEntityType type) {
    return switch (type) {
      db_audit.AuditEntityType.bill => AuditEntityType.bill,
      db_audit.AuditEntityType.payment => AuditEntityType.payment,
      db_audit.AuditEntityType.electricityRate =>
        AuditEntityType.electricityRate,
    };
  }

  AuditAction _auditActionToDomain(db_audit.AuditAction action) {
    return switch (action) {
      db_audit.AuditAction.create => AuditAction.create,
      db_audit.AuditAction.update => AuditAction.update,
      db_audit.AuditAction.delete => AuditAction.delete,
      db_audit.AuditAction.void_ => AuditAction.void_,
    };
  }
}
