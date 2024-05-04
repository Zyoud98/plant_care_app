import "lib.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ReportProblemWidget extends StatefulWidget {
  @override
  _ReportProblemWidgetState createState() => _ReportProblemWidgetState();
}

class _ReportProblemWidgetState extends State<ReportProblemWidget> {
  String _selectedOption = 'Report Bug';
  String _problemDescription = '';

  List<String> _options = ['Report Bug', 'Problem in Plant'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF426D53),
        title: Text(
          'Report a Problem',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Describe the problem:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              onChanged: (text) {
                setState(() {
                  _problemDescription = text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter problem description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF426D53),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    print('Selected option: $_selectedOption');
                    print('Description: $_problemDescription');
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
