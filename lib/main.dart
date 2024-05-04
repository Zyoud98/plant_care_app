import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import "lib.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'mupl-2b96b',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  databaseConnection("database.db");
  // readData();
  alpha();
  runApp(MyApp());
}

DatabaseReference _plantRef =
    FirebaseDatabase.instance.ref().child("Sensor_Data");
double Light = 0;
double Moisture = 0;
double Temperature = 0;
void alpha() {
  _plantRef.onValue.listen((event) {
    final data = Map<String, dynamic>.from(event.snapshot.value as Map);
    Light = double.tryParse(data['LDR_sensor'].toString()) ?? 0.0;
    Moisture = double.tryParse(data['Soil_Moisture_sensor'].toString()) ?? 0.0;
    Temperature = double.tryParse(data['TMP35_sensor'].toString()) ?? 0.0;
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to HomePage after 2.5 seconds
    Timer(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginApp(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              './assets/images/image3.jpg'), // Replace 'assets/background_image.jpg' with your image path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
