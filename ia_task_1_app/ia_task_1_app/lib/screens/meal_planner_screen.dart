import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/local_storage_service.dart';

class MealPlannerScreen extends StatefulWidget {
  final List<Recipe> recipes;
  final LocalStorageService storage;
  const MealPlannerScreen({
    super.key,
    required this.recipes,
    required this.storage,
  });

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  static const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  late Map<String, String> plan;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    plan = widget.storage.loadMealPlan();
  }

  Future<void> chooseMeal(String day) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Meal for $day'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('Clear meal'),
          ),
          ...widget.recipes.map(
            (recipe) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, recipe.title),
              child: Text(recipe.title),
            ),
          ),
        ],
      ),
    );
    if (selected == null || !mounted) return;
    final updated = Map<String, String>.of(plan);
    if (selected.isEmpty) {
      updated.remove(day);
    } else {
      updated[day] = selected;
    }
    setState(() => saving = true);
    try {
      await widget.storage.saveMealPlan(updated);
      if (mounted) setState(() => plan = updated);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save meal. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Meal Planner')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Choose one main meal for each day. Your plan is saved on this device.',
          ),
          const SizedBox(height: 12),
          for (final day in days)
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(day),
                subtitle: Text(plan[day] ?? 'No meal selected'),
                trailing: const Icon(Icons.edit_outlined),
                onTap: saving ? null : () => chooseMeal(day),
              ),
            ),
        ],
      ),
    );
  }
}
