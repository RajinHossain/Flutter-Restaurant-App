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

class AddCategoryPopup extends StatefulWidget {
  final List<String> categories;

  const AddCategoryPopup({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  State<AddCategoryPopup> createState() => AddCategoryPopupState();
}

class AddCategoryPopupState extends State<AddCategoryPopup> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future deleteCategory() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        // Add the updated food item
        if (!widget.categories.contains(_nameController.text.trim())) {
          await FirebaseFirestore.instance
              .collection('menus')
              .doc(FirebaseAuth.instance.currentUser?.uid.toString())
              .update({
            "categories": FieldValue.arrayUnion([_nameController.text.trim()])
          });
        }
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
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Hero(
            tag: 'add-category-hero',
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
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: const Text(
                          'Add Category',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      InputBox(
                        controller: _nameController,
                        labelText: 'Category Name',
                        isReadOnly: false,
                        isPassword: false,
                        isPrimary: false,
                        hintText: 'Vegan',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                        onTap: () =>
                            {deleteCategory(), Navigator.of(context).pop()},
                        labelText: 'Add Category',
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
