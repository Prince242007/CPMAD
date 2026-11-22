import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static final Uri publicRecipesUri = Uri.parse('https://dummyjson.com/recipes?limit=30');

  Future<List<Recipe>> fetchPublicRecipes() async {
    final response = await http.get(publicRecipesUri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 18));
    if (response.statusCode != 200) {
      throw Exception('Recipe service returned HTTP ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map || decoded['recipes'] is! List) {
      throw const FormatException('The recipe API returned an unexpected response.');
    }
    return (decoded['recipes'] as List).map((raw) {
      final item = Map<String, dynamic>.from(raw as Map);
      final ingredients = (item['ingredients'] as List? ?? []).map((e) => e.toString()).toList();
      final instructions = (item['instructions'] as List? ?? []).map((e) => e.toString()).toList();
      final tags = (item['tags'] as List? ?? []).map((e) => e.toString()).toList();
      final mealTypes = (item['mealType'] as List? ?? []).map((e) => e.toString()).toList();
      final vegetarian = !tags.any((tag) => ['meat', 'chicken', 'beef', 'pork', 'seafood', 'fish'].contains(tag.toLowerCase()));
      return Recipe(
        id: 'api:${item['id']}',
        title: item['name']?.toString() ?? 'Untitled recipe',
        ingredients: ingredients,
        steps: instructions,
        imageUrl: item['image']?.toString() ?? '',
        category: mealTypes.isNotEmpty ? mealTypes.first : (tags.isNotEmpty ? tags.first : 'Public recipe'),
        isFavourite: false,
        isVegetarian: vegetarian,
      );
    }).toList();
  }

  Stream<List<Recipe>> watchCommunityRecipes() {
    return FirebaseFirestore.instance.collection('recipes').orderBy('createdAt', descending: true)
      .limit(50).snapshots().map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return Recipe.fromJson({...data, 'id': 'community:${doc.id}', 'isFavourite': false});
      }).toList());
  }

  Future<void> saveCommunityRecipe(Recipe recipe) async {
    final data = recipe.toJson()..remove('id')..remove('isFavourite');
    data['createdAt'] = FieldValue.serverTimestamp();
    await FirebaseFirestore.instance.collection('recipes').add(data).timeout(const Duration(seconds: 15));
  }

  Future<void> updateCommunityRecipe(Recipe recipe) async {
    final id = recipe.id.replaceFirst('community:', '');
    final data = recipe.toJson()..remove('id')..remove('isFavourite');
    data['updatedAt'] = FieldValue.serverTimestamp();
    await FirebaseFirestore.instance.collection('recipes').doc(id).set(data, SetOptions(merge: true))
      .timeout(const Duration(seconds: 15));
  }
}
