import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('This is First App')),
        body: Container(
          color: Colors.red,
          child: Center(
            child: Text(
              'Hello From First App',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}
\