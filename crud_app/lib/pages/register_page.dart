import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/widgets/Button.dart';
import 'package:crud_app/widgets/InputBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future signUp() async {
    if (validateSignUp()) {
      if (passwordConfirmed()) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

          await addUserDetails();
          await addMenuDetails();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Account created.'),
                  content: Text(
                      'An account for ${_nameController.text.toString().trim()} has been created.'),
                );
              });
        } on FirebaseAuthException catch (e) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(e.message.toString()),
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Password does not match.'),
                content:
                    Text('The passwords provided are not matching. Try again.'),
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Please enter valid details.'),
              content: Text(
                  'The details you have provided are malformed and not valid.'),
            );
          });
    }
  }

  bool validateSignUp() {
    if (_nameController.text.toString().trim().isEmpty ||
        _descriptionController.text.toString().trim().isEmpty ||
        _emailController.text.toString().trim().isEmpty ||
        _passwordController.text.toString().trim().isEmpty ||
        _confirmPasswordController.text.toString().trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future addUserDetails() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .set({
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'email': _emailController.text.trim(),
      });
    }
  }

  // TODO: fix this later but this has pre-written data
  Future addMenuDetails() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('menus')
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .set({
        'categories': ['Vegan', 'Vegetarian', 'Lunch'],
        'food_items': [
          {
            'category': 'Vegan',
            'food_name': 'Vegan Burger',
            'food_thumbnail':
                'https://hercanberra.com.au/wp-content/uploads/2018/03/vegan-burger-food_feature.jpg',
            'description': 'Vegan burger made with vegan stuff.',
            'not_available': false,
            'special': false,
            'price': 20
          },
          {
            'category': 'Lunch',
            'food_name': 'Cheap Pizza',
            'food_thumbnail':
                'https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/216054.jpg',
            'description': 'Cheapest pizza with the best value for your bucks.',
            'not_available': true,
            'special': false,
            'price': 15.5
          },
          {
            'category': 'Vegetarian',
            'food_name': 'Vegetarian Icecream',
            'food_thumbnail':
                'https://www.thespruceeats.com/thmb/RrP9qTWy2BbntDB6GCwWi8Yy29U=/3000x2000/filters:fill(auto,1)/UbeIceCreamHERO-ae953a4c3ede4690bd2f0ccbc104ea12.jpg',
            'description':
                'Vegetarian icecream made from vegetables and stufff.',
            'not_available': false,
            'special': true,
            'price': 12.3
          },
          {
            'category': 'Vegetarian',
            'food_name': 'Aubergine Veggie Chilli',
            'food_thumbnail':
                'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/burnt-aubergine-chilli-afd2f29.jpg',
            'description':
                'Vegetarian Aubergine Veggie Chilli made from vegetables and stufff.',
            'not_available': false,
            'special': true,
            'price': 10.90
          },
          {
            'category': 'Vegan',
            'food_name': 'Vegan Tacos',
            'food_thumbnail':
                'https://www.acouplecooks.com/wp-content/uploads/2022/01/Vegan-Tacos-013.jpg',
            'description':
                'Vegan Tacos made from vegan cheese and fake meat and stufff.',
            'not_available': false,
            'special': true,
            'price': 17.3
          }
        ]
      });
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Text(
                        'Menu Launch',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Text(
                        'Create Your Account',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InputBox(
                      controller: _nameController,
                      labelText: 'Restaurant Name',
                      isPassword: false,
                      isReadOnly: false,
                      isPrimary: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputBox(
                      controller: _descriptionController,
                      labelText: 'Restaurant Description',
                      isPassword: false,
                      isReadOnly: false,
                      isPrimary: false,
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputBox(
                      controller: _emailController,
                      labelText: 'Email',
                      isPassword: false,
                      isReadOnly: false,
                      isPrimary: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputBox(
                      controller: _passwordController,
                      labelText: 'Password',
                      isPassword: true,
                      isReadOnly: false,
                      isPrimary: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputBox(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      isPassword: true,
                      isReadOnly: false,
                      isPrimary: false,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    DefaultButton(onTap: signUp, labelText: 'Sign Up'),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultButton(
                        onTap: widget.showLoginPage, labelText: 'Log In'),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
