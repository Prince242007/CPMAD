
import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/local_storage_service.dart';
import '../services/recipe_service.dart';
import '../services/sample_recipes.dart';
import '../utils/app_theme.dart';
import '../utils/recipe_helpers.dart';
import '../utils/app_localizations.dart';
import '../widgets/recipe_card.dart';

import 'add_edit_recipe_screen.dart';
import 'meal_planner_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final LocalStorageService storage;
  final bool firebaseReady;
  final bool darkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenSettings;

  const HomeScreen({
    super.key,
    required this.storage,
    required this.firebaseReady,
    required this.darkMode,
    required this.onToggleTheme,
    required this.onOpenSettings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe> recipes;
  late Set<String> favouriteIds;
  late Future<List<Recipe>> publicFuture;

  final RecipeService service = RecipeService();

  String query = '';
  String category = 'All';
  String dietFilter = 'All';

  bool favouritesOnly = false;

  @override
  void initState() {
    super.initState();

    favouriteIds = widget.storage.loadFavourites();

    recipes = applyFavourites(
      widget.storage.loadRecipes() ?? createSampleRecipes(),
    );

    publicFuture = _fetchAndCachePublic();
  }

  List<Recipe> applyFavourites(List<Recipe> items) {
    return items.map((r) {
      return r.copyWith(
        isFavourite: favouriteIds.contains(r.id),
      );
    }).toList();
  }

  Future<List<Recipe>> _fetchAndCachePublic() async {
    try {
      final fresh = await service.fetchPublicRecipes();

      await widget.storage.saveCachedPublicRecipes(fresh);

      return fresh;
    } catch (error) {
      final cached = widget.storage.loadCachedPublicRecipes();

      if (cached.isNotEmpty) {
        return cached;
      }

      rethrow;
    }
  }

  Future<void> refreshAll() async {
    setState(() {
      publicFuture = _fetchAndCachePublic();
    });

    try {
      await publicFuture;
    } catch (_) {
      if (mounted) {
        _message(
          'Refresh failed. Showing saved recipes where available.',
        );
      }
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _persist(List<Recipe> items) async {
    try {
      await widget.storage.saveRecipes(items);
    } catch (_) {
      if (mounted) {
        _message('Could not save recipes on this device.');
      }
    }
  }

  Future<void> openRecipeForm({Recipe? recipe}) async {
    final result = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditRecipeScreen(
          recipe: recipe,
        ),
      ),
    );

    if (result == null || !mounted) return;

    final updated = List<Recipe>.of(recipes);

    final index = updated.indexWhere(
      (r) => r.id == result.id,
    );

    if (index >= 0) {
      updated[index] = result;
    } else {
      updated.insert(0, result);
    }

    setState(() {
      recipes = updated;
    });

    await _persist(updated);

    if (widget.firebaseReady &&
        !result.id.startsWith('api:') &&
        !result.id.startsWith('community:')) {
      try {
        await service.saveCommunityRecipe(result);

        if (mounted) {
          _message(
            'Saved locally and shared with the community.',
          );
        }
      } catch (_) {
        if (mounted) {
          _message(
            'Saved locally. Firebase sync is unavailable; check Firestore rules.',
          );
        }
      }
    } else if (mounted) {
      _message('Recipe saved on this device.');
    }
  }

  Future<void> toggleFavourite(Recipe recipe) async {
    final ids = Set<String>.of(favouriteIds);

    if (!ids.add(recipe.id)) {
      ids.remove(recipe.id);
    }

    final updated = recipes.map((r) {
      return r.id == recipe.id
          ? r.copyWith(
              isFavourite: ids.contains(r.id),
            )
          : r;
    }).toList();

    setState(() {
      favouriteIds = ids;
      recipes = updated;
    });

    try {
      await widget.storage.saveFavourites(ids);
      await widget.storage.saveRecipes(updated);
    } catch (_) {
      if (mounted) {
        _message(
          'Favourite changed for this session but could not be saved.',
        );
      }
    }
  }

  List<Recipe> _filtered(List<Recipe> source) {
    var values = searchByTitle(
      filterByCategory(source, category),
      query,
    );

    if (favouritesOnly) {
      values = values
          .where((r) => favouriteIds.contains(r.id))
          .toList();
    }

    if (dietFilter == 'Vegetarian') {
      values = values
          .where((r) => r.isVegetarian)
          .toList();
    }

    if (dietFilter == 'Non-Veg') {
      values = values
          .where((r) => !r.isVegetarian)
          .toList();
    }

    return values;
  }

  Widget _emptyState({
    required String title,
    required String message,
    required IconData icon,
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 42,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  // PUBLIC RECIPES
  // FutureBuilder is wrapped inside SliverToBoxAdapter.

  Widget _buildPublicRecipes() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Recipe>>(
        future: publicFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
                  ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(28),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError && !snapshot.hasData) {
            return _emptyState(
              title: 'Could not load recipes',
              message:
                  'Check your internet connection and pull down to retry.',
              icon: Icons.cloud_off_outlined,
              action: TextButton.icon(
                onPressed: refreshAll,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }

          final publicRecipes = _filtered(
            (snapshot.data ?? [])
                .map(
                  (r) => r.copyWith(
                    isFavourite:
                        favouriteIds.contains(r.id),
                  ),
                )
                .toList(),
          );

          if (publicRecipes.isEmpty) {
            return _emptyState(
              title: 'No public recipes found',
              message: 'Try changing the filters.',
              icon: Icons.search_off,
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: publicRecipes.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .78,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final recipe = publicRecipes[index];

                return RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailScreen(
                          recipe: recipe,
                        ),
                      ),
                    );
                  },
                  onFavourite: () =>
                      toggleFavourite(recipe),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // FIREBASE COMMUNITY RECIPES
  // StreamBuilder is also wrapped inside SliverToBoxAdapter.

  Widget _buildCommunityRecipes() {
    if (!widget.firebaseReady) {
      return SliverToBoxAdapter(
        child: _emptyState(
          title: 'Firebase not connected',
          message:
              'Configure Firebase to see recipes shared by the community.',
          icon: Icons.cloud_outlined,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: StreamBuilder<List<Recipe>>(
        stream: service.watchCommunityRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return _emptyState(
              title: 'Community unavailable',
              message:
                  'Check Firebase configuration and Firestore security rules.',
              icon: Icons.error_outline,
            );
          }

          final community = (snapshot.data ?? [])
              .map(
                (r) => r.copyWith(
                  isFavourite:
                      favouriteIds.contains(r.id),
                ),
              )
              .toList();

          if (community.isEmpty) {
            return _emptyState(
              title: 'Be the first to share',
              message:
                  'Add a recipe to share it with the DailyBite community.',
              icon: Icons.group_outlined,
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: community.length,
            itemBuilder: (context, index) {
              final recipe = community[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailScreen(
                          recipe: recipe,
                        ),
                      ),
                    );
                  },
                  onFavourite: () =>
                      toggleFavourite(recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final visible = _filtered(recipes);

    final categories = [
      'All',
      ...recipes.map((r) => r.category).toSet(),
    ];

    return Scaffold(
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () => openRecipeForm(),
        icon: const Icon(Icons.add),
        label: Text(l10n.text('addRecipe')),
      ),

      body: RefreshIndicator(
        onRefresh: refreshAll,
        child: CustomScrollView(
          slivers: [
            // APP BAR

            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 145,
              title: const Text(AppTheme.appTitle),
              actions: [
                IconButton(
                  tooltip: 'Meal planner',
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MealPlannerScreen(
                          recipes: recipes,
                          storage: widget.storage,
                        ),
                      ),
                    );
                  },
                ),

                IconButton(
                  tooltip: widget.darkMode
                      ? 'Light theme'
                      : 'Dark theme',
                  icon: Icon(
                    widget.darkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: widget.onToggleTheme,
                ),

                IconButton(
                  tooltip: l10n.text('settings'),
                  icon: const Icon(
                    Icons.settings_outlined,
                  ),
                  onPressed: widget.onOpenSettings,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20, 88, 20, 12,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Discover something delicious',
                      style: Theme.of(context)
                          .textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
            ),

            // STICKY SEARCH AND FILTER HEADER

            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyFilterHeader(
                height: 170,
                child: Material(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16, 8, 16, 8,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.search),
                            hintText: l10n.text('search'),
                          ),
                          onChanged: (value) {
                            setState(() {
                              query = value;
                            });
                          },
                        ),

                        const SizedBox(height: 8),

                        // CATEGORY FILTER

                        SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal,
                          child: Row(
                            children: categories.map((c) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(
                                  right: 7,
                                ),
                                child: ChoiceChip(
                                  label: Text(c),
                                  selected: category == c,
                                  onSelected: (_) {
                                    setState(() {
                                      category = c;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 2),

                        // DIET FILTER AND FAVOURITES

                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 4,
                                children: [
                                  'All',
                                  'Vegetarian',
                                  'Non-Veg',
                                ].map((value) {
                                  return Row(
                                    mainAxisSize:
                                        MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        value: value,
                                        groupValue:
                                            dietFilter,
                                        visualDensity:
                                            VisualDensity
                                                .compact,
                                        onChanged: (selected) {
                                          setState(() {
                                            dietFilter =
                                                selected ??
                                                    'All';
                                          });
                                        },
                                      ),
                                      Text(
                                        value,
                                        style: Theme.of(
                                          context,
                                        )
                                            .textTheme
                                            .labelSmall,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),

                            FilterChip(
                              label: const Text(
                                'Favourites',
                              ),
                              selected: favouritesOnly,
                              onSelected: (value) {
                                setState(() {
                                  favouritesOnly = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // SAVED RECIPES

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16, 16, 16, 4,
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.text('savedRecipes'),
                      style: Theme.of(context)
                          .textTheme.titleLarge,
                    ),
                    const Spacer(),
                    Text('${visible.length} recipes'),
                  ],
                ),
              ),
            ),

            if (visible.isEmpty)
              SliverToBoxAdapter(
                child: _emptyState(
                  title: l10n.text('noRecipes'),
                  message:
                      l10n.text('noRecipesHint'),
                  icon: Icons.menu_book_outlined,
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final recipe = visible[index];

                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: RecipeCard(
                        recipe: recipe,
                        onFavourite: () =>
                            toggleFavourite(recipe),
                        onEdit:
                            recipe.id.startsWith(
                                      'community:',
                                    ) ||
                                    recipe.id.startsWith(
                                      'api:',
                                    )
                                ? null
                                : () => openRecipeForm(
                                      recipe: recipe,
                                    ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(
                                recipe: recipe,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: visible.length,
                ),
              ),

            // PUBLIC RECIPES HEADING

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16, 22, 16, 8,
                ),
                child: Text(
                  l10n.text('publicRecipes'),
                  style: Theme.of(context)
                      .textTheme.titleLarge,
                ),
              ),
            ),

            // PUBLIC RECIPES

            _buildPublicRecipes(),

            // COMMUNITY HEADING

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16, 24, 16, 8,
                ),
                child: Text(
                  l10n.text('community'),
                  style: Theme.of(context)
                      .textTheme.titleLarge,
                ),
              ),
            ),

            // COMMUNITY RECIPES

            _buildCommunityRecipes(),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}

// STICKY FILTER HEADER

class _StickyFilterHeader
    extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const _StickyFilterHeader({
    required this.height,
    required this.child,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(
    covariant _StickyFilterHeader oldDelegate,
  ) {
    return oldDelegate.height != height ||
        oldDelegate.child != child;
  }
}
