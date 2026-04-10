/// Occupancy domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'occupancy.freezed.dart';
part 'occupancy.g.dart';

/// Deposit status enumeration.
enum DepositStatus { pending, received, partiallyReturned, returned }

/// Represents a tenant's occupancy of a room.
@freezed
class Occupancy with _$Occupancy {
  const Occupancy._();

  const factory Occupancy({
    required int id,
    required int roomId,
    required int tenantId,
    required DateTime moveInDate,
    DateTime? moveOutDate,
    DateTime? agreementEndDate,
    required double agreedRent,
    @Default(0.0) double securityDeposit,
    @Default(true) bool isActive,
    // Deposit tracking
    @Default(DepositStatus.pending) DepositStatus depositStatus,
    DateTime? depositReceivedDate,
    DateTime? depositReturnedDate,
    double? depositReturnedAmount,
    // Settlement details
    @Default(0.0) double deductionAmount,
    String? deductionReason,
    String? settlementNotes,
    @Default(false) bool isSettled,
    // Billing start date - if null, uses moveInDate
    DateTime? billingStartDate,
    // Denormalized fields
    String? roomNumber,
    String? tenantName,
    String? propertyName,
  }) = _Occupancy;

  /// The date from which billing cycles should start.
  /// Falls back to moveInDate for backwards compatibility.
  DateTime get effectiveBillingStartDate => billingStartDate ?? moveInDate;

  factory Occupancy.fromJson(Map<String, dynamic> json) =>
      _$OccupancyFromJson(json);
}
