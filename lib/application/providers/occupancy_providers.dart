/// Occupancy-related providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/occupancy.dart';
import '../../domain/entities/bill.dart';
import '../../data/database/app_database.dart';
import 'repository_providers.dart';
import 'database_provider.dart';

part 'occupancy_providers.g.dart';

/// Complete occupancy detail with all related data.
class OccupancyDetail {
  final Occupancy occupancy;
  final List<Bill> bills;
  final List<FamilyMemberEntity> familyMembers;
  final double totalBilled;
  final double totalPaid;
  final double totalPending;

  const OccupancyDetail({
    required this.occupancy,
    required this.bills,
    required this.familyMembers,
    required this.totalBilled,
    required this.totalPaid,
    required this.totalPending,
  });
}

/// Get occupancy by ID with room and tenant info.
@riverpod
Future<Occupancy?> occupancy(Ref ref, int occupancyId) async {
  final db = ref.watch(appDatabaseProvider);
  final entity = await db.tenantDao.getOccupancyById(occupancyId);
  if (entity == null) return null;

  // Get additional info
  final room = await db.propertyDao.getRoomById(entity.roomId);
  final tenant = await db.tenantDao.getTenantById(entity.tenantId);
  String? propertyName;
  if (room != null) {
    final property = await db.propertyDao.getPropertyById(room.propertyId);
    propertyName = property?.name;
  }

  return Occupancy(
    id: entity.id,
    roomId: entity.roomId,
    tenantId: entity.tenantId,
    moveInDate: entity.moveInDate,
    moveOutDate: entity.moveOutDate,
    agreedRent: entity.agreedRent,
    securityDeposit: entity.securityDeposit,
    isActive: entity.isActive,
    depositStatus: entity.depositStatus ?? DepositStatus.pending,
    depositReceivedDate: entity.depositReceivedDate,
    depositReturnedDate: entity.depositReturnedDate,
    depositReturnedAmount: entity.depositReturnedAmount,
    roomNumber: room?.roomNumber,
    tenantName: tenant?.name,
    propertyName: propertyName,
  );
}

/// Get complete occupancy detail with all related data.
@riverpod
Future<OccupancyDetail?> occupancyDetail(Ref ref, int occupancyId) async {
  final occ = await ref.watch(occupancyProvider(occupancyId).future);
  if (occ == null) return null;

  final db = ref.watch(appDatabaseProvider);
  final billingRepo = ref.watch(billingRepositoryProvider);

  // Get bills for this occupancy
  final bills = await billingRepo.getBillsForOccupancy(occupancyId);

  // Get family members for this occupancy
  final familyMembers = await db.tenantDao.getFamilyMembersForOccupancy(
    occupancyId,
  );

  // Calculate totals
  double totalBilled = 0;
  double totalPaid = 0;
  for (final bill in bills) {
    totalBilled += bill.amount;
    totalPaid += bill.paidAmount;
  }

  return OccupancyDetail(
    occupancy: occ,
    bills: bills,
    familyMembers: familyMembers,
    totalBilled: totalBilled,
    totalPaid: totalPaid,
    totalPending: totalBilled - totalPaid,
  );
}
