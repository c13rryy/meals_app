import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/category.dart';
import 'package:meals_app/screens/meals.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoritesMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /* Во Flutter состояние StatefulWidget отслеживает только то, что вы помещаете внутрь setState. Но если Widget был создан в initState, он больше не пересоздаётся. Поэтому изменения в _favoritesMeals не отражаются в уже созданном MealsScreen. */
  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoritesMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoritesMeals.remove(meal);
      });
      _showInfoMessage('Meal in no longer a favorite');
    } else {
      setState(() {
        _favoritesMeals.add(meal);
      });
      _showInfoMessage('Marked as a favorite');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 1 ? "Favorites" : "Categoriess"),
      ),
      body: _selectedPageIndex == 0
          ? CategoryScreen(onToggleFavorite: _toggleMealFavoriteStatus)
          : MealsScreen(
              meals: _favoritesMeals,
              onToggleFavorite: _toggleMealFavoriteStatus,
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
