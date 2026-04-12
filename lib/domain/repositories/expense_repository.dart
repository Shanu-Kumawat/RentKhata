import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();
  Future<List<Expense>> getExpensesForProperty(int propertyId);
  Stream<List<Expense>> watchAllExpenses();
  Future<int> addExpense(Expense expense);
  Future<bool> updateExpense(Expense expense);
  Future<int> deleteExpense(int id);
  Future<List<Expense>> getExpensesInDateRange(DateTime start, DateTime end);
}
