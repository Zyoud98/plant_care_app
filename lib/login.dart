import 'package:firebase_auth/firebase_auth.dart';
import "lib.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
      statusBarIconBrightness: Brightness
          .dark, // Set status bar icons to dark (for light backgrounds)
    ));

    return MaterialApp(
      title: 'Login Authentication',
      theme: ThemeData(
        primaryColor: Color(0xFF426D53),
        fontFamily: 'Raleway',
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: Text('Login Page'),
      //     ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              // height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("./assets/images/image3.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome 🌿',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 24, // Adjust font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF426D53),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 15, // Adjust font size
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // Set text color to black
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20), // Adjust space
                // Full Name Field                  // Email Field
                buildTextField(
                  textFieldController: _emailController,
                  icon: Icons.email_outlined,
                  hintText: "Email",
                ),
                const SizedBox(height: 20),
                // Password Field
                buildTextField(
                  textFieldController: _passwordController,
                  icon: Icons.lock_outline,
                  hintText: "Password",
                  isPassword: true,
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgetPasswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
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
                const SizedBox(height: 30),
                // Adjust space
                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    print("Hi");
                    signInWithEmailAndPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF426D53), // Set button color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded border
                    ),
                  ),
                  child: const Text(
                    'Login',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign up?",
                      style: TextStyle(
                        color: Colors.blue, // Set text color to black54
                        decoration: TextDecoration.underline, // Underline text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signInWithEmailAndPassword() async {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    // );
    // return;
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    print(email);
    print(password);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User sign in successful
      print('User signed in successfully: ${userCredential.user!.uid}');

      setState(() {
        print("Hi");
        _isLoggedIn = true;
        // Navigate to the homepage
        if (_isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    } catch (e) {
      // Handle errors during sign in
      print('Failed to sign in: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
