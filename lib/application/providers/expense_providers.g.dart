// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expensesHash() => r'b296a1a495133914378721fe87c5ccd532b7631a';

/// Provides a stream of all expenses.
///
/// Copied from [expenses].
@ProviderFor(expenses)
final expensesProvider = AutoDisposeStreamProvider<List<Expense>>.internal(
  expenses,
  name: r'expensesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpensesRef = AutoDisposeStreamProviderRef<List<Expense>>;
String _$expenseNotifierHash() => r'f8e9dd5994a2ea58f9dd1bb4284d6da1124bcd7d';

/// Provides a function to add a newly recorded expense
///
/// Copied from [ExpenseNotifier].
@ProviderFor(ExpenseNotifier)
final expenseNotifierProvider =
    AutoDisposeNotifierProvider<ExpenseNotifier, void>.internal(
      ExpenseNotifier.new,
      name: r'expenseNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expenseNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExpenseNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
