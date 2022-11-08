import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/HeroDialogRoute.dart';
import 'package:crud_app/read%20data/get_description.dart';
import 'package:crud_app/read%20data/get_food_items.dart';
import 'package:crud_app/widgets/MenuLayout.dart';
import 'package:crud_app/read%20data/get_name.dart';
import 'package:crud_app/widgets/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 25, 0),
            child: AppBar(
              foregroundColor: Colors.black,
              title: GetName(documentId: user.uid),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Color.fromRGBO(100, 115, 255, 1),
        child: ListView(
          padding: EdgeInsets.only(top: 80),
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: DrawerHeader(
                child: Text(
                  'Your \nMenu Launch \nDrawer',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Settings',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          'Restaurant Account',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Generate',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          'Create/View Menu QR Code',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Menu',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          'Create/View Menu',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Want to log out?',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        GestureDetector(
                          onTap: () => FirebaseAuth.instance.signOut(),
                          child: const Text(
                            'Log out from your account',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
          child: Column(
        children: [
          GetDescription(documentId: user.uid),
          const SizedBox(
            height: 20,
          ),
          MenuLayout(documentId: user.uid.toString())
        ],
      )),
    );
  }
}
