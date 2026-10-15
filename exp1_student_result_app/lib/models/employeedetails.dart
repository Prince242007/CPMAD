import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Employeedetails extends StatefulWidget {
  const Employeedetails({super.key});

  @override
  State<Employeedetails> createState() => _EmployeedetailsState();
}

class _EmployeedetailsState extends State<Employeedetails> {
  TextEditingController basicSalary = TextEditingController();
  TextEditingController allowance = TextEditingController();
  TextEditingController deduction = TextEditingController();

  String total = "";

  void calculateSalary() {
    // Check whether fields are empty
    if (basicSalary.text.isEmpty ||
        allowance.text.isEmpty ||
        deduction.text.isEmpty) {
      setState(() {
        total = "Please enter all values";
      });
      return;
    }

    int salary = int.parse(basicSalary.text);
    int allow = int.parse(allowance.text);
    int deduct = int.parse(deduction.text);

    int totalSalary = salary + allow - deduct;

    setState(() {
      total = "$totalSalary";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Salary Calculation")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Text(
              "Employee Detail",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: basicSalary,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Basic Salary",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: allowance,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Allowance",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: deduction,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Deduction",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateSalary,
              style: ButtonStyle(
                shadowColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: const Text("Calculate Salary"),
            ),

            const SizedBox(height: 20),

            Text(
              "Total Salary: $total",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
