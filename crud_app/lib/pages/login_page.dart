import 'package:crud_app/widgets/Button.dart';
import 'package:crud_app/widgets/InputBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool validateSignIn() {
    if (_emailController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future signIn() async {
    if (validateSignIn()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Please enter correct details.'),
                  content: Text(e.message.toString()));
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Please enter valid details.'),
              content: Text(
                  'The details you have entered are malformed and not valid.'),
            );
          });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
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
                      'Create, Update, and Maintain',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20),
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
                      'Your Menus',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InputBox(
                    controller: _emailController,
                    labelText: 'Email',
                    isPassword: false,
                    isReadOnly: false,
                    isPrimary: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputBox(
                    controller: _passwordController,
                    labelText: 'Password',
                    isPassword: true,
                    isReadOnly: false,
                    isPrimary: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgotPasswordPage();
                            }));
                          },
                          child: Text('Forgot Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  DefaultButton(onTap: signIn, labelText: 'Log in'),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultButton(
                      onTap: widget.showRegisterPage, labelText: 'Register'),
                ],
              ),
            ),
          ),
        ));
  }
}
