import 'package:flutter_test/flutter_test.dart';
import 'package:rent_khata/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    group('formatCurrency', () {
      test('formats standard numbers correctly', () {
        expect(formatCurrency(100), '₹100');
        expect(formatCurrency(1000), '₹1,000');
        expect(formatCurrency(100000), '₹1,00,000'); // Indian formatting
        expect(formatCurrency(10000000), '₹1,00,00,000');
      });

      test('removes decimals', () {
        expect(formatCurrency(100.50), '₹101'); // Rounds by default with 0 decimal digits
        expect(formatCurrency(100.49), '₹100');
      });

      test('formats zero and negative correctly', () {
        expect(formatCurrency(0), '₹0');
        expect(formatCurrency(-1500), '-₹1,500');
      });
    });

    group('formatCurrencyWithDecimals', () {
      test('formats numbers with 2 decimals correctly', () {
        expect(formatCurrencyWithDecimals(100), '₹100.00');
        expect(formatCurrencyWithDecimals(1000.5), '₹1,000.50');
        expect(formatCurrencyWithDecimals(100000.99), '₹1,00,000.99');
      });
    });

    group('parseCurrency', () {
      test('parses standard numbers', () {
        expect(parseCurrency('100'), 100.0);
        expect(parseCurrency('100.50'), 100.5);
      });

      test('parses formatted strings correctly', () {
        expect(parseCurrency('₹1,00,000'), 100000.0);
        expect(parseCurrency('₹ 1,500.50'), 1500.5);
        expect(parseCurrency('1,23,456'), 123456.0);
      });

      test('returns null for invalid inputs', () {
        expect(parseCurrency('abc'), isNull);
        expect(parseCurrency('₹abc'), isNull);
      });
    });
  });
}
