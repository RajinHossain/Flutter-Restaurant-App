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

class ItemPopup extends StatefulWidget {
  final FoodItem foodItem;
  final int foodItemIndex;
  final List<String> categories;

  const ItemPopup({
    Key? key,
    required this.foodItem,
    required this.categories,
    required this.foodItemIndex,
  }) : super(key: key);

  @override
  State<ItemPopup> createState() => ItemPopupState();
}

class ItemPopupState extends State<ItemPopup> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  dynamic _imageFile;
  String _imageFileURL = '';
  String _selectedCategory = '';
  bool _isNotAvailable = false;
  bool _isSpecial = false;

  @override
  void initState() {
    _nameController.text = widget.foodItem.foodName;
    _descriptionController.text = widget.foodItem.description;
    _priceController.text = '${widget.foodItem.price}';
    _selectedCategory = widget.foodItem.category;
    _isNotAvailable = widget.foodItem.notAvailable;
    _isSpecial = widget.foodItem.special;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  _openCamera() async {
    await ImagePicker()
        .pickImage(source: ImageSource.camera)
        .then((image) async {
      if (image != null) {
        final img.Image? capturedImage =
            img.decodeImage(List.from(await image.readAsBytes()));
        img.Image orientedImage = (img.copyRotate(capturedImage!, 90));
        await File(image.path)
            .writeAsBytes(img.encodeJpg(orientedImage))
            .then((value) => {
                  setState(() {
                    _imageFile = File(value.path);
                  })
                });
      }
    });
  }

  Future updateMenuDetail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        // Upload image to file storage and get the image download link
        if (_imageFile != null) {
          await FirebaseStorage.instance
              .ref(
                  '${FirebaseAuth.instance.currentUser!.uid}/${(_imageFile as File).path}')
              .putFile(_imageFile);

          _imageFileURL = await FirebaseStorage.instance
              .ref(
                  '${FirebaseAuth.instance.currentUser!.uid}/${(_imageFile as File).path}')
              .getDownloadURL();
        }

        // Remove the food item
        await FirebaseFirestore.instance
            .collection('menus')
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .update({
          "food_items": FieldValue.arrayRemove([widget.foodItem.toJson()])
        });
        // Add the updated food item
        await FirebaseFirestore.instance
            .collection('menus')
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .update({
          "food_items": FieldValue.arrayUnion([
            FoodItem(
                    _selectedCategory,
                    _descriptionController.text.trim(),
                    _nameController.text.trim(),
                    _imageFile != null
                        ? _imageFileURL
                        : widget.foodItem.foodThumbnail,
                    _isNotAvailable,
                    _isSpecial,
                    double.parse(_priceController.text.trim()))
                .toJson()
          ])
        });
      } catch (e) {
        print(e);
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Hero(
          tag: 'item-hero',
          child: Material(
            color: const Color.fromRGBO(100, 115, 255, 1),
            elevation: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'Edit ${widget.foodItem.foodName}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).pop();
                          }),
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'Uploaded Image',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        const Color.fromARGB(255, 0, 0, 0)
                                            .withOpacity(0),
                                        BlendMode.dstOut),
                                    image: _imageFile != null
                                        ? FileImage(_imageFile!)
                                            as ImageProvider
                                        : NetworkImage(
                                            widget.foodItem.foodThumbnail))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultButton(
                      onTap: () => {_openCamera()},
                      labelText: 'Change Image',
                      isPrimary: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Food Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                            textAlign: TextAlign.start,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: InputBox(
                              controller: _nameController,
                              labelText: 'Food Name',
                              hintText: 'Your new dish...',
                              isPassword: false,
                              isReadOnly: false,
                              isPrimary: false,
                              padding: const [25, 0, 10, 0],
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: InputBox(
                                controller: _priceController,
                                labelText: 'Price',
                                hintText: '12.50',
                                isPassword: false,
                                isReadOnly: false,
                                isPrimary: false,
                                padding: const [10, 0, 25, 0],
                                centerText: true,
                                isNumber: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputBox(
                      controller: _descriptionController,
                      labelText: 'Food Description',
                      hintText: 'This amazing food is made from...',
                      isPassword: false,
                      isReadOnly: false,
                      isPrimary: false,
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DefaultDropdown(
                      labelText: 'Select Category',
                      selectedItem: _selectedCategory,
                      items: widget.categories,
                      onChange: (value) => {
                        setState(() {
                          _selectedCategory = value;
                        })
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DefaultCheckBox(
                        onChange: (value) => {
                              setState(() {
                                _isNotAvailable = value;
                              })
                            },
                        labelText: 'Is this item not currently available?',
                        value: _isNotAvailable),
                    DefaultCheckBox(
                        onChange: (value) => {
                              setState(() {
                                _isNotAvailable = value;
                              })
                            },
                        labelText: 'Is this item a special item?',
                        value: _isSpecial),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DefaultButton(
                      onTap: () =>
                          {updateMenuDetail(), Navigator.of(context).pop()},
                      labelText: 'Finalise',
                      isPrimary: false,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
