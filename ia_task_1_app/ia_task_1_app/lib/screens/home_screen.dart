import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/local_storage_service.dart';
import '../services/recipe_service.dart';
import '../services/sample_recipes.dart';
import '../utils/app_theme.dart';
import '../utils/recipe_helpers.dart';
import '../widgets/recipe_card.dart';
import 'meal_planner_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final LocalStorageService storage;
  final bool firebaseReady;
  final bool darkMode;
  final VoidCallback onToggleTheme;
  const HomeScreen({
    super.key,
    required this.storage,
    required this.firebaseReady,
    required this.darkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe> recipes;
  late Set<String> favouriteIds;
  String query = '';
  String category = 'All';
  bool favouritesOnly = false;
  bool loading = false;
  bool savingFavourite = false;
  final service = RecipeService();

  @override
  void initState() {
    super.initState();
    favouriteIds = widget.storage.loadFavourites();
    recipes = applyFavourites(createSampleRecipes());
  }

  List<Recipe> applyFavourites(List<Recipe> values) => values
      .map(
        (recipe) =>
            recipe.copyWith(isFavourite: favouriteIds.contains(recipe.id)),
      )
      .toList();

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> toggleFavourite(Recipe recipe) async {
    if (savingFavourite) return;
    final updated = Set<String>.of(favouriteIds);
    if (!updated.add(recipe.id)) updated.remove(recipe.id);
    setState(() => savingFavourite = true);
    try {
      await widget.storage.saveFavourites(updated);
      if (!mounted) return;
      setState(() {
        favouriteIds = updated;
        recipes = applyFavourites(recipes);
      });
    } catch (_) {
      if (mounted) message('Could not save favourite. Please try again.');
    } finally {
      if (mounted) setState(() => savingFavourite = false);
    }
  }

  Future<void> loadCommunity() async {
    if (!widget.firebaseReady) {
      message('Sample mode: configure Firebase to load community recipes.');
      return;
    }
    setState(() => loading = true);
    try {
      final community = await service.fetchCommunityRecipes();
      if (!mounted) return;
      setState(() {
        recipes = applyFavourites([...createSampleRecipes(), ...community]);
        if (!['All', ...recipes.map((r) => r.category)].contains(category)) {
          category = 'All';
        }
      });
      message('${community.length} community recipes loaded.');
    } catch (_) {
      if (mounted) {
        message(
          'Could not load community recipes. Check connection and Firestore permissions.',
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var visible = searchByTitle(filterByCategory(recipes, category), query);
    if (favouritesOnly) visible = visible.where((r) => r.isFavourite).toList();
    final categories = ['All', ...recipes.map((r) => r.category).toSet()];
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTheme.appTitle),
        actions: [
          IconButton(
            tooltip: 'Weekly meal planner',
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => MealPlannerScreen(
                  recipes: recipes,
                  storage: widget.storage,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: widget.darkMode ? 'Light theme' : 'Dark theme',
            icon: Icon(widget.darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What will you cook today?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search recipes by title',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (text) => setState(() => query = text),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(item),
                                  selected: category == item,
                                  onSelected: (_) =>
                                      setState(() => category = item),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FilterChip(
                          label: const Text('Favourites'),
                          selected: favouritesOnly,
                          avatar: const Icon(Icons.favorite_border, size: 18),
                          onSelected: (value) =>
                              setState(() => favouritesOnly = value),
                        ),
                        TextButton.icon(
                          onPressed: loading ? null : loadCommunity,
                          icon: const Icon(Icons.cloud_download_outlined),
                          label: const Text('Community'),
                        ),
                        Text('${visible.length} recipes'),
                      ],
                    ),
                  ],
                ),
              ),
              if (loading) const LinearProgressIndicator(),
              Expanded(
                child: visible.isEmpty
                    ? const Center(
                        child: Text(
                          'No recipes found. Try another search or filter.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final recipe = visible[index];
                          return RecipeCard(
                            recipe: recipe,
                            onFavourite: () => toggleFavourite(recipe),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
