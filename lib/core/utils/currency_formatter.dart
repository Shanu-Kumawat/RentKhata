/// Currency formatting utilities.
library;

import 'package:intl/intl.dart';

/// Format amount as Indian currency
String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

/// Format amount with decimals
String formatCurrencyWithDecimals(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

/// Parse currency string to double
double? parseCurrency(String value) {
  final cleaned = value.replaceAll(RegExp(r'[₹,\s]'), '');
  return double.tryParse(cleaned);
}
