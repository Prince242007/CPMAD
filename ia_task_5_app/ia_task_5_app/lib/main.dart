import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/local_storage_service.dart';
import 'utils/app_theme.dart';
import 'utils/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  var firebaseReady = false;
  const enableFirebase = bool.fromEnvironment('ENABLE_FIREBASE');
  if (enableFirebase) {
    try { await Firebase.initializeApp().timeout(const Duration(seconds: 10)); firebaseReady = true; }
    catch (error) { debugPrint('Firebase not configured: $error'); }
  }
  runApp(DailyBiteApp(storage: LocalStorageService(preferences), firebaseReady: firebaseReady));
}

class DailyBiteApp extends StatefulWidget {
  final LocalStorageService storage; final bool firebaseReady;
  const DailyBiteApp({super.key, required this.storage, this.firebaseReady = false});
  @override State<DailyBiteApp> createState() => _DailyBiteAppState();
}
class _DailyBiteAppState extends State<DailyBiteApp> {
  late bool darkMode; late String localeCode;
  @override void initState() { super.initState(); darkMode = widget.storage.isDarkMode; localeCode = widget.storage.appLocale; }
  Future<void> changeTheme(bool value) async { setState(() => darkMode = value); try { await widget.storage.saveTheme(value); } catch (e) { debugPrint('Theme preference not saved: $e'); } }
  Future<void> changeLocale(String value) async { setState(() => localeCode = value); try { await widget.storage.saveAppLocale(value); } catch (e) { debugPrint('Locale preference not saved: $e'); } }
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'DailyBite',
    theme: AppTheme.create(Brightness.light), darkTheme: AppTheme.create(Brightness.dark),
    themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
    locale: Locale(localeCode), supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [AppLocalizationsDelegate(), DefaultMaterialLocalizations.delegate, DefaultWidgetsLocalizations.delegate, DefaultCupertinoLocalizations.delegate],
    home: HomeScreen(storage: widget.storage, firebaseReady: widget.firebaseReady, darkMode: darkMode,
      onToggleTheme: () => changeTheme(!darkMode), onOpenSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(
        storage: widget.storage, darkMode: darkMode, localeCode: localeCode, onThemeChanged: changeTheme, onLocaleChanged: changeLocale)))),
  );
}
