import 'package:exp3_form_app/screen/loginpage.dart';
import 'package:exp3_form_app/screen/loginpage2.dart';
import 'package:exp3_form_app/screen/surveypage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SurveyPage(),
    );
  }
}
