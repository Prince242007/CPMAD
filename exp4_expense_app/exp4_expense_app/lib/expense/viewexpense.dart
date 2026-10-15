import 'package:flutter/material.dart';

import 'addexpense.dart';
import 'addincome.dart';
import 'deleteexpense.dart';
import 'editexpense.dart';
import 'expense_summary.dart';
import 'transaction_lists.dart';

class Viewexpense extends StatefulWidget {
  const Viewexpense({super.key});

  @override
  State<Viewexpense> createState() => _ViewexpenseState();
}

class _ViewexpenseState extends State<Viewexpense> {
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];

  Future<void> addExpense() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const Addexpense()),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        expenses.add(result);
      });
    }
  }

  Future<void> addIncome() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const Addincome()),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        incomes.add(result);
      });
    }
  }

  Future<void> editExpense(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => Editexpense(expense: expenses[index]),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        expenses[index] = result;
      });
    }
  }

  Future<void> deleteExpense(int index) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => Deleteexpense(expense: expenses[index]),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        expenses.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker'), centerTitle: true),
      body: Column(
        children: [
          ExpenseSummary(expenses: expenses, incomes: incomes),
          const Divider(height: 20),
          Expanded(
            child: TransactionLists(
              expenses: expenses,
              incomes: incomes,
              onEditExpense: editExpense,
              onDeleteExpense: deleteExpense,
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'incomeButton',
            onPressed: addIncome,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Income'),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: 'expenseButton',
            onPressed: addExpense,
            icon: const Icon(Icons.add),
            label: const Text('Expense'),
          ),
        ],
      ),
    );
  }
}
