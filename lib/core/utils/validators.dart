/// Input validation utilities.
library;

/// Validate phone number (Indian format)
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
    return 'Enter a valid 10-digit phone number';
  }
  return null;
}

/// Validate UPI ID
String? validateUpiId(String? value) {
  if (value == null || value.isEmpty) {
    return null; // UPI is optional
  }
  if (!RegExp(r'^[\w.-]+@[\w]+$').hasMatch(value)) {
    return 'Enter a valid UPI ID (e.g., name@upi)';
  }
  return null;
}

/// Validate Aadhar number
String? validateAadhar(String? value) {
  if (value == null || value.isEmpty) {
    return null; // Aadhar is optional
  }
  final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^\d{12}$').hasMatch(cleaned)) {
    return 'Enter a valid 12-digit Aadhar number';
  }
  return null;
}

/// Validate required field
String? validateRequired(String? value, [String fieldName = 'This field']) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

/// Validate positive number
String? validatePositiveNumber(String? value, [String fieldName = 'Value']) {
  if (value == null || value.isEmpty) {
    return '$fieldName is required';
  }
  final number = double.tryParse(value);
  if (number == null || number < 0) {
    return 'Enter a valid positive number';
  }
  return null;
}
