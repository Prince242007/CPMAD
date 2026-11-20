import '../models/recipe.dart';

List<Recipe> createSampleRecipes() => [
  Recipe(
    id: 'poha',
    title: 'Vegetable Poha',
    category: 'Breakfast',
    ingredients: [
      '1 cup poha',
      '1 chopped onion',
      '1/2 cup peas',
      '1 tbsp oil',
      'Salt and turmeric',
      'Lemon juice',
    ],
    steps: [
      'Rinse poha gently and drain.',
      'Heat oil and cook onion and peas until tender.',
      'Add turmeric, salt and poha. Stir gently for 3 minutes.',
      'Finish with lemon juice and serve.',
    ],
  ),
  Recipe(
    id: 'oats',
    title: 'Banana Oats',
    category: 'Breakfast',
    ingredients: [
      '1/2 cup oats',
      '1 cup milk',
      '1 banana',
      '1 tsp honey (optional)',
    ],
    steps: [
      'Simmer oats with milk for 5 minutes, stirring.',
      'Slice banana and add it to the cooked oats.',
      'Add honey if desired and serve warm.',
    ],
  ),
  Recipe(
    id: 'paneer',
    title: 'Paneer Rice Bowl',
    category: 'Lunch',
    ingredients: [
      '1 cup cooked rice',
      '100 g paneer cubes',
      '1/2 cup chopped vegetables',
      '1 tsp oil',
      'Salt and pepper',
    ],
    steps: [
      'Heat oil and cook vegetables until tender.',
      'Add paneer and cook for 3 minutes.',
      'Add cooked rice, salt and pepper. Mix and heat thoroughly.',
    ],
  ),
  Recipe(
    id: 'dal',
    title: 'Simple Dal',
    category: 'Dinner',
    ingredients: [
      '1/2 cup yellow lentils',
      '2 cups water, plus extra if needed',
      '1 chopped tomato',
      '1/4 tsp turmeric',
      'Salt',
      '1 tsp ghee',
      '1/2 tsp cumin seeds',
    ],
    steps: [
      'Rinse lentils and simmer with water, tomato and turmeric until fully soft, adding water if needed.',
      'Add salt and mash lightly.',
      'Heat ghee, add cumin and let it sizzle.',
      'Pour the tempering into the dal. Stir and serve.',
    ],
  ),
  Recipe(
    id: 'sandwich',
    title: 'Vegetable Sandwich',
    category: 'Snacks',
    ingredients: [
      '2 bread slices',
      '1 small cucumber',
      '1 tomato',
      '1 tbsp green chutney',
      'Salt',
    ],
    steps: [
      'Wash and slice cucumber and tomato.',
      'Spread chutney on bread.',
      'Add vegetables and a little salt.',
      'Close the sandwich and toast if desired.',
    ],
  ),
  Recipe(
    id: 'salad',
    title: 'Chickpea Salad',
    category: 'Lunch',
    ingredients: [
      '1 cup cooked chickpeas',
      '1 cucumber',
      '1 tomato',
      '1 tbsp lemon juice',
      'Salt and pepper',
    ],
    steps: [
      'Chop washed cucumber and tomato.',
      'Combine with cooked chickpeas.',
      'Add lemon juice, salt and pepper. Mix and serve.',
    ],
  ),
];
