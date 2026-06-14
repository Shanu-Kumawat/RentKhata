import 'package:flutter_test/flutter_test.dart';
import 'package:rent_khata/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validatePhone', () {
      test('returns error for null or empty', () {
        expect(validatePhone(null), 'Phone number is required');
        expect(validatePhone(''), 'Phone number is required');
      });

      test('validates correct 10-digit Indian phone numbers', () {
        expect(validatePhone('9876543210'), isNull);
        expect(validatePhone('6123456789'), isNull); // Valid starts with 6-9
      });

      test('validates phone numbers with spaces or dashes', () {
        expect(validatePhone('98765 43210'), isNull);
        expect(validatePhone('987-654-3210'), isNull);
      });

      test('returns error for invalid lengths or formats', () {
        expect(validatePhone('1234567890'), 'Enter a valid 10-digit phone number'); // Starts with 1
        expect(validatePhone('987654321'), 'Enter a valid 10-digit phone number'); // 9 digits
        expect(validatePhone('98765432100'), 'Enter a valid 10-digit phone number'); // 11 digits
        expect(validatePhone('98765abcde'), 'Enter a valid 10-digit phone number');
      });
    });

    group('validateUpiId', () {
      test('returns null for empty (optional)', () {
        expect(validateUpiId(null), isNull);
        expect(validateUpiId(''), isNull);
      });

      test('validates correct UPI IDs', () {
        expect(validateUpiId('user@upi'), isNull);
        expect(validateUpiId('john.doe@okicici'), isNull);
        expect(validateUpiId('9876543210@paytm'), isNull);
        expect(validateUpiId('user-name@sbi'), isNull);
      });

      test('returns error for invalid UPI IDs', () {
        expect(validateUpiId('userupi'), 'Enter a valid UPI ID (e.g., name@upi)');
        expect(validateUpiId('user@'), 'Enter a valid UPI ID (e.g., name@upi)');
        expect(validateUpiId('@upi'), 'Enter a valid UPI ID (e.g., name@upi)');
      });
    });

    group('validateAadhar', () {
      test('returns null for empty (optional)', () {
        expect(validateAadhar(null), isNull);
        expect(validateAadhar(''), isNull);
      });

      test('validates correct 12-digit Aadhar numbers', () {
        expect(validateAadhar('123456789012'), isNull);
        expect(validateAadhar('1234 5678 9012'), isNull);
        expect(validateAadhar('1234-5678-9012'), isNull);
      });

      test('returns error for invalid Aadhar formats', () {
        expect(validateAadhar('12345678901'), 'Enter a valid 12-digit Aadhar number'); // 11 digits
        expect(validateAadhar('1234567890123'), 'Enter a valid 12-digit Aadhar number'); // 13 digits
        expect(validateAadhar('12345678abcd'), 'Enter a valid 12-digit Aadhar number'); // non-numeric
      });
    });

    group('validateRequired', () {
      test('returns error for empty or whitespace', () {
        expect(validateRequired(null), 'This field is required');
        expect(validateRequired(''), 'This field is required');
        expect(validateRequired('   '), 'This field is required');
      });

      test('returns custom field name in error', () {
        expect(validateRequired('', 'Name'), 'Name is required');
      });

      test('returns null for valid input', () {
        expect(validateRequired('text'), isNull);
      });
    });

    group('validatePositiveNumber', () {
      test('returns error for empty', () {
        expect(validatePositiveNumber(null), 'Value is required');
        expect(validatePositiveNumber(''), 'Value is required');
        expect(validatePositiveNumber('', 'Amount'), 'Amount is required');
      });

      test('validates positive numbers', () {
        expect(validatePositiveNumber('0'), isNull);
        expect(validatePositiveNumber('10'), isNull);
        expect(validatePositiveNumber('10.5'), isNull);
      });

      test('returns error for negative or invalid numbers', () {
        expect(validatePositiveNumber('-5'), 'Enter a valid positive number');
        expect(validatePositiveNumber('abc'), 'Enter a valid positive number');
      });
    });
  });
}
