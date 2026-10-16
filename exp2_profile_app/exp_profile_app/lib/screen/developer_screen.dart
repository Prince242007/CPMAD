// import 'dart:io';

import 'package:flutter/material.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Profile'),
        backgroundColor: const Color.fromARGB(255, 233, 230, 229),
      ),

      backgroundColor: const Color.fromARGB(60, 132, 68, 68),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
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
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          hintText: 'Student / Teacher',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Qualification',
                hintText: 'Enter your qualification',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'About',
                hintText: 'Write a short introduction',
                prefixIcon: Icon(Icons.info),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Skills',
                hintText: 'Enter your skills',
                prefixIcon: Icon(Icons.code),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your mobile number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
