import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_khata/core/utils/validators.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('Validators', () {
    group('validatePhone', () {
      test('returns error for null or empty', () {
        expect(validatePhone(null, l10n), 'Phone number is required');
        expect(validatePhone('', l10n), 'Phone number is required');
      });

      test('validates correct 10-digit Indian phone numbers', () {
        expect(validatePhone('9876543210', l10n), isNull);
        expect(validatePhone('6123456789', l10n), isNull); // Valid starts with 6-9
      });

      test('validates phone numbers with spaces or dashes', () {
        expect(validatePhone('98765 43210', l10n), isNull);
        expect(validatePhone('987-654-3210', l10n), isNull);
      });

      test('returns error for invalid lengths or formats', () {
        expect(validatePhone('1234567890', l10n), 'Enter a valid 10-digit phone number'); // Starts with 1
        expect(validatePhone('987654321', l10n), 'Enter a valid 10-digit phone number'); // 9 digits
        expect(validatePhone('98765432100', l10n), 'Enter a valid 10-digit phone number'); // 11 digits
        expect(validatePhone('98765abcde', l10n), 'Enter a valid 10-digit phone number');
      });
    });

    group('validateUpiId', () {
      test('returns null for empty (optional)', () {
        expect(validateUpiId(null, l10n), isNull);
        expect(validateUpiId('', l10n), isNull);
      });

      test('validates correct UPI IDs', () {
        expect(validateUpiId('user@upi', l10n), isNull);
        expect(validateUpiId('john.doe@okicici', l10n), isNull);
        expect(validateUpiId('9876543210@paytm', l10n), isNull);
        expect(validateUpiId('user-name@sbi', l10n), isNull);
      });

      test('returns error for invalid UPI IDs', () {
        expect(validateUpiId('userupi', l10n), 'Enter a valid UPI ID (e.g., name@upi)');
        expect(validateUpiId('user@', l10n), 'Enter a valid UPI ID (e.g., name@upi)');
        expect(validateUpiId('@upi', l10n), 'Enter a valid UPI ID (e.g., name@upi)');
      });
    });

    group('validateAadhar', () {
      test('returns null for empty (optional)', () {
        expect(validateAadhar(null, l10n), isNull);
        expect(validateAadhar('', l10n), isNull);
      });

      test('validates correct 12-digit Aadhar numbers', () {
        expect(validateAadhar('123456789012', l10n), isNull);
        expect(validateAadhar('1234 5678 9012', l10n), isNull);
        expect(validateAadhar('1234-5678-9012', l10n), isNull);
      });

      test('returns error for invalid Aadhar formats', () {
        expect(validateAadhar('12345678901', l10n), 'Enter a valid 12-digit Aadhar number'); // 11 digits
        expect(validateAadhar('1234567890123', l10n), 'Enter a valid 12-digit Aadhar number'); // 13 digits
        expect(validateAadhar('12345678abcd', l10n), 'Enter a valid 12-digit Aadhar number'); // non-numeric
      });
    });

    group('validateRequired', () {
      test('returns error for empty or whitespace', () {
        expect(validateRequired(null, l10n), 'Required is required');
        expect(validateRequired('', l10n), 'Required is required');
        expect(validateRequired('   ', l10n), 'Required is required');
      });

      test('returns custom field name in error', () {
        expect(validateRequired('', l10n, 'Name'), 'Name is required');
      });

      test('returns null for valid input', () {
        expect(validateRequired('text', l10n), isNull);
      });
    });

    group('validatePositiveNumber', () {
      test('returns error for empty', () {
        expect(validatePositiveNumber(null, l10n), 'Required is required');
        expect(validatePositiveNumber('', l10n), 'Required is required');
      });

      test('validates positive numbers', () {
        expect(validatePositiveNumber('0', l10n), isNull);
        expect(validatePositiveNumber('10', l10n), isNull);
        expect(validatePositiveNumber('10.5', l10n), isNull);
      });

      test('returns error for negative or invalid numbers', () {
        expect(validatePositiveNumber('-5', l10n), 'Enter a valid positive number');
        expect(validatePositiveNumber('abc', l10n), 'Enter a valid positive number');
      });
    });
  });
}
