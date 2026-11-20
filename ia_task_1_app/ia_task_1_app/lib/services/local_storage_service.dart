import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences preferences;
  LocalStorageService(this.preferences);

  Set<String> loadFavourites() =>
      (preferences.getStringList('favourites') ?? []).toSet();

  Future<void> saveFavourites(Set<String> ids) async {
    final saved = await preferences.setStringList('favourites', ids.toList());
    if (!saved) throw Exception('Could not save favourites.');
  }

  bool get isDarkMode => preferences.getBool('darkMode') ?? false;

  Future<void> saveTheme(bool dark) async {
    final saved = await preferences.setBool('darkMode', dark);
    if (!saved) throw Exception('Could not save theme.');
  }

  Map<String, String> loadMealPlan() {
    final raw = preferences.getString('mealPlan');
    if (raw == null) return {};
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return json.map((key, value) => MapEntry(key, value as String));
    } catch (_) {
      return {}; // Safely recover from an old or damaged saved plan.
    }
  }

  Future<void> saveMealPlan(Map<String, String> plan) async {
    final saved = await preferences.setString('mealPlan', jsonEncode(plan));
    if (!saved) throw Exception('Could not save meal plan.');
  }
}
