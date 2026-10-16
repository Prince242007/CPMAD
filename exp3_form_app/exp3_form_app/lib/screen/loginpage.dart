import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String? gender;
  List<String> selectedCourses = [];

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Slider
  double age = 18;

  // Switches
  bool isHostel = false;
  bool isNotifications = false;

  // To store submitted information
  bool submitted = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void submitForm() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        passwordController.text.isEmpty ||
        gender == null ||
        selectedCourses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    setState(() {
      submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form registration"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // NAME
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: "Enter your full name",
                  label: Text("Your name :-"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.abc),
                ),
              ),

              const SizedBox(height: 10),

              // EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter your Email",
                  label: Text("Your Email :-"),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // MOBILE
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(  
                  hintText: "Enter your mobile number",
                  label: Text("Your Mobile number :-"),
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // PASSWORD
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                  label: Text("Your password :-"),
                  prefixIcon: Icon(Icons.key),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // GENDER
              Row(
                children: [
                  const Text("Select your gender :- "),

                  Radio<String>(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),

                  const Text("Male"),

                  Radio<String>(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),

                  const Text("Female"),
                ],
              ),

              const SizedBox(height: 10),

              // COURSE
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [

                  const Text("Select your course :- "),

                  Checkbox(
                    value: selectedCourses.contains("ICT"),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedCourses.add("ICT");
                        } else {
                          selectedCourses.remove("ICT");
                        }
                      });
                    },
                  ),

                  const Text("ICT"),

                  Checkbox(
                    value: selectedCourses.contains("CSE"),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedCourses.add("CSE");
                        } else {
                          selectedCourses.remove("CSE");
                        }
                      });
                    },
                  ),

                  const Text("CSE"),

                  Checkbox(
                    value: selectedCourses.contains("Civil"),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedCourses.add("Civil");
                        } else {
                          selectedCourses.remove("Civil");
                        }
                      });
                    },
                  ),

                  const Text("Civil"),
                ],
              ),

              const SizedBox(height: 10),

              // AGE SLIDER
              Text(
                "Select your age : ${age.toInt()}",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              Slider(
                value: age,
                min: 18,
                max: 60,
                divisions: 42,
                label: age.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    age = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              // SWITCH 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Do you need hostel?"),

                  Switch(
                    value: isHostel,
                    onChanged: (value) {
                      setState(() {
                        isHostel = value;
                      });
                    },
                  ),
                ],
              ),

              // SWITCH 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Allow notifications?"),

                  Switch(
                    value: isNotifications,
                    onChanged: (value) {
                      setState(() {
                        isNotifications = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text("Submit"),
                ),
              ),

              const SizedBox(height: 20),

              // DISPLAY INFORMATION
              if (submitted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Submitted Student Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text("Name : ${nameController.text}"),

                      Text("Email : ${emailController.text}"),

                      Text("Mobile : ${mobileController.text}"),

                      Text("Password : ${passwordController.text}"),

                      Text("Gender : $gender"),

                      Text(
                        "Courses : ${selectedCourses.join(", ")}",
                      ),

                      Text("Age : ${age.toInt()}"),

                      Text("Hostel : ${isHostel ? "Yes" : "No"}"),

                      Text(
                        "Notifications : "
                        "${isNotifications ? "Yes" : "No"}",
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}