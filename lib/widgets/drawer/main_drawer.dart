import 'package:flutter/material.dart';
import 'package:meals_app/widgets/drawer/main_drawer_item.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsetsGeometry.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 19),
                Text(
                  'Cooking Up',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          MainDrawerItem(
            title: 'Meals',
            leadingIcon: Icons.restaurant,
            onTransition: () {
              onSelectScreen('meals');
            },
          ),
          MainDrawerItem(
            title: 'Filters',
            leadingIcon: Icons.settings,
            onTransition: () {
              onSelectScreen('filters');
            },
          ),
        ],
      ),
    );
  }
}
