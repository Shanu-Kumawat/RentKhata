/// Payment domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// Payment mode enumeration.
enum PaymentMode {
  cash,
  upi,
  bankTransfer,
  cheque,
  other,
}

/// Represents a payment against a bill.
@freezed
class Payment with _$Payment {
  const factory Payment({
    required int id,
    required int billId,
    required double amount,
    required PaymentMode paymentMode,
    String? notes,
    required DateTime paymentDate,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}
