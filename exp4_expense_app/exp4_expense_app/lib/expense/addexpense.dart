import 'package:flutter/material.dart';

class Addexpense extends StatefulWidget {
  const Addexpense({super.key});

  @override
  State<Addexpense> createState() => _AddexpenseState();
}

class _AddexpenseState extends State<Addexpense> {
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();

  String category = "Food";
  DateTime selectedDate = DateTime.now();

  List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Education",
    "Entertainment",
    "Other",
  ];

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

  void addExpense() {
    if (amount.text.isEmpty || description.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    Map<String, dynamic> expense = {
      "amount": double.parse(amount.text),
      "category": category,
      "description": description.text,
      "date": selectedDate.toIso8601String(),
    };
    Navigator.pop(context, expense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: category,

              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),

              items: categories.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),

              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: description,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

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

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: addExpense,

                child: const Text(
                  "Add Expense",
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
