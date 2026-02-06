/// Billing repository interface.
library;

import '../entities/audit_log.dart';
import '../entities/bill.dart';
import '../entities/message_template.dart';
import '../entities/payment.dart';

/// Abstract repository for billing operations.
abstract class BillingRepository {
  // ========== Bill Operations ==========

  /// Get all bills
  Future<List<Bill>> getAllBills();

  /// Get bills for an occupancy
  Future<List<Bill>> getBillsForOccupancy(int occupancyId);

  /// Watch bills for an occupancy
  Stream<List<Bill>> watchBillsForOccupancy(int occupancyId);

  /// Get bill by ID
  Future<Bill?> getBillById(int id);

  /// Get bills for a specific month
  Future<List<Bill>> getBillsForMonth(int month, int year);

  /// Get last electricity bill for auto-fetching previous reading
  Future<Bill?> getLastElectricityBill(int occupancyId);

  /// Create a new bill
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
  });

  /// Update a bill
  Future<bool> updateBill(Bill bill);

  /// Delete a bill
  Future<bool> deleteBill(int id);

  /// Mark bill as sent (Draft -> Sent)
  Future<bool> markBillAsSent(int id);

  /// Void a bill
  Future<bool> voidBill(int id, String reason);

  // ========== Payment Operations ==========

  /// Get payments for a bill
  Future<List<Payment>> getPaymentsForBill(int billId);

  /// Watch payments for a bill
  Stream<List<Payment>> watchPaymentsForBill(int billId);

  /// Get total paid amount for a bill
  Future<double> getTotalPaidForBill(int billId);

  /// Get pending balance for a bill
  Future<double> getPendingBalanceForBill(int billId);

  /// Record a payment
  Future<int> recordPayment({
    required int billId,
    required double amount,
    required PaymentMode paymentMode,
    String? notes,
    DateTime? paymentDate,
  });

  /// Update an existing payment
  Future<bool> updatePayment({
    required int paymentId,
    required double amount,
    required PaymentMode paymentMode,
    String? notes,
    DateTime? paymentDate,
  });

  /// Delete a payment
  Future<bool> deletePayment(int id);

  // ========== Dashboard Queries ==========

  /// Get all unpaid bills
  Future<List<Bill>> getUnpaidBills();

  /// Get bills in a date range
  Future<List<Bill>> getBillsInDateRange(DateTime start, DateTime end);

  /// Get payments in a date range
  Future<List<Payment>> getPaymentsInDateRange(DateTime start, DateTime end);

  /// Get current electricity rate
  Future<double> getCurrentElectricityRate();

  /// Add new electricity rate
  Future<int> addElectricityRate(double rate, DateTime effectiveFrom);

  // ========== Message Template Operations ==========

  /// Get all message templates
  Future<List<MessageTemplate>> getAllMessageTemplates();

  /// Get templates by type
  Future<List<MessageTemplate>> getTemplatesByType(TemplateType type);

  /// Get default template for type
  Future<MessageTemplate?> getDefaultTemplate(TemplateType type);

  /// Create a message template
  Future<int> createMessageTemplate({
    required TemplateType templateType,
    required String name,
    required String body,
    bool isDefault,
  });

  /// Update a message template
  Future<bool> updateMessageTemplate({
    required int id,
    String? name,
    String? body,
    bool? isDefault,
  });

  /// Delete a message template
  Future<int> deleteMessageTemplate(int id);

  // ========== Audit Log Operations ==========

  /// Get audit logs for a bill
  Future<List<AuditLog>> getAuditLogsForBill(int billId);

  /// Get audit logs for a payment
  Future<List<AuditLog>> getAuditLogsForPayment(int paymentId);
}
