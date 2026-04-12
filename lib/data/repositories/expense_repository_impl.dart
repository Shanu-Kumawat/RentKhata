import 'package:drift/drift.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../database/daos/expense_dao.dart';
import '../database/app_database.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDao _dao;

  ExpenseRepositoryImpl(this._dao);

  Expense _mapExpense(ExpenseEntity entity) {
    return Expense(
      id: entity.id,
      amount: entity.amount,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == entity.category,
        orElse: () => ExpenseCategory.other,
      ),
      date: entity.date,
      description: entity.description,
      propertyId: entity.propertyId,
      roomId: entity.roomId,
      createdAt: entity.createdAt,
    );
  }

  ExpensesCompanion _mapCompanion(Expense expense) {
    return ExpensesCompanion(
      id: expense.id == 0 ? const Value.absent() : Value(expense.id),
      amount: Value(expense.amount),
      category: Value(expense.category.name),
      date: Value(expense.date),
      description: Value(expense.description),
      propertyId: Value(expense.propertyId),
      roomId: Value(expense.roomId),
      createdAt: expense.id == 0 ? const Value.absent() : Value(expense.createdAt),
    );
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    final expenses = await _dao.getAllExpenses();
    return expenses.map(_mapExpense).toList();
  }

  @override
  Future<List<Expense>> getExpensesForProperty(int propertyId) async {
    final expenses = await _dao.getExpensesForProperty(propertyId);
    return expenses.map(_mapExpense).toList();
  }

  @override
  Stream<List<Expense>> watchAllExpenses() {
    return _dao.watchAllExpenses().map((list) => list.map(_mapExpense).toList());
  }

  @override
  Future<int> addExpense(Expense expense) async {
    return _dao.insertExpense(_mapCompanion(expense));
  }

  @override
  Future<bool> updateExpense(Expense expense) async {
    final entity = ExpenseEntity(
      id: expense.id,
      amount: expense.amount,
      category: expense.category.name,
      date: expense.date,
      description: expense.description,
      propertyId: expense.propertyId,
      roomId: expense.roomId,
      createdAt: expense.createdAt,
    );
    return _dao.updateExpense(entity);
  }

  @override
  Future<int> deleteExpense(int id) async {
    return _dao.deleteExpense(id);
  }

  @override
  Future<List<Expense>> getExpensesInDateRange(DateTime start, DateTime end) async {
    final expenses = await _dao.getExpensesInDateRange(start, end);
    return expenses.map(_mapExpense).toList();
  }
}
