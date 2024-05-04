// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "lib.dart";

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController __emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmController = TextEditingController();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
      statusBarIconBrightness: Brightness
          .dark, // Set status bar icons to dark (for light backgrounds)
    ));

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set app bar background color to white
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView for scrollable behavior
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 60), // Adjust space
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 24, // Adjust font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set text color to black
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60), // Adjust space
              // Full Name Field
              buildTextField(
                  icon: Icons.person_outline,
                  hintText: "Full Name",
                  textFieldController: _nameController),
              const SizedBox(height: 20),
              // Email Field
              buildTextField(
                  icon: Icons.email_outlined,
                  hintText: "Email",
                  textFieldController: __emailController),
              const SizedBox(height: 20),
              // Password Field
              buildTextField(
                  icon: Icons.lock_outline,
                  hintText: "Password",
                  isPassword: true,
                  textFieldController: _passwordController),
              const SizedBox(height: 20),
              // Confirm Password Field
              buildTextField(
                  icon: Icons.lock_outline,
                  hintText: "Confirm Password",
                  isPassword: true,
                  textFieldController: _confirmController),
              const SizedBox(height: 30), // Adjust space
              // Terms of Use Text
              const Text(
                'By signing you agree to our Terms of use and privacy notice',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey, // Set text color to grey
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30), // Adjust space
              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  print("object");
                  registerWithEmailAndPassword(
                      _nameController.text,
                      __emailController.text,
                      _passwordController.text,
                      _confirmController.text,
                      context);
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF426D53), // Set button color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded border
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Login Text
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Do you have an account? Log in",
                    style: TextStyle(
                      color: Colors.black54, // Set text color to black54
                      decoration: TextDecoration.underline, // Underline text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerWithEmailAndPassword(String name, String email, String password,
      String cpassword, BuildContext context) async {
    if (password == cpassword) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print(
            '[Print] User registered successfully: ${userCredential.user!.uid}');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("User registered successfully"),
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
        if (e.code == 'weak-password') {
          print('[Print] The password provided is too weak.');

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Weak Password"),
                content: Text("The password provided is too weak"),
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
        } else if (e.code == 'email-already-in-use') {
          print('[Print] The account already exists for that email.');

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Email already in use"),
                content: Text("The account already exists for that email"),
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
      } catch (e) {
        print(e);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Password incorrect"),
            content: Text("Password box not match Confirm Password"),
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

  void AddMyPlants(String name, String datePlanted) {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection('my_plants');
    collRef.add({
      'name': name,
      'date_planted': datePlanted,
    });
  }
}
