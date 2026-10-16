import 'package:flutter/material.dart';

class Studentprofile extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const Studentprofile({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<Studentprofile> createState() => _StudentprofileState();
}

class _StudentprofileState extends State<Studentprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),

        // Dark / Light Theme Switch
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // Profile Image + Name + Roll Number
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your name',
                          labelText: 'Name',
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your roll number',
                          labelText: 'Roll Number',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Course
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g. B.Tech ICT',
                labelText: 'Course',
                prefixIcon: Icon(Icons.school),
              ),
            ),

            const SizedBox(height: 10),

            // Semester
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter semester',
                labelText: 'Semester',
                prefixIcon: Icon(Icons.menu_book),
              ),
            ),

            const SizedBox(height: 10),

            // About
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write something about yourself',
                labelText: 'About Student',
                prefixIcon: Icon(Icons.info),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 10),

            // Skills / Subjects
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g. DSA, DBMS, Flutter',
                labelText: 'Skills / Subjects',
                prefixIcon: Icon(Icons.code),
              ),
            ),

            const SizedBox(height: 10),

            // Email
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 10),

            // Phone
            TextField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your phone number',
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Student Profile Saved')),
                  );
                },
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
