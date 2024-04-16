// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:madridmug_flutter/pages/home_page.dart';
import 'package:madridmug_flutter/pages/map_page.dart';
import 'package:madridmug_flutter/pages/profile.dart';
import 'package:madridmug_flutter/pages/visited_page.dart';
import 'dart:io';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  StreamSubscription<Position>? _positionStreamSubscription;
  final List _pages = [
    HomePage(),
    MapPage(),
    VisitedPage(),
    ProfilePage(),
  ];

  // Keep track of index
  int _selectedIndex = 0;

  // Change selected index
  void _bottomNavSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    startTracking();

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _bottomNavSelected,
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
            icon: Icon(
              Icons.home_filled,
            ),
            label: "Home",
          ),

          // Map button
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),

          // Visited button
          BottomNavigationBarItem(
              icon: Icon(Icons.heart_broken_rounded), label: "Visited"),

          // Profile button
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
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
        writePositionToFile(position);
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
    await file.writeAsString(
        '${timestamp};${position.latitude};${position.longitude}\n',
        mode: FileMode.append);
  }
}
