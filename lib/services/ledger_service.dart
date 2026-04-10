import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ledger.dart';
import '../../domain/entities/bill.dart';
import '../../domain/repositories/billing_repository.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../../domain/repositories/landlord_repository.dart';
import '../../application/providers/repository_providers.dart';

/// Provider for the Ledger Service
final ledgerServiceProvider = Provider<LedgerService>((ref) {
  return LedgerService(
    ref.read(billingRepositoryProvider),
    ref.read(tenantRepositoryProvider),
    ref.read(landlordRepositoryProvider),
  );
});

/// Future provider to fetch the Ledger Statement for a specific occupancy.
final ledgerStatementProvider =
    FutureProvider.family<LedgerStatement?, int>((ref, occupancyId) async {
  final service = ref.watch(ledgerServiceProvider);
  return await service.generateStatement(occupancyId);
});

class LedgerService {
  final BillingRepository _billingRepo;
  final TenantRepository _tenantRepo;
  final LandlordRepository _landlordRepo;

  LedgerService(this._billingRepo, this._tenantRepo, this._landlordRepo);

  Future<LedgerStatement?> generateStatement(int occupancyId) async {
    // 1. Fetch Occupancy Details
    final occupancy = await _tenantRepo.getOccupancyById(occupancyId);
    if (occupancy == null) return null;

    // 2. Fetch Landlord & Tenant Details
    final landlord = await _landlordRepo.getLandlord();
    final tenant = await _tenantRepo.getTenantById(occupancy.tenantId);

    // 3. Fetch Bills & Payments
    final bills = await _billingRepo.getBillsForOccupancy(occupancyId);
    final allEntries = <LedgerEntry>[];
    
    double totalBilled = 0;
    double totalPaid = 0;

    for (final bill in bills) {
      if (bill.status == BillStatus.voided) continue; // Skip voided bills completely
      
      // Add Bill as Debit
      totalBilled += bill.amount;
      allEntries.add(
        LedgerEntry(
          date: bill.createdAt, // Or bill.periodStartDate ?? bill.createdAt
          type: LedgerEntryType.billGenerated,
          description: 'Bill Generated: ${bill.billType.name.toUpperCase()} - ${bill.billingPeriod}',
          debit: bill.amount,
          credit: 0,
          balance: 0, // Computed later
          billId: bill.id,
          billType: bill.billType,
        ),
      );

      // Fetch payments for this bill
      final payments = await _billingRepo.getPaymentsForBill(bill.id);
      for (final pay in payments) {
        totalPaid += pay.amount;
        allEntries.add(
          LedgerEntry(
            date: pay.paymentDate,
            type: LedgerEntryType.paymentReceived,
            description: 'Payment Received: ${pay.paymentMode.name.toUpperCase()} - Ref: ${pay.notes ?? ""}'.trim(),
            debit: 0,
            credit: pay.amount,
            balance: 0, // Computed later
            paymentId: pay.id,
            paymentMode: pay.paymentMode,
          ),
        );
      }
    }

    // 4. Sort entries chronologically
    allEntries.sort((a, b) => a.date.compareTo(b.date));

    // 5. Calculate Running Balance
    double runningBalance = 0;
    final structuredEntries = <LedgerEntry>[];
    
    for (final entry in allEntries) {
      runningBalance += entry.debit;
      runningBalance -= entry.credit;

      structuredEntries.add(entry.copyWith(balance: runningBalance));
    }

    return LedgerStatement(
      occupancyId: occupancyId,
      tenantName: occupancy.tenantName ?? tenant?.name ?? 'Unknown Tenant',
      tenantPhone: tenant?.phone ?? '',
      roomNumber: occupancy.roomNumber ?? 'Unknown Room',
      propertyName: occupancy.propertyName ?? 'Unknown Property',
      landlordName: landlord?.name ?? 'Landlord',
      landlordPhone: landlord?.phone ?? '',
      moveInDate: occupancy.moveInDate,
      agreementEndDate: occupancy.agreementEndDate,
      statementDate: DateTime.now(),
      entries: structuredEntries,
      totalBilled: totalBilled,
      totalPaid: totalPaid,
      currentBalance: runningBalance,
    );
  }
}
