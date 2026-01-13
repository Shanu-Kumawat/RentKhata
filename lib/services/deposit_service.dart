/// Deposit service for managing security deposits.
library;

import '../domain/entities/occupancy.dart';

/// Service for deposit calculations and operations.
class DepositService {
  /// Calculate deposit balance for an occupancy.
  /// Returns: originalDeposit - deductions
  static double calculateBalance({
    required double originalDeposit,
    required List<double> deductions,
  }) {
    final totalDeductions = deductions.fold<double>(0, (sum, d) => sum + d);
    return originalDeposit - totalDeductions;
  }

  /// Calculate deduction from unpaid bills during move-out.
  static double calculatePendingDeduction({
    required double depositBalance,
    required double totalUnpaidAmount,
  }) {
    // Deduct minimum of deposit balance or unpaid amount
    return depositBalance < totalUnpaidAmount
        ? depositBalance
        : totalUnpaidAmount;
  }

  /// Get deposit status display text.
  static String getStatusText(DepositStatus status) {
    switch (status) {
      case DepositStatus.pending:
        return 'Pending';
      case DepositStatus.received:
        return 'Received';
      case DepositStatus.partiallyReturned:
        return 'Partially Returned';
      case DepositStatus.returned:
        return 'Returned';
    }
  }

  /// Get status color for UI.
  static int getStatusColorValue(DepositStatus status) {
    switch (status) {
      case DepositStatus.pending:
        return 0xFFFF9800; // Orange
      case DepositStatus.received:
        return 0xFF4CAF50; // Green
      case DepositStatus.partiallyReturned:
        return 0xFF2196F3; // Blue
      case DepositStatus.returned:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Validate deposit amount.
  static String? validateDepositAmount(String? value, double agreedRent) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Enter a valid amount';
    }
    if (amount < 0) {
      return 'Cannot be negative';
    }
    // Warn if deposit seems too high (more than 6 months rent)
    if (amount > agreedRent * 6) {
      return 'Seems high. Please verify.';
    }
    return null;
  }
}
