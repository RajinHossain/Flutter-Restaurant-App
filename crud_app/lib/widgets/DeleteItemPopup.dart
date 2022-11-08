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

class DeleteItemPopup extends StatefulWidget {
  final FoodItem itemToDelete;

  const DeleteItemPopup({
    Key? key,
    required this.itemToDelete,
  }) : super(key: key);

  @override
  State<DeleteItemPopup> createState() => DeleteItemPopupState();
}

class DeleteItemPopupState extends State<DeleteItemPopup> {
  Future deleteItem() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        // Remove the updated food item
        await FirebaseFirestore.instance
            .collection('menus')
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .update({
          "food_items": FieldValue.arrayRemove([widget.itemToDelete.toJson()])
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
          padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
          child: Hero(
            tag: 'delete-item-popup',
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
                          widget.itemToDelete.foodName,
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
                            {deleteItem(), Navigator.of(context).pop()},
                        labelText: 'Delete Food Item',
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
