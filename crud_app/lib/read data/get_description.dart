import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetDescription extends StatelessWidget {
  final String documentId;
  const GetDescription({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('restaurants');

    return FutureBuilder<DocumentSnapshot>(
        future: restaurants.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            if (data != null) {
              return Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    '${data['description']}',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ),
              );
            }
          }
          return const Text(
            'Loading...',
            textAlign: TextAlign.start,
          );
        }));
  }
}
