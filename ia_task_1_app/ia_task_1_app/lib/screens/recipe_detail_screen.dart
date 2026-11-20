import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_image.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RecipeImage(imageUrl: recipe.imageUrl, height: 180),
          ),
          const SizedBox(height: 16),
          Text(recipe.category, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 16),
          Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
          ...recipe.ingredients.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text('- $item'),
            ),
          ),
          const SizedBox(height: 20),
          Text('Steps', style: Theme.of(context).textTheme.titleLarge),
          ...recipe.steps.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('${entry.key + 1}. ${entry.value}'),
            ),
          ),
        ],
      ),
    );
  }
}
