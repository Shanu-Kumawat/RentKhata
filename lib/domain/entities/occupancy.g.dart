// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occupancy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OccupancyImpl _$$OccupancyImplFromJson(Map<String, dynamic> json) =>
    _$OccupancyImpl(
      id: (json['id'] as num).toInt(),
      roomId: (json['roomId'] as num).toInt(),
      tenantId: (json['tenantId'] as num).toInt(),
      moveInDate: DateTime.parse(json['moveInDate'] as String),
      moveOutDate: json['moveOutDate'] == null
          ? null
          : DateTime.parse(json['moveOutDate'] as String),
      agreedRent: (json['agreedRent'] as num).toDouble(),
      securityDeposit: (json['securityDeposit'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
      depositStatus:
          $enumDecodeNullable(_$DepositStatusEnumMap, json['depositStatus']) ??
          DepositStatus.pending,
      depositReceivedDate: json['depositReceivedDate'] == null
          ? null
          : DateTime.parse(json['depositReceivedDate'] as String),
      depositReturnedDate: json['depositReturnedDate'] == null
          ? null
          : DateTime.parse(json['depositReturnedDate'] as String),
      depositReturnedAmount: (json['depositReturnedAmount'] as num?)
          ?.toDouble(),
      deductionAmount: (json['deductionAmount'] as num?)?.toDouble() ?? 0.0,
      deductionReason: json['deductionReason'] as String?,
      settlementNotes: json['settlementNotes'] as String?,
      isSettled: json['isSettled'] as bool? ?? false,
      billingStartDate: json['billingStartDate'] == null
          ? null
          : DateTime.parse(json['billingStartDate'] as String),
      roomNumber: json['roomNumber'] as String?,
      tenantName: json['tenantName'] as String?,
      propertyName: json['propertyName'] as String?,
    );

Map<String, dynamic> _$$OccupancyImplToJson(_$OccupancyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'tenantId': instance.tenantId,
      'moveInDate': instance.moveInDate.toIso8601String(),
      'moveOutDate': instance.moveOutDate?.toIso8601String(),
      'agreedRent': instance.agreedRent,
      'securityDeposit': instance.securityDeposit,
      'isActive': instance.isActive,
      'depositStatus': _$DepositStatusEnumMap[instance.depositStatus]!,
      'depositReceivedDate': instance.depositReceivedDate?.toIso8601String(),
      'depositReturnedDate': instance.depositReturnedDate?.toIso8601String(),
      'depositReturnedAmount': instance.depositReturnedAmount,
      'deductionAmount': instance.deductionAmount,
      'deductionReason': instance.deductionReason,
      'settlementNotes': instance.settlementNotes,
      'isSettled': instance.isSettled,
      'billingStartDate': instance.billingStartDate?.toIso8601String(),
      'roomNumber': instance.roomNumber,
      'tenantName': instance.tenantName,
      'propertyName': instance.propertyName,
    };

const _$DepositStatusEnumMap = {
  DepositStatus.pending: 'pending',
  DepositStatus.received: 'received',
  DepositStatus.partiallyReturned: 'partiallyReturned',
  DepositStatus.returned: 'returned',
};
