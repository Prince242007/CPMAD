import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  const RecipeImage({super.key, required this.imageUrl, this.height = 110});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(
        Icons.restaurant,
        size: 42,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
    if (imageUrl.isEmpty) return placeholder;
    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}
