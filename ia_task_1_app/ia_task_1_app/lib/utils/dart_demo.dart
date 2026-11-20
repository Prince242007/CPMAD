// ignore_for_file: avoid_print
import '../services/sample_recipes.dart';
import '../models/recipe.dart';
import 'recipe_helpers.dart';

// Run from the project root: dart run lib/utils/dart_demo.dart
// This file imports only pure Dart files and needs no running Flutter UI.
void main() {
  final recipes = createSampleRecipes();
  print('Total recipes: ${recipes.length}');
  print('Breakfast: ${filterByCategory(recipes, 'Breakfast').length}');
  print('Search PANEER: ${searchByTitle(recipes, ' PANEER ').first.title}');
  print('Null search: ${searchByTitle(recipes, null).length}');
  print('Missing search: ${searchByTitle(recipes, 'pizza').length}');
  final restored = Recipe.fromJson(recipes.first.toJson());
  print('JSON round trip: ${restored.title == recipes.first.title}');
  final changed = recipes.first.copyWith(isFavourite: true);
  print('Copy favourite: ${changed.isFavourite}');
  print('Original favourite: ${recipes.first.isFavourite}');
}
