import 'package:flutter/material.dart';
import 'package:ecom_app/screen/splash_screen.dart';
import 'package:ecom_app/screen/login_screen.dart';
import 'package:ecom_app/screen/registration_screen.dart';
import 'package:ecom_app/screen/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // Define named routes
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
      },

      // Handle dynamic routes with parameters
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, String>;

          return MaterialPageRoute(
            builder: (context) => DashboardScreen(username: args['username']!),
          );
        }

        return null;
      },
    );
  }
}
