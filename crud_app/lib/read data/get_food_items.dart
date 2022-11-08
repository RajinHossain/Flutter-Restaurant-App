import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetFoodItems extends StatefulWidget {
  final String documentId;
  final String category;
  // ignore: use_key_in_widget_constructors
  const GetFoodItems({required this.documentId, required this.category});

  @override
  State<GetFoodItems> createState() => _GetFoodItems();
}

class _GetFoodItems extends State<GetFoodItems> {
  CollectionReference menus = FirebaseFirestore.instance.collection('menus');
  late Future<DocumentSnapshot> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = _getCategories();
  }

  Future<DocumentSnapshot> _getCategories() async {
    return await menus.doc(widget.documentId).get();
  }

  TextStyle style = TextStyle(color: Colors.black, fontSize: 25);
  Color defaultColor = Color.fromARGB(255, 206, 206, 206);
  Color selectedColor = Color.fromRGBO(100, 115, 255, 1);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: categoriesFuture,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            List<dynamic> foodItems = data['food_items'];

            if (widget.category != 'All') {
              foodItems = data['food_items']
                  .where((element) => element['category'] == widget.category)
                  .toList();
            }

            return (Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 500, child: Text('')),
                ],
              ),
            ));
          }
          return const Center(child: CircularProgressIndicator());
        }));
  }
}
