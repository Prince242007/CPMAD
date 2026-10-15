import 'package:flutter/material.dart';

class TransactionLists extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  final List<Map<String, dynamic>> incomes;
  final ValueChanged<int> onEditExpense;
  final ValueChanged<int> onDeleteExpense;

  const TransactionLists({
    super.key,
    required this.expenses,
    required this.incomes,
    required this.onEditExpense,
    required this.onDeleteExpense,
  });

  String formatAmount(dynamic amount) {
    return (amount as num).toDouble().toStringAsFixed(2);
  }

  String formatDate(dynamic value) {
    final date = DateTime.parse(value as String);
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget expenseList() {
    if (expenses.isEmpty) {
      return const Center(child: Text('No expenses added yet'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade50,
              child: Text(
                (expense['category'] as String)[0],
                style: const TextStyle(color: Colors.red),
              ),
            ),
            title: Text(
              expense['description'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${expense['category']} • ${formatDate(expense['date'])}',
            ),
            trailing: SizedBox(
              width: 125,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      '- ₹${formatAmount(expense['amount'])}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => onEditExpense(index),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.edit, size: 19),
                        ),
                      ),
                      InkWell(
                        onTap: () => onDeleteExpense(index),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.delete_outline,
                            size: 19,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget incomeList() {
    if (incomes.isEmpty) {
      return const Center(child: Text('No income added yet'));
    }

    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        final income = incomes[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade50,
              child: const Icon(Icons.arrow_downward, color: Colors.green),
            ),
            title: Text(
              income['description'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${income['category']} • ${formatDate(income['date'])}',
            ),
            trailing: Text(
              '+ ₹${formatAmount(income['amount'])}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.arrow_upward), text: 'Expenses'),
              Tab(icon: Icon(Icons.arrow_downward), text: 'Income'),
            ],
          ),
          Expanded(child: TabBarView(children: [expenseList(), incomeList()])),
        ],
      ),
    );
  }
}
