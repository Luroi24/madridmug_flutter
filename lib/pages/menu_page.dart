// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:madridmug_flutter/controllers/place.dart';
import 'package:madridmug_flutter/pages/home_page.dart';
import 'package:madridmug_flutter/pages/map_screen.dart';
import 'package:madridmug_flutter/pages/profile.dart';
import 'package:madridmug_flutter/pages/visited_page.dart';
import 'dart:io';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

import '../db/database_helper.dart';

class MenuPage extends StatefulWidget {
  MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  StreamSubscription<Position>? _positionStreamSubscription;
  DatabaseHelper db = DatabaseHelper.instance;
  final _uidController = TextEditingController();
  final _ageController = TextEditingController();
  final logger = Logger();
  late List<Place> _places = [];

  double _newLatitude = 40.407447684737356;
  double _newLongitude = -3.6152570335947654;
  String _streetName = "Not set yet";

  Future<void> fetchPlaces() async {
    try {
      _places = await new Place.NoData().retrieveAllPlaces();
      _places.sort((a, b) => a.rating!.compareTo(b.rating!));
      _places = _places.reversed.toList();
      print("Places: $_places");
    } catch (e) {
      print('Error: $e');
    }
    return;
  }

  void changeStreet(String? newStreet) {
    if (newStreet != null) {
      setState(() {
        _streetName = newStreet;
      });
    }
  }

  void changeCoordinates(double latitude, double longitude) {
    setState(() {
      _newLatitude = latitude;
      _newLongitude = longitude;
    });
  }

  // Keep track of index
  int _selectedIndex = 0;

  // Change selected index
  void _bottomNavSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('username');
    String? age = prefs.getString('age');

    if (uid == null || age == null) {
      _showInputDialog();
    } else {}
  }

  Future<void> _showInputDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter username and age'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _uidController,
                  decoration: InputDecoration(hintText: "Username"),
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(hintText: "Age"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('username', _uidController.text);
                await prefs.setString('age', _ageController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    startTracking();
    stopTracking();
    _loadPrefs();

    double _borderSize = 12;

    final List pages = [
      HomePage(
        streetName: _streetName,
        latitude: _newLatitude,
        longitude: _newLongitude,
      ),
      MapScreen(
        latitude: _newLatitude,
        longitude: _newLongitude,
        places: _places,
      ),
      VisitedPage(
        places: _places,
        latitude: _newLatitude,
        longitude: _newLongitude,
      ),
      ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(_borderSize),
              topLeft: Radius.circular(_borderSize)),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.shade50, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_borderSize),
            topRight: Radius.circular(_borderSize),
          ),
          child: BottomNavigationBar(
            unselectedItemColor: Theme.of(context).primaryColor,
            unselectedLabelStyle: TextStyle(color: Color(0xff806917)),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _bottomNavSelected,
            backgroundColor: Colors.white,
            /* decoration: BoxDecoration( 
          color: Theme.of(context).primaryColor, 
          borderRadius: const BorderRadius.only( 
            topLeft: Radius.circular(20), 
            topRight: Radius.circular(20), 
          ), 
        ),  */
            items: [
              // Home button
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home_filled),
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: "Home",
              ),

              // Map button
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.map),
                  icon: Icon(Icons.map_outlined),
                  label: "Map"),

              // Visited button
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.favorite),
                  icon: Icon(Icons.favorite_border),
                  label: "Visited"),

              // Profile button
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outline),
                  label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  void startTracking() async {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // Adjust the accuracy as needed
      distanceFilter: 5, // Distance in meters before an update is triggered
    );
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        changeCoordinates(position.latitude, position.longitude);
        writePositionToFile(position);
      },
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        db.insertCoordinate(position);
      },
    );
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  Future<void> writePositionToFile(Position position) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/gps_coordinates.csv');
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      logger.d("Lugares encontrados: ${placemarks[0].street}");
      changeStreet(placemarks[0].street);
      await file.writeAsString(
          '$timestamp;${placemarks[0].street};${position.latitude};${position.longitude}\n',
          mode: FileMode.append);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _uidController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
