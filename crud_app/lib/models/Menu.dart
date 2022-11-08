import 'package:crud_app/models/FoodItem.dart';

class Menu {
  List<String>? categories;
  List<FoodItem>? foodItems;

  Menu(this.categories, this.foodItems);

  dynamic toJson() {
    return {
      'categories': categories,
      'food_items': foodItems,
    };
  }

  Menu.fromJson(Map<String, dynamic> json) {
    categories =
        (json['categories'] ? (json['categories'] as List) : []).cast<String>();
    foodItems = [];
    json['food_items']
        ? (json['food_items'] as List).forEach((e) {
            foodItems!.add(FoodItem.fromJson(e));
          })
        : [];
  }
}
