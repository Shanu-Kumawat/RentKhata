/// Occupancy table definition.
library;

import 'package:drift/drift.dart';
import 'room_table.dart';
import 'tenant_table.dart';

import '../../../domain/entities/occupancy.dart';

/// Table for storing tenant-room occupancy relationships.
/// This is the join table that allows tenants to move between rooms.
@DataClassName('OccupancyEntity')
class Occupancies extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to room
  IntColumn get roomId => integer().references(Rooms, #id)();

  /// Foreign key to tenant
  IntColumn get tenantId => integer().references(Tenants, #id)();

  /// Move-in date
  DateTimeColumn get moveInDate => dateTime()();

  /// Move-out date (null if still active)
  DateTimeColumn get moveOutDate => dateTime().nullable()();

  /// Agreed monthly rent for this occupancy
  RealColumn get agreedRent => real()();

  /// Security deposit amount
  RealColumn get securityDeposit => real().withDefault(const Constant(0.0))();

  /// Whether this is the current active occupancy
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Deposit status
  TextColumn get depositStatus => textEnum<DepositStatus>().withDefault(
    Constant(DepositStatus.pending.name),
  )();

  /// Date deposit was received
  DateTimeColumn get depositReceivedDate => dateTime().nullable()();

  /// Date deposit was returned
  DateTimeColumn get depositReturnedDate => dateTime().nullable()();

  /// Amount returned (may differ from original if deductions)
  RealColumn get depositReturnedAmount => real().nullable()();

  /// Deduction amount from deposit (manual deductions like damages)
  RealColumn get deductionAmount => real().withDefault(const Constant(0.0))();

  /// Reason for deduction
  TextColumn get deductionReason => text().nullable()();

  /// Notes regarding settlement
  TextColumn get settlementNotes => text().nullable()();

  /// Whether the occupancy is fully settled (deposit returned/forfeited)
  BoolColumn get isSettled => boolean().withDefault(const Constant(false))();
}
