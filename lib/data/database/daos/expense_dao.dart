import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/expense_table.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  /// Get all expenses, ordered by date descending
  Future<List<ExpenseEntity>> getAllExpenses() {
    return (select(expenses)..orderBy([
          (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        ]))
        .get();
  }

  /// Watch all expenses
  Stream<List<ExpenseEntity>> watchAllExpenses() {
    return (select(expenses)..orderBy([
          (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  /// Get expenses for a specific property
  Future<List<ExpenseEntity>> getExpensesForProperty(int propertyId) {
    return (select(
      expenses,
    )..where((t) => t.propertyId.equals(propertyId))).get();
  }

  /// Insert a new expense
  Future<int> insertExpense(ExpensesCompanion expense) {
    return into(expenses).insert(expense);
  }

  /// Update an existing expense
  Future<bool> updateExpense(ExpenseEntity expense) {
    return update(expenses).replace(expense);
  }

  /// Delete an expense
  Future<int> deleteExpense(int id) {
    return (delete(expenses)..where((t) => t.id.equals(id))).go();
  }

  /// Get expenses within a date range
  Future<List<ExpenseEntity>> getExpensesInDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(expenses)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .get();
  }
}
