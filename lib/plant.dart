import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import "lib.dart";

class Plant {
  final int ID;
  final String name;
  final String datePlanted;
  final String temperatureStatus;
  final String wetStatus;
  final String lightStatus;
  final String imagePath;

  Plant({
    required this.ID,
    required this.name,
    required this.datePlanted,
    required this.temperatureStatus,
    required this.wetStatus,
    required this.lightStatus,
    required this.imagePath,
  });
}

class PlantList extends StatefulWidget {
  @override
  _PlantListState createState() => _PlantListState();
}

// List<Plant> DatabasedVII = [];

class _PlantListState extends State<PlantList> {
  late Future<void> _loadingData;

  List<Plant> _database = [];
  List<Plant> _filteredDatabase = [];

  Future<void> loadJsonData() async {
    Map<String, dynamic> data;
    final String jsonString =
        await rootBundle.loadString('./assets/data/flower.json');
    data = jsonDecode(jsonString) as Map<String, dynamic>;
    List<int> cacheData = [];

    Future<List<int>> futureList = retrievePlant();
    List<int> isReady = await futureList;
    for (var element in isReady) {
      cacheData.add(element);
    }

    var plant = data["flowers"];
    print("Plant ${plant.length}");
    for (var i = 0; i < plant.length; i++) {
      print(plant[i]["available"].runtimeType);
      if (plant[i]["available"]) {
        print("cacheData $cacheData");
        for (var cache in cacheData) {
          if (cache == plant[i]["id"]) {
            _database.add(Plant(
              ID: plant[i]["id"],
              imagePath: "./assets/images/flower/${plant[i]['file']}",
              name: plant[i]["name"],
              datePlanted: "",
              temperatureStatus: "",
              wetStatus: "",
              lightStatus: "",
            ));
          }
        }
      }
    }

    // Initialize filtered database with all data
    _filteredDatabase.addAll(_database);
  }

  @override
  void initState() {
    super.initState();
    _loadingData = loadJsonData();

    _filteredDatabase.clear();
    _filteredDatabase.addAll(_database);
  }

  void filterDatabase(String query) {
    _filteredDatabase.clear();
    _database.forEach((element) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        _filteredDatabase.add(element);
      }
    });
    setState(() {});
  }

  void deletePlant(Plant plant) {
    setState(() {
      _database.remove(plant);
      _filteredDatabase.remove(plant);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Plants...',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Color(0xFF426D53)),
              filled: true,
              fillColor: const Color(0xffebf2f0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            ),
            onChanged: (value) {
              filterDatabase(value);
            },
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: Future.wait([_loadingData]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: _filteredDatabase.length,
                    itemBuilder: (context, index) {
                      return PlantCard(
                        plant: _filteredDatabase[index],
                        onDelete: deletePlant,
                      );
                    });
              }
            },
          ),
        ),
      ],
    );
  }
}

class PlantCard extends StatefulWidget {
  final Plant plant;
  final Function(Plant) onDelete;

  PlantCard({
    required this.plant,
    required this.onDelete,
  });

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  String Light_value = "Na/N";
  String Moisture_value = "Na/N";
  String Temperature_value = "Na/N";
  MaterialColor Light_Color = Colors.green;
  MaterialColor Wet_Color = Colors.green;
  MaterialColor Tem_Color = Colors.green;

  @override
  late Timer _timer;
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => update());
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void update() {
    setState(() {
      print("[PRINT] UPDATED");

      if (Light <= 800) {
        Light_value = "OFF";
        Light_Color = Colors.red;
      } else {
        Light_value = "ON";
        Light_Color = Colors.green;
      }
      if (Moisture > 50) {
        Wet_Color = Colors.orange;

        Moisture_value = "Dry[Pump On]";
      } else if (Moisture < 41) {
        Moisture_value = "Wet";
        Wet_Color = Colors.red;
      } else {
        Wet_Color = Colors.green;

        Moisture_value = "Normal";
      }

      if (Temperature > 40) {
        Temperature_value = "Hot[Fan On]";
        Tem_Color = Colors.orange;
      } else if (Temperature < 5) {
        Temperature_value = "Freeze";
        Tem_Color = Colors.red;
      } else {
        Temperature_value = "Normal";
        Tem_Color = Colors.green;
      }
    });
  }

  // }
  // void sens() {
  //   List ifuxzyoud = ["", "", ""];
  //   DatabaseReference _plantRef =
  //       FirebaseDatabase.instance.ref().child("Sensor_Data");

  //   print("[print] HELLO");
  //   print("[print] SS ${_plantRef.key}");
  //   _plantRef.onValue.listen((event) {
  //     String realTimeSensor = event.snapshot.value.toString();
  //     print("[printss] ${realTimeSensor}");
  //     // Map valueMap = json.decode(realTimeSensor);
  //     realTimeSensor = realTimeSensor.replaceAll("{", "");
  //     realTimeSensor = realTimeSensor.replaceAll("}", "");
  //     List parts = realTimeSensor.split(",");
  //     int index = 0;
  //     for (var element in parts) {
  //       List jo = element.split(":");
  //       ilovezyoud[index % 3] = jo[1];
  //       index = index + 1;
  //     }
  //     setState(() {
  //       print("[print] ${ilovezyoud[0]}");
  //       print("[print] ${ilovezyoud[1]}");
  //       print("[print] ${ilovezyoud[2]}");
  //       // Temperature = "SS";
  //       // Moisture = "SS";
  //       // light = "SS";
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   DatabaseReference _plantRef =
  //       FirebaseDatabase.instance.ref().child("Sensor_Data");

  //   _plantRef.onValue.listen((event) {
  //     var data = Map<String, dynamic>.from(event.snapshot.value as Map);
  //     setState(() {
  //       // Assuming the data is already a float, otherwise you might need to parse it
  //       var light = data['LDR_sensor'].toString();
  //       var Moisture = data['Soil_Moisture_sensor'].toString();
  //       var Temperature = data['TMP35_sensor'].toString();

  //       // Print the values to the console
  //       print("[print] Light: $light");
  //       print("[print] Moisture: $Moisture");
  //       print("[print] Temp: $Temperature");
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   DatabaseReference _plantRef =
  //       FirebaseDatabase.instance.ref().child("Sensor_Data");
  //   print("[print] SS ${_plantRef.key}");

  // _plantRef.onValue.listen((event) {
  //   setState(() {
  //     realTimeLDR_sensor = event.snapshot.value.toString();
  //     print("[print] ${realTimeLDR_sensor}");
  //   });
  // });
  // }

  @override
  Widget build(BuildContext context) {
    // @override
    // void initState() {
    //   super.initState();
    //   print("[print] HELLO");
    //   DatabaseReference _plantRef =
    //       FirebaseDatabase.instance.ref().child("Sensor_Data");
    //   var realTimeSensor;
    //   // print("[print] ${_plantRef.key}");
    //   // _plantRef.key
    //   setState(() {
    //     Map valueMap = jsonDecode(_plantRef.key.toString());
    //     Temperature = valueMap["TMP35_sensor"];
    //     Moisture = valueMap["Soil_Moisture_sensor"];
    //     light = valueMap["LDR_sensor"];
    //     print("[print] $Temperature");
    //     print("[print] $Moisture");
    //     print("[print] $light");
    //   });

    //   // _plantRef.onValue.listen((event) {
    //   //     realTimeSensor = event.snapshot.value;
    //   //     print("[print] Temperature ${Temperature}");
    //   //   });
    //   // });
    // }

    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Card(
            color: Color(0xffebf2f0),
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.plant.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (true) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Temperature:',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${Temperature_value} ($Temperature)',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Tem_Color,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Moisture:',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${Moisture_value} ($Moisture)',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Wet_Color,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Light:',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${Light_value} ($Light)',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Light_Color,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                        Container(),
                        CircleAvatar(
                          backgroundImage: AssetImage(widget.plant.imagePath),
                          radius: 40,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(top: 10.0),
                                title: Text(
                                  "Are you sure you want to remove this plant ?",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.black,
                                  ),
                                ),
                                content: Container(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.green,
                                          ),
                                          onPressed: () {
                                            deletePlant(widget.plant.ID);
                                            widget.onDelete(widget.plant);
                                            Navigator.pop(context);
                                            print("[print] Delete Card");
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Color(0xFF426D53),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Color(0xFF426D53),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
