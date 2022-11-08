import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetName extends StatelessWidget {
  final String documentId;
  const GetName({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('restaurants');

    final style = TextStyle(color: Colors.black, fontSize: 25);

    return FutureBuilder<DocumentSnapshot>(
        future: restaurants.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text(
              '${data['name']}',
              style: style,
            );
          }
          return Text(
            'Your Restaurant',
            style: style,
          );
        }));
  }
}
