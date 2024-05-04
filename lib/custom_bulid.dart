import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "lib.dart";

Widget buildTextField({
  required IconData icon,
  required String hintText,
  required TextEditingController textFieldController,
  bool isPassword = false,
}) {
  return TextField(
    controller: textFieldController,
    obscureText: isPassword, // Determine if the text is for password
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Color(0xFF426D53)), // Set icon color
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey), // Set hint text color
      filled: true,

      fillColor: const Color(0xffebf2f0), // Set field background color
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0), // Rounded border
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 25), // Adjust padding
    ),
  );
}
