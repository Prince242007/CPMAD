// Immutable recipe model. copyWith keeps state updates predictable.
class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final String category;
  final bool isFavourite;
  final bool isVegetarian;

  Recipe({
    required this.id,
    required this.title,
    required List<String> ingredients,
    required List<String> steps,
    this.imageUrl = '',
    this.category = 'Other',
    this.isFavourite = false,
    this.isVegetarian = true,
  }) : ingredients = List.unmodifiable(ingredients),
       steps = List.unmodifiable(steps);

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? 'Untitled recipe',
    ingredients: _readList(json['ingredients']),
    steps: _readList(json['steps']),
    imageUrl: json['imageUrl'] as String? ?? '',
    category: json['category'] as String? ?? 'Other',
    isFavourite: json['isFavourite'] as bool? ?? false,
    isVegetarian: json['isVegetarian'] as bool? ?? true,
  );

  static List<String> _readList(dynamic value) =>
      value is List ? value.whereType<String>().toList() : <String>[];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ingredients': ingredients,
    'steps': steps,
    'imageUrl': imageUrl,
    'category': category,
    'isFavourite': isFavourite,
    'isVegetarian': isVegetarian,
  };

  Recipe copyWith({
    String? id,
    String? title,
    List<String>? ingredients,
    List<String>? steps,
    String? imageUrl,
    String? category,
    bool? isFavourite,
    bool? isVegetarian,
  }) => Recipe(
    id: id ?? this.id,
    title: title ?? this.title,
    ingredients: ingredients ?? this.ingredients,
    steps: steps ?? this.steps,
    imageUrl: imageUrl ?? this.imageUrl,
    category: category ?? this.category,
    isFavourite: isFavourite ?? this.isFavourite,
    isVegetarian: isVegetarian ?? this.isVegetarian,
  );
}
