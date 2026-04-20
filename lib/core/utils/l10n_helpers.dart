import 'package:rent_khata/l10n/app_localizations.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/payment.dart';

String getBillTypeLabel(AppLocalizations l10n, BillType type) {
  switch (type) {
    case BillType.rent:
      return l10n.rent;
    case BillType.electricity:
      return l10n.electricityBill;
    case BillType.water:
      return l10n.waterBill;
    case BillType.maintenance:
      return l10n.maintenance;
    case BillType.other:
      return l10n.otherCharges;
  }
}

String getPaymentModeLabel(AppLocalizations l10n, PaymentMode mode) {
  switch (mode) {
    case PaymentMode.cash:
      return l10n.cash;
    case PaymentMode.upi:
      return l10n.upi;
    case PaymentMode.bankTransfer:
      return l10n.bankTransfer;
    case PaymentMode.cheque:
      return l10n.cheque;
    case PaymentMode.other:
      return l10n.other;
  }
}
