import 'package:flutter/material.dart';
import 'screens/device_utility_screen.dart';

void main() {
  runApp(const DeviceUtilityApp());
}

class DeviceUtilityApp extends StatelessWidget {
  const DeviceUtilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Device Utility App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DeviceUtilityScreen(),
    );
  }
}
