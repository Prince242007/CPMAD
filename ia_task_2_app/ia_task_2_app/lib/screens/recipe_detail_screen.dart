import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_image.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _servings = 2;

  // Scales a leading numeric amount (including decimals and simple fractions).
  // Text without a leading amount remains unchanged.
  String _scaledIngredient(String ingredient) {
    final match = RegExp(r'^\s*(\d+(?:\.\d+)?|\d+/\d+)').firstMatch(ingredient);
    if (match == null) return ingredient;
    final amountText = match.group(1)!;
    double amount;
    if (amountText.contains('/')) {
      final parts = amountText.split('/');
      amount = double.parse(parts[0]) / double.parse(parts[1]);
    } else {
      amount = double.parse(amountText);
    }
    final scaled = amount * _servings / 2;
    final formatted = scaled == scaled.roundToDouble()
        ? scaled.toInt().toString()
        : scaled.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    return ingredient.replaceFirst(amountText, formatted);
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RecipeImage(imageUrl: recipe.imageUrl, height: 190),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Chip(label: Text(recipe.category)),
              const SizedBox(width: 8),
              Chip(
                avatar: Icon(recipe.isVegetarian ? Icons.eco : Icons.restaurant, size: 18),
                label: Text(recipe.isVegetarian ? 'Vegetarian' : 'Non-Veg'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Adjust servings', style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Decrease servings',
                        onPressed: _servings > 1 ? () => setState(() => _servings--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Expanded(
                        child: Slider(
                          value: _servings.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: '$_servings',
                          onChanged: (value) => setState(() => _servings = value.round()),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Increase servings',
                        onPressed: _servings < 10 ? () => setState(() => _servings++) : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      Text('$_servings', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const Text('Ingredient amounts are scaled from the original 2 servings.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
          ...recipe.ingredients.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 19),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_scaledIngredient(item))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Preparation steps', style: Theme.of(context).textTheme.titleLarge),
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
