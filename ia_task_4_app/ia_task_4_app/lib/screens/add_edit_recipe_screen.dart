import 'package:flutter/material.dart';
import '../models/recipe.dart';

/// Shared form used for both creating a recipe and editing an existing one.
class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _imageController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _stepsController;
  String _category = 'Breakfast';
  bool _isVegetarian = true;

  static const _categories = [
    'Breakfast', 'Lunch', 'Dinner', 'Snacks', 'Dessert', 'Other',
  ];

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;
    _titleController = TextEditingController(text: recipe?.title ?? '');
    _imageController = TextEditingController(text: recipe?.imageUrl ?? '');
    _ingredientsController = TextEditingController(
      text: recipe?.ingredients.join('\n') ?? '',
    );
    _stepsController = TextEditingController(text: recipe?.steps.join('\n') ?? '');
    _category = recipe?.category ?? 'Breakfast';
    if (!_categories.contains(_category)) _category = 'Other';
    _isVegetarian = recipe?.isVegetarian ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Please enter $label.';
    return null;
  }

  void _saveRecipe() {
    if (!_formKey.currentState!.validate()) return;
    final old = widget.recipe;
    final ingredients = _ingredientsController.text
        .split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    final steps = _stepsController.text
        .split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    Navigator.pop(
      context,
      Recipe(
        id: old?.id ?? 'recipe_${DateTime.now().microsecondsSinceEpoch}',
        title: _titleController.text.trim(),
        imageUrl: _imageController.text.trim(),
        category: _category,
        ingredients: ingredients,
        steps: steps,
        isFavourite: old?.isFavourite ?? false,
        isVegetarian: _isVegetarian,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.recipe != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Recipe' : 'Add Recipe')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Recipe information', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Recipe title', prefixIcon: Icon(Icons.restaurant_menu)),
                  validator: (value) => _requiredText(value, 'a recipe title'),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  onChanged: (value) => setState(() => _category = value ?? 'Other'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _imageController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(labelText: 'Image URL (optional)', prefixIcon: Icon(Icons.image_outlined)),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Vegetarian recipe'),
                  subtitle: const Text('Uncheck for a non-vegetarian recipe'),
                  value: _isVegetarian,
                  onChanged: (value) => setState(() => _isVegetarian = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ingredientsController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Ingredients',
                    hintText: 'Enter one ingredient per line\nExample: 1 cup rice',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => _requiredText(value, 'at least one ingredient'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _stepsController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Preparation steps',
                    hintText: 'Enter one step per line',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => _requiredText(value, 'the preparation steps'),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saveRecipe,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(editing ? 'Update Recipe' : 'Save Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
