/// Expense domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// Categories for expenses.
enum ExpenseCategory {
  maintenance,
  repairs,
  taxes,
  utilities,
  cleaning,
  salary,
  other,
}

/// Represents an operational expense.
@freezed
class Expense with _$Expense {
  const factory Expense({
    required int id,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? description,
    int? propertyId,
    int? roomId,
    required DateTime createdAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
