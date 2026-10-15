import 'package:flutter/material.dart';

class Editexpense extends StatefulWidget {
  final Map<String, dynamic> expense;

  const Editexpense({super.key, required this.expense});

  @override
  State<Editexpense> createState() => _EditexpenseState();
}

class _EditexpenseState extends State<Editexpense> {
  late TextEditingController amount;
  late TextEditingController description;

  String category = "Food";
  DateTime selectedDate = DateTime.now();

  final List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Education",
    "Entertainment",
    "Other",
  ];

  @override
  void initState() {
    super.initState();

    amount = TextEditingController(text: widget.expense["amount"].toString());

    description = TextEditingController(
      text: widget.expense["description"].toString(),
    );

    category = widget.expense["category"];

    selectedDate = DateTime.parse(widget.expense["date"]);
  }

  void selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void updateExpense() {
    if (amount.text.isEmpty || description.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    double? expenseAmount = double.tryParse(amount.text);

    if (expenseAmount == null || expenseAmount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a valid amount")));
      return;
    }

    Map<String, dynamic> updatedExpense = {
      "amount": expenseAmount,
      "category": category,
      "description": description.text,
      "date": selectedDate.toIso8601String(),
    };

    Navigator.pop(context, updatedExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Expense")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // Amount
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Category
            DropdownButtonFormField<String>(
              value: category,

              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),

              items: categories.map((item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),

              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // Description
            TextField(
              controller: description,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Date
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Date: ${selectedDate.day}/"
                    "${selectedDate.month}/"
                    "${selectedDate.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                ElevatedButton(
                  onPressed: selectDate,
                  child: const Text("Select Date"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Update button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: updateExpense,

                child: const Text(
                  "Update Expense",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    super.dispose();
  }
}
