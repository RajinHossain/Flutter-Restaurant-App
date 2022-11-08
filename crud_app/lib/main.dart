import 'package:crud_app/auth/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crud_app/auth/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // gives access to native code
  await Firebase.initializeApp(); // initialise firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
