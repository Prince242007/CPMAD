class ExpenseCalculations {
  static double totalIncome(List<Map<String, dynamic>> incomes) {
    return incomes.fold<double>(
      0,
      (total, income) => total + (income['amount'] as num).toDouble(),
    );
  }

  static double totalExpense(List<Map<String, dynamic>> expenses) {
    return expenses.fold<double>(
      0,
      (total, expense) => total + (expense['amount'] as num).toDouble(),
    );
  }

  static double balance(
    List<Map<String, dynamic>> incomes,
    List<Map<String, dynamic>> expenses,
  ) {
    return totalIncome(incomes) - totalExpense(expenses);
  }

  static Map<String, double> categoryTotals(
    List<Map<String, dynamic>> expenses,
  ) {
    final Map<String, double> totals = {};

    for (final expense in expenses) {
      final String category = expense['category'] as String;
      final double amount = (expense['amount'] as num).toDouble();

      totals[category] = (totals[category] ?? 0) + amount;
    }

    return totals;
  }

  static String highestCategory(List<Map<String, dynamic>> expenses) {
    final totals = categoryTotals(expenses);

    if (totals.isEmpty) {
      return 'No expenses';
    }

    return totals.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  static double highestCategoryAmount(List<Map<String, dynamic>> expenses) {
    final totals = categoryTotals(expenses);

    if (totals.isEmpty) {
      return 0;
    }

    return totals.values.reduce((a, b) => a > b ? a : b);
  }
}
