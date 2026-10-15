import 'package:flutter/material.dart';

class Resultscreen extends StatefulWidget {
  const Resultscreen({super.key});

  @override
  State<Resultscreen> createState() => _ResultscreenState();
}

class _ResultscreenState extends State<Resultscreen> {
  TextEditingController name = TextEditingController();
  TextEditingController enroll = TextEditingController();
  TextEditingController sem = TextEditingController();

  TextEditingController sub1 = TextEditingController();
  TextEditingController sub2 = TextEditingController();
  TextEditingController sub3 = TextEditingController();
  TextEditingController sub4 = TextEditingController();
  TextEditingController sub5 = TextEditingController();

  String result = "";
  bool isLoading = false;

  // Asynchronous operation
  Future<void> calculateResult() async {
    if (sub1.text.isEmpty ||
        sub2.text.isEmpty ||
        sub3.text.isEmpty ||
        sub4.text.isEmpty ||
        sub5.text.isEmpty) {
      setState(() {
        result = "Please enter marks for all subjects";
      });
      return;
    }

    // Start loading
    setState(() {
      isLoading = true;
      result = "Loading result...";
    });

    // Simulate loading data from server/database
    await Future.delayed(const Duration(seconds: 2));

    String n = name.text;
    String en = enroll.text;
    String S = sem.text;

    int m1 = int.parse(sub1.text);
    int m2 = int.parse(sub2.text);
    int m3 = int.parse(sub3.text);
    int m4 = int.parse(sub4.text);
    int m5 = int.parse(sub5.text);

    int total = m1 + m2 + m3 + m4 + m5;

    double percentage = (total / 500) * 100;

    String grade;

    if (percentage >= 90) {
      grade = "Grade A";
    } else if (percentage >= 70) {
      grade = "Grade B";
    } else if (percentage >= 50) {
      grade = "Grade C";
    } else if (percentage >= 35) {
      grade = "Grade D";
    } else {
      grade = "Fail! Better Luck Next Time";
    }

    setState(() {
      isLoading = false;

      result =
          "Name: $n\n"
          "Enrollment No: $en\n"
          "Sem: $S\n"
          "Subject 1 Marks = $m1\n"
          "Subject 2 Marks = $m2\n"
          "Subject 3 Marks = $m3\n"
          "Subject 4 Marks = $m4\n"
          "Subject 5 Marks = $m5\n\n"
          "Total = $total\n"
          "Percentage = ${percentage.toStringAsFixed(2)}%\n"
          "$grade";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result Calculation")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Text(
              "Student Result",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: name,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "Enter Your Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: enroll,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enrollment No",
                hintText: "Enter Enrollment No",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: sem,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Current Sem",
                hintText: "Enter Current Sem",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Enter marks for each subject",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: sub1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Subject 1 Mark",
                hintText: "Enter Marks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: sub2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Subject 2 Mark",
                hintText: "Enter Marks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: sub3,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Subject 3 Mark",
                hintText: "Enter Marks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: sub4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Subject 4 Mark",
                hintText: "Enter Marks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: sub5,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Subject 5 Mark",
                hintText: "Enter Marks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : calculateResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Result"),
            ),

            const SizedBox(height: 20),

            Text(
              result,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
