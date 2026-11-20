import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  // Firebase is optional in Task 1. No access happens until the user taps sync.
  Future<List<Recipe>> fetchCommunityRecipes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .limit(50)
        .get(const GetOptions(source: Source.server))
        .timeout(const Duration(seconds: 15));
    return snapshot.docs.map((document) {
      return Recipe.fromJson({
        ...document.data(),
        'id': 'community:${document.id}',
        'isFavourite': false, // Favourites belong to this device.
      });
    }).toList();
  }

  // Optional helper for a future HTTP endpoint returning a JSON array.
  // The app uses bundled recipes, so no public API key is required.
  Future<List<Recipe>> fetchFromUrl(Uri url) async {
    final response = await http.get(url).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Recipe request failed: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    if (data is! List) throw const FormatException('Expected a JSON array.');
    return data
        .map((item) => Recipe.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
