import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegan: false,
        Filter.vegetarian: false,
      });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvied = StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
  (ref) => FilterNotifier(),
);

//можно делать несколько провайдеров в одном файле если они тесно связаны друг с другом

final filteredMealsProvider = Provider((ref) { //связать провайдеры можно с помощью ref
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvied);

  return meals
      .where(
        (meal) => switch (meal) {
          var el when activeFilters[Filter.glutenFree]! && !el.isGlutenFree =>
            false,
          var el when activeFilters[Filter.lactoseFree]! && !el.isLactoseFree =>
            false,
          var el when activeFilters[Filter.vegetarian]! && !el.isVegetarian =>
            false,
          var el when activeFilters[Filter.vegan]! && !el.isVegan => false,
          _ => true,
        },
      )
      .toList();
});
