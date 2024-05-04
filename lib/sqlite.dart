import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

var DatabaseSql;
void databaseConnection(String nameDB) async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseSql = openDatabase(
    join(await getDatabasesPath(), nameDB),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE IF NOT EXISTS PLANT(id INTEGER PRIMARY KEY)',
      );
    },
    version: 1,
  );

  print("[Print] Connection Sqlite ${nameDB}");
}

// Define a function that inserts dogs into the database
Future<void> insertPlant(int id) async {
  // Get a reference to the database.
  final db = await DatabaseSql;
  await db.insert(
    'PLANT',
    {'id': id},
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
  print("[Print] insert ID:${id}");
}

Future<void> deletePlant(int id) async {
  // Get a reference to the database.
  final db = await DatabaseSql;

  // Remove the Dog from the database.
  await db.delete(
    'PLANT',
    where: 'id = ?',
    whereArgs: [id],
  );
}

// A method that retrieves all the dogs from the dogs table.
Future<List<int>> retrievePlant() async {
  // Get a reference to the database.
  final db = await DatabaseSql;
  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('PLANT');
  print("maps[0]['id']${maps[0]['id']}");
  // Convert the List<Map<String, dynamic> into a List<int>.
  return List.generate(maps.length, (i) {
    return maps[i]['id'] as int;
  });
}

void readData() {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child("Sensor_Data");

  databaseReference.onValue.listen((event) {
    DataSnapshot dataSnapshot = event.snapshot;
    dataSnapshot.value;
    print("[Print] ${dataSnapshot.value}");
  });
}
