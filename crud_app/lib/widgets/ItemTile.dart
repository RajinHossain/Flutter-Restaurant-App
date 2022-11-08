import 'package:crud_app/models/FoodItem.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final FoodItem foodItem;
  const ItemTile({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    BlendMode.dstOut),
                image: NetworkImage(foodItem.foodThumbnail))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: Text(
                foodItem.foodName,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                '\$' + foodItem.price.toString(),
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
