import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import "lib.dart";

class addList extends StatefulWidget {
  @override
  _addListState createState() => _addListState();
}

class _addListState extends State<addList> {
  late Future<void> _loadingData;
  List<Plant> _database = [];
  List<Plant> _filteredDatabase = [];

  @override
  void initState() {
    super.initState();
    _loadingData = loadJsonData();
  }

  Future<void> loadJsonData() async {
    Map<String, dynamic> data;
    final String jsonString =
        await rootBundle.loadString('./assets/data/flower.json');
    data = jsonDecode(jsonString) as Map<String, dynamic>;

    var plant = data["flowers"];
    print("Plant ${plant.length}");
    for (var i = 0; i < plant.length; i++) {
      print(plant[i]["available"].runtimeType);
      if (plant[i]["available"]) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
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
            future: _loadingData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemCount: _filteredDatabase.length,
                  itemBuilder: (context, index) {
                    return addCard(
                      plant: _filteredDatabase[index],
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class addCard extends StatefulWidget {
  final Plant plant;

  addCard({
    required this.plant,
  });

  @override
  State<addCard> createState() => _addCardState();
}

class _addCardState extends State<addCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to plant details page
      },
      child: Card(
        color: Color(0xffebf2f0),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Button with symbol addition on the most left
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // insertPlant(widget.plant.ID);

                      // DateTime now = DateTime.now();
                      // String formattedDate =
                      //     DateFormat('yyyy-MM-dd').format(now);

                      // Plant newPlant = Plant(
                      //     ID: widget.plant.ID,
                      //     name: widget.plant.name,
                      //     datePlanted: formattedDate,
                      //     temperatureStatus: "",
                      //     wetStatus: "",
                      //     lightStatus: "",
                      //     imagePath: widget.plant.imagePath);
                      // print("Added Plants ${widget.plant.name}");

                      insertPlant(widget.plant.ID);
                      // DatabasedVII.add(newPlant);
                      // Add action for the button here
                    },
                    icon: Icon(Icons.add),
                  ),

                  // Vertical separating line
                  VerticalDivider(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(widget.plant.imagePath),
                      radius: 30,
                    ),
                  ),
                ],
              ),

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
    );
  }
}
