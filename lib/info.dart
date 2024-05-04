import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "lib.dart";

class Info {
  final String name;
  final String description;
  final String imagePath;
  final String article;

  Info({
    required this.article,
    required this.name,
    required this.description,
    required this.imagePath,
  });
}

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late Future<void> _loadingData;
  List<Info> _database = [];
  List<Info> _filteredDatabase = [];

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
    print("HelloWorld");
    var flowers = data["flowers"];
    for (var i = 0; i < flowers.length; i++) {
      _database.add(Info(
          name: flowers[i]['name'],
          description: flowers[i]['description'],
          imagePath: "./assets/images/flower/${flowers[i]['file']}",
          article: flowers[i]['article']));
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
                return InfoPageList(
                  plants: _filteredDatabase,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class InfoPageList extends StatelessWidget {
  final List<Info> plants;

  InfoPageList({required this.plants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plants.length,
      itemBuilder: (context, index) {
        return InfoPageCard(
          plant: plants[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoPageDetailsPage(plant: plants[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class InfoPageCard extends StatelessWidget {
  final Info plant;
  final VoidCallback onTap;

  InfoPageCard({required this.plant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xffebf2f0),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundImage: AssetImage(plant.imagePath),
                  radius: 30,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      plant.description,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoPageDetailsPage extends StatelessWidget {
  final Info plant;

  InfoPageDetailsPage({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  plant.imagePath,
                  width: 600.0,
                  height: 240.0,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                plant.name,
                style: TextStyle(
                  color: Color(0xFF426D53),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                plant.article,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
