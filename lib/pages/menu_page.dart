// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:madridmug_flutter/pages/home_page.dart';
import 'package:madridmug_flutter/pages/map_page.dart';
import 'package:madridmug_flutter/pages/profile.dart';
import 'package:madridmug_flutter/pages/visited_page.dart';

class MenuPage extends StatefulWidget {
  MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List _pages = [
    HomePage(),
    MapPage(),
    VisitedPage(),
    ProfilePage(),
  ];

  // Keep track of index
  int _selectedIndex = 0;

  // Change selected index
  void _bottomNavSelected(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _bottomNavSelected,
        items: [
          // Home button
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
            ),
            label: "Home",
          ),

          // Map button
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map"
          ),

          // Visited button
          BottomNavigationBarItem(
            icon: Icon(Icons.heart_broken_rounded),
            label: "Visited"
          ),

          // Profile button
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"
          ),
        ],
      ),
    );
  }
}