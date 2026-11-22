import '../models/recipe.dart';

// Pure functions: no UI, network, storage, or changes to the original list.
List<Recipe> filterByCategory(List<Recipe> recipes, String? category) {
  final selected = category?.trim().toLowerCase() ?? '';
  if (selected.isEmpty || selected == 'all') return List.of(recipes);
  return recipes
      .where((recipe) => recipe.category.toLowerCase() == selected)
      .toList();
}

List<Recipe> searchByTitle(List<Recipe> recipes, String? query) {
  final text = query?.trim().toLowerCase() ?? '';
  return recipes
      .where((recipe) => recipe.title.toLowerCase().contains(text))
      .toList();
}
