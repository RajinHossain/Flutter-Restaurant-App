import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/HeroDialogRoute.dart';
import 'package:crud_app/models/FoodItem.dart';
import 'package:crud_app/models/Menu.dart';
import 'package:crud_app/read%20data/get_food_items.dart';
import 'package:crud_app/widgets/AddCategoryPopup.dart';
import 'package:crud_app/widgets/CheckBox.dart';
import 'package:crud_app/widgets/DeleteCategoryPopup.dart';
import 'package:crud_app/widgets/DeleteItemPopup.dart';
import 'package:crud_app/widgets/Dropdown.dart';
import 'package:crud_app/widgets/InputBox.dart';
import 'package:crud_app/widgets/ItemPopup.dart';
import 'package:crud_app/widgets/ItemTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/widgets/Button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'AddItemPopup.dart';

class MenuLayout extends StatefulWidget {
  final String documentId;
  // ignore: use_key_in_widget_constructors
  const MenuLayout({required this.documentId});

  @override
  State<MenuLayout> createState() => _MenuLayoutState();
}

class _MenuLayoutState extends State<MenuLayout> {
  CollectionReference menus = FirebaseFirestore.instance.collection('menus');
  String _selectedItem = 'All';
  late Future<DocumentSnapshot> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = _getCategories();
  }

  Future<DocumentSnapshot> _getCategories() async {
    return await menus.doc(widget.documentId).get();
  }

  _updateSelectedItem(item) async {
    setState(() {
      _selectedItem = item;
    });
  }

  TextStyle style = TextStyle(color: Colors.black, fontSize: 25);
  Color defaultColor = Color.fromARGB(255, 206, 206, 206);
  Color selectedColor = Color.fromRGBO(100, 115, 255, 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // This StreamBuilder constructs the categories ListView and also the GridView for food items
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('menus')
                .doc(widget.documentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null) {
                  List<String> categories = [];
                  List<dynamic> foodItems = [];

                  if (snapshot.data != null &&
                      (snapshot.data as DocumentSnapshot)['categories'] !=
                          null) {
                    categories = List.from(
                        (snapshot.data as DocumentSnapshot)['categories']);

                    foodItems = List.from(
                        (snapshot.data as DocumentSnapshot)['food_items']);
                    for (var i = 0; i < foodItems.length; i++) {
                      foodItems[i] = FoodItem.fromJson(
                          Map<String, dynamic>.from(foodItems[i]));
                    }
                  }
                  categories.insert(0, 'All');

                  if (_selectedItem != 'All') {
                    foodItems = foodItems
                        .where((element) => element.category == _selectedItem)
                        .toList();
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 150,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                                child: Text(
                                  'Categories',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                                width: 150,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(HeroDialogRoute(builder: (context) {
                                  return AddCategoryPopup(
                                      categories: categories);
                                }));
                              },
                              child: Hero(
                                tag: 'add-category-hero',
                                child: SizedBox(
                                  height: 35,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.add,
                                          size: 25,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 30,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                // Other categories
                                ...categories.map(
                                  (category) => GestureDetector(
                                    onTap: () async {
                                      await _updateSelectedItem(category);
                                    },
                                    onLongPress: () {
                                      Navigator.of(context).push(
                                          HeroDialogRoute(builder: (context) {
                                        return DeleteCategoryPopup(
                                          categories: categories,
                                          categoryToDeleteIndex:
                                              categories.indexOf(category),
                                          foodItems: foodItems.cast<FoodItem>(),
                                        );
                                      }));
                                    },
                                    child: Hero(
                                      tag:
                                          'delete-category-popup${categories.indexOf(category)}',
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: _selectedItem == category
                                                  ? selectedColor
                                                  : defaultColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child: Center(
                                                child: Text(
                                              category,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Text(
                              'Menu Items',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            SingleChildScrollView(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 370,
                                child: GridView.builder(
                                  itemCount: foodItems.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemBuilder: (context, index) {
                                    FoodItem foodItem = foodItems[index];
                                    return Hero(
                                      tag: 'item-popup$index',
                                      child: GestureDetector(
                                          onLongPress: () {
                                            Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                              return DeleteItemPopup(
                                                  itemToDelete: foodItem);
                                            }));
                                          },
                                          onTap: () {
                                            Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                              return ItemPopup(
                                                  foodItemIndex: foodItems
                                                      .indexOf(foodItem),
                                                  foodItem: foodItem,
                                                  categories: categories);
                                            }));
                                          },
                                          child: ItemTile(foodItem: foodItem)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 340,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          HeroDialogRoute(builder: (context) {
                                        return AddItemPopup(
                                            categories: categories);
                                      }));
                                    },
                                    child: Hero(
                                      tag: 'add-item-hero',
                                      child: Material(
                                        color: Color.fromRGBO(100, 115, 255, 1),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(64)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Icon(
                                            Icons.fastfood_sharp,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const Text('Not possible to load...');
              }
            }),
      ],
    );
  }
}
