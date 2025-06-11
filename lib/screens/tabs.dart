import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/category.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/drawer/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

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
  Map<Filter, bool> _selectedFilters = kInitialFilters;

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

  void _setScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      final result = await Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(
          builder: (ctx) =>
               FiltersScreen(currentFilters: _selectedFilters),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals
        .where(
          (meal) => switch (meal) {
            var el
                when _selectedFilters[Filter.glutenFree]! && !el.isGlutenFree =>
              false,
            var el
                when _selectedFilters[Filter.lactoseFree]! &&
                    !el.isLactoseFree =>
              false,
            var el
                when _selectedFilters[Filter.vegetarian]! && !el.isVegetarian =>
              false,
            var el when _selectedFilters[Filter.vegan]! && !el.isVegan => false,
            _ => true,
          },
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 1 ? "Favorites" : "Categoriess"),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: _selectedPageIndex == 0
          ? CategoryScreen(
              onToggleFavorite: _toggleMealFavoriteStatus,
              availableMeals: availableMeals,
            )
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
