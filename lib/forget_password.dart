import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "lib.dart";

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailoController = TextEditingController();

  @override
  void dispose() {
    _emailoController.dispose();
    super.dispose();
  }

  Future PasswordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailoController.text.trim());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text(
                'If the email address exist, a password reset link will be sent. Kindly check your email inbox for further instructions.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginApp()),
                  );
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
                'Enter Your Email and we will send you  a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 10),
          buildTextField(
              icon: Icons.email_outlined,
              hintText: "Email",
              textFieldController: _emailoController),
          SizedBox(height: 10),
          MaterialButton(
            color: Color(0xFF426D53),
            onPressed: PasswordReset,
            child: Text(
              'Reset Password ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
