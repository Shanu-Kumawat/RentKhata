import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/expense.dart';
import 'repository_providers.dart';

part 'expense_providers.g.dart';

/// Provides a stream of all expenses.
@riverpod
Stream<List<Expense>> expenses(Ref ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchAllExpenses();
}

/// Provides a function to add a newly recorded expense
@riverpod
class ExpenseNotifier extends _$ExpenseNotifier {
  @override
  void build() {
    // No state needed, just methods
  }

  Future<void> addExpense(Expense expense) async {
    final repo = ref.read(expenseRepositoryProvider);
    await repo.addExpense(expense);
  }

  Future<void> deleteExpense(int id) async {
    final repo = ref.read(expenseRepositoryProvider);
    await repo.deleteExpense(id);
  }
}
