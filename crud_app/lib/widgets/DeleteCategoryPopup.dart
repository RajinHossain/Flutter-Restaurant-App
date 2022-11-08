import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/FoodItem.dart';
import 'package:image/image.dart' as img;

import 'Button.dart';
import 'CheckBox.dart';
import 'Dropdown.dart';
import 'InputBox.dart';

class DeleteCategoryPopup extends StatefulWidget {
  final int categoryToDeleteIndex;
  final List<String> categories;
  final List<FoodItem> foodItems;

  const DeleteCategoryPopup({
    Key? key,
    required this.categoryToDeleteIndex,
    required this.categories,
    required this.foodItems,
  }) : super(key: key);

  @override
  State<DeleteCategoryPopup> createState() => DeleteCategoryPopupState();
}

class DeleteCategoryPopupState extends State<DeleteCategoryPopup> {
  validateDeletion() async {
    // Validate deletion - check to see if the category can be deleted
    if (widget.foodItems.any((foodItem) =>
        foodItem.category == widget.categories[widget.categoryToDeleteIndex])) {
      return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cannot Delete Category'),
              content: Text(
                  'Please ensure no food items have ${widget.categories[widget.categoryToDeleteIndex]} as the category'),
            );
          });
    } else {
      return true;
    }
  }

  Future deleteCategory() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        if (await validateDeletion() != true) {
          return;
        }
        // Remove the updated food item
        await FirebaseFirestore.instance
            .collection('menus')
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .update({
          "categories": FieldValue.arrayRemove(
              [widget.categories[widget.categoryToDeleteIndex]])
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
          child: Hero(
            tag: 'delete-category-popup',
            child: Material(
              color: const Color.fromRGBO(100, 115, 255, 1),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                        child: Text(
                          widget.categories[widget.categoryToDeleteIndex],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                        onTap: () =>
                            {deleteCategory(), Navigator.of(context).pop()},
                        labelText: 'Delete Category',
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
