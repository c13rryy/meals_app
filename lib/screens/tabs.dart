import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/screens/category.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/drawer/main_drawer.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  /* Во Flutter состояние StatefulWidget отслеживает только то, что вы помещаете внутрь setState. Но если Widget был создан в initState, он больше не пересоздаётся. Поэтому изменения в _favoritesMeals не отражаются в уже созданном MealsScreen. */

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) {
    Navigator.pop(context);
    if (identifier == 'filters') {
      Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);
    final favoriteMeals = ref.watch(favoriteMelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 1 ? "Favorites" : "Categoriess"),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: _selectedPageIndex == 0
          ? CategoryScreen(availableMeals: availableMeals)
          : MealsScreen(meals: favoriteMeals),
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
