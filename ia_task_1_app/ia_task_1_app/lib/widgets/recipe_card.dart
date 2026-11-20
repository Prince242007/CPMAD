import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_image.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavourite;
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavourite,
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
                RecipeImage(imageUrl: recipe.imageUrl),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                Expanded(child: Text(recipe.category)),
                IconButton(
                  tooltip: recipe.isFavourite
                      ? 'Remove favourite'
                      : 'Add favourite',
                  onPressed: onFavourite,
                  icon: Icon(
                    recipe.isFavourite ? Icons.favorite : Icons.favorite_border,
                  ),
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
