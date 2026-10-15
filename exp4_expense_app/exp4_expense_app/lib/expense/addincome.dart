import 'package:flutter/material.dart';

class Addincome extends StatefulWidget {
  const Addincome({super.key});

  @override
  State<Addincome> createState() => _AddincomeState();
}

class _AddincomeState extends State<Addincome> {
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();

  String category = "Salary";
  DateTime selectedDate = DateTime.now();

  List<String> categories = [
    "Salary",
    "Freelance",
    "Business",
    "Investment",
    "Gift",
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

  void addIncome() {
    if (amount.text.isEmpty || description.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    double? incomeAmount = double.tryParse(amount.text);

    if (incomeAmount == null || incomeAmount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a valid amount")));
      return;
    }

    Map<String, dynamic> income = {
      "amount": incomeAmount,
      "category": category,
      "description": description.text,
      "date": selectedDate.toIso8601String(),
    };

    Navigator.pop(context, income);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Income")),

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
                return DropdownMenuItem(value: item, child: Text(item));
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

            // Add Income button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: addIncome,

                child: const Text("Add Income", style: TextStyle(fontSize: 18)),
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
