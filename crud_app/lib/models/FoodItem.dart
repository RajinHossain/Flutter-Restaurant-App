class FoodItem {
  String category;
  String description;
  String foodName;
  String foodThumbnail;
  bool notAvailable;
  bool special;
  num price;

  FoodItem(this.category, this.description, this.foodName, this.foodThumbnail,
      this.notAvailable, this.special, this.price);

  dynamic toJson() {
    return {
      'category': category,
      'description': description,
      'food_name': foodName,
      'food_thumbnail': foodThumbnail,
      'not_available': notAvailable,
      'price': price,
      'special': special
    };
  }

  FoodItem.fromJson(dynamic json)
      : category = json['category'],
        description = json['description'],
        foodName = json['food_name'],
        foodThumbnail = json['food_thumbnail'],
        notAvailable = json['not_available'],
        price = json['price'],
        special = json['special'];
}
