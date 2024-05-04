import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:plant_z/sqlite.dart';

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

class _PlantListState extends State<PlantList> {
  late Future<void> _loadingData;
  List<Plant> _database = [];
  List<Plant> _filteredDatabase = [];

  double light = 0.0;
  double moisture = 0.0;
  double temp = 0.0;

  @override
  void initState() {
    super.initState();
    _loadingData = loadJsonData();

    DatabaseReference _plantRef =
        FirebaseDatabase.instance.ref().child("Sensor_Data");
    _plantRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        light = double.tryParse(data['LDR_sensor'].toString()) ?? 0.0;
        moisture =
            double.tryParse(data['Soil_Moisture_sensor'].toString()) ?? 0.0;
        temp = double.tryParse(data['TMP35_sensor'].toString()) ?? 0.0;
      });
    });

    _filteredDatabase.clear();
    _filteredDatabase.addAll(_database);
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant and Sensor Data'),
      ),
      body: Column(
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
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: _filteredDatabase.length,
                    itemBuilder: (context, index) {
                      return PlantCard(
                        plant: _filteredDatabase[index],
                        onDelete: deletePlant,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text('Sensor Data'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Light: \$light'),
                    Text('Moisture: \$moisture'),
                    Text('Temp: \$temp'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;
  final Function(Plant) onDelete;

  PlantCard({
    required this.plant,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Card(
              // Your card design and UI elements
              ),
        ],
      ),
    );
  }
}
