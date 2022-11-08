import 'package:crud_app/widgets/Button.dart';
import 'package:crud_app/widgets/InputBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sent.'),
              content: Text('Password reset link sent.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error.'),
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 115, 255, 1),
        foregroundColor: Colors.white,
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: double.infinity,
                child: Text(
                  'Password Reset',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: double.infinity,
                child: Text(
                  'Please enter your email so we can send a reset link.',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 15),
            InputBox(
                controller: _emailController,
                labelText: 'Email',
                isReadOnly: false,
                isPassword: false,
                isPrimary: true),
            SizedBox(height: 15),
            DefaultButton(onTap: passwordReset, labelText: 'Reset Password')
          ],
        ),
      ),
    );
  }
}
