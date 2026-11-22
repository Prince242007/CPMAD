import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_image.dart';

/// Reusable, stateless preview card for a recipe.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavourite;
  final VoidCallback? onEdit;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavourite,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    RecipeImage(imageUrl: recipe.imageUrl, height: 145),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(recipe.isVegetarian ? 'Vegetarian' : 'Non-Veg'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
                  child: Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
            child: Row(
              children: [
                Expanded(child: Text(recipe.category)),
                if (onEdit != null)
                  IconButton(
                    tooltip: 'Edit recipe',
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                IconButton(
                  tooltip: recipe.isFavourite ? 'Remove favourite' : 'Add favourite',
                  onPressed: onFavourite,
                  icon: Icon(recipe.isFavourite ? Icons.favorite : Icons.favorite_border),
                  color: recipe.isFavourite ? Colors.red : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
