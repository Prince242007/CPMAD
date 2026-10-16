import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {

  TextEditingController nameController = TextEditingController();

  String? year;

  List<String> subjects = [];

  double satisfaction = 5;

  void submitSurvey() {

    if (nameController.text.isEmpty || year == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please answer all required questions"),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Survey submitted successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Survey"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Question 1
              const Text(
                "1. Enter your name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Question 2
              const Text(
                "2. Which year are you studying?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Radio<String>(
                value: "1st Year",
                groupValue: year,
                onChanged: (value) {
                  setState(() {
                    year = value;
                  });
                },
              ),

              const Text("1st Year"),

              Radio<String>(
                value: "2nd Year",
                groupValue: year,
                onChanged: (value) {
                  setState(() {
                    year = value;
                  });
                },
              ),

              const Text("2nd Year"),

              Radio<String>(
                value: "3rd Year",
                groupValue: year,
                onChanged: (value) {
                  setState(() {
                    year = value;
                  });
                },
              ),

              const Text("3rd Year"),

              Radio<String>(
                value: "4th Year",
                groupValue: year,
                onChanged: (value) {
                  setState(() {
                    year = value;
                  });
                },
              ),

              const Text("4th Year"),

              const SizedBox(height: 20),

              // Question 3
              const Text(
                "3. Which subjects do you like?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Checkbox(
                value: subjects.contains("Flutter"),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      subjects.add("Flutter");
                    } else {
                      subjects.remove("Flutter");
                    }
                  });
                },
              ),

              const Text("Flutter"),

              Checkbox(
                value: subjects.contains("C++"),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      subjects.add("C++");
                    } else {
                      subjects.remove("C++");
                    }
                  });
                },
              ),

              const Text("C++"),

              Checkbox(
                value: subjects.contains("Python"),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      subjects.add("Python");
                    } else {
                      subjects.remove("Python");
                    }
                  });
                },
              ),

              const Text("Python"),

              const SizedBox(height: 20),

              // Question 4
              const Text(
                "4. How satisfied are you with college?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Slider(
                value: satisfaction,
                min: 1,
                max: 10,
                divisions: 9,
                label: satisfaction.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    satisfaction = value;
                  });
                },
              ),

              Text(
                "Satisfaction: ${satisfaction.toInt()}/10",
              ),

              const SizedBox(height: 20),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitSurvey,
                  child: const Text("Submit Survey"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}