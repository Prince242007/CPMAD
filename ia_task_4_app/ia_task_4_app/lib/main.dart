import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/local_storage_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  var firebaseReady = false;
  // Configure Android Firebase first, then run with:
  // flutter run --dart-define=ENABLE_FIREBASE=true
  // For web, supply the generated DefaultFirebaseOptions.currentPlatform
  // to initializeApp after running flutterfire configure (see README_TASK_4.md).
  const enableFirebase = bool.fromEnvironment('ENABLE_FIREBASE');
  if (enableFirebase) {
    try {
      await Firebase.initializeApp().timeout(const Duration(seconds: 10));
      firebaseReady = true;
    } catch (error) {
      debugPrint('Firebase not configured: $error');
    }
  }
  runApp(
    DailyBiteApp(
      storage: LocalStorageService(preferences),
      firebaseReady: firebaseReady,
    ),
  );
}

class DailyBiteApp extends StatefulWidget {
  final LocalStorageService storage;
  final bool firebaseReady;
  const DailyBiteApp({
    super.key,
    required this.storage,
    this.firebaseReady = false,
  });

  @override
  State<DailyBiteApp> createState() => _DailyBiteAppState();
}

class _DailyBiteAppState extends State<DailyBiteApp> {
  late bool darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = widget.storage.isDarkMode;
  }

  Future<void> toggleTheme() async {
    setState(() => darkMode = !darkMode);
    try {
      await widget.storage.saveTheme(darkMode);
    } catch (error) {
      debugPrint('Theme changed for this session only: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppTheme.appTitle,
      theme: AppTheme.create(Brightness.light),
      darkTheme: AppTheme.create(Brightness.dark),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        storage: widget.storage,
        firebaseReady: widget.firebaseReady,
        darkMode: darkMode,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}
