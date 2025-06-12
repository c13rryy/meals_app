import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavMealsNotifier extends StateNotifier<List<Meal>> {
  FavMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state.where((el) => el.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMelsProvider =
    StateNotifierProvider<FavMealsNotifier, List<Meal>>(((ref) {
      //добавили тип который класс возвращает
      //класс управлющий состоянием 
      //тип состония которым управлет этот класс
      return FavMealsNotifier();
    }));
