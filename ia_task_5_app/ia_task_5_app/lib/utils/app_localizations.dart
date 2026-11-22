import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);
  static const supportedLocales = [Locale('en'), Locale('hi')];
  static const _values = <String, Map<String, String>>{
    'en': {
      'appTitle':'DailyBite', 'settings':'Settings', 'language':'Language', 'theme':'Theme',
      'light':'Light', 'dark':'Dark', 'system':'System default', 'english':'English',
      'hindi':'हिन्दी', 'home':'Home', 'savedRecipes':'Your recipes', 'publicRecipes':'Explore public recipes',
      'community':'Community recipes', 'addRecipe':'Add Recipe', 'search':'Search your recipes',
      'mealPlanner':'Meal planner', 'noRecipes':'No recipes found', 'noRecipesHint':'Add a recipe or adjust your search and filters.',
    },
    'hi': {
      'appTitle':'डेलीबाइट', 'settings':'सेटिंग्स', 'language':'भाषा', 'theme':'थीम',
      'light':'लाइट', 'dark':'डार्क', 'system':'सिस्टम डिफ़ॉल्ट', 'english':'English',
      'hindi':'हिन्दी', 'home':'होम', 'savedRecipes':'आपकी रेसिपी', 'publicRecipes':'सार्वजनिक रेसिपी देखें',
      'community':'कम्युनिटी रेसिपी', 'addRecipe':'रेसिपी जोड़ें', 'search':'रेसिपी खोजें',
      'mealPlanner':'भोजन योजना', 'noRecipes':'कोई रेसिपी नहीं मिली', 'noRecipesHint':'रेसिपी जोड़ें या खोज और फ़िल्टर बदलें।',
    },
  };
  String text(String key) => _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;
  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override bool isSupported(Locale locale) => ['en','hi'].contains(locale.languageCode);
  @override Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
