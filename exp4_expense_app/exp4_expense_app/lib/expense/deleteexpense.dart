import 'package:flutter/material.dart';

class Deleteexpense extends StatefulWidget {
  final Map<String, dynamic> expense;

  const Deleteexpense({super.key, required this.expense});

  @override
  State<Deleteexpense> createState() => _DeleteexpenseState();
}

class _DeleteexpenseState extends State<Deleteexpense> {
  void deleteExpense() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Expense")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete, size: 70, color: Colors.red),

            const SizedBox(height: 20),

            const Text(
              "Delete Expense?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Text(
              "₹ ${widget.expense["amount"]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              widget.expense["description"],
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: deleteExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
