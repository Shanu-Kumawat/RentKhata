import 'package:rent_khata/l10n/app_localizations.dart';

/// Input validation utilities.

/// Validate phone number (Indian format)
String? validatePhone(String? value, AppLocalizations l10n) {
  if (value == null || value.isEmpty) {
    return l10n.validatePhoneRequired;
  }
  final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
    return l10n.validatePhoneInvalid;
  }
  return null;
}

/// Validate UPI ID
String? validateUpiId(String? value, AppLocalizations l10n) {
  if (value == null || value.isEmpty) {
    return null; // UPI is optional
  }
  if (!RegExp(r'^[\w.-]+@[\w]+$').hasMatch(value)) {
    return l10n.validateUpiInvalid;
  }
  return null;
}

/// Validate Aadhar number
String? validateAadhar(String? value, AppLocalizations l10n) {
  if (value == null || value.isEmpty) {
    return null; // Aadhar is optional
  }
  final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^\d{12}$').hasMatch(cleaned)) {
    return l10n.validateAadharInvalid;
  }
  return null;
}

/// Validate required field
String? validateRequired(String? value, AppLocalizations l10n, [String? fieldName]) {
  if (value == null || value.trim().isEmpty) {
    return l10n.validateRequiredField(fieldName ?? l10n.fieldRequired);
  }
  return null;
}

/// Validate positive number
String? validatePositiveNumber(String? value, AppLocalizations l10n) {
  if (value == null || value.isEmpty) {
    return l10n.validateRequiredField(l10n.fieldRequired);
  }
  final number = double.tryParse(value);
  if (number == null || number < 0) {
    return l10n.validatePositiveNumberInvalid;
  }
  return null;
}
