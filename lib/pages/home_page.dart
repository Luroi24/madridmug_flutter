// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          // Top title. Shows current localization in the form of string (reverse use of the Geopoint)
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              color: Colors.yellow,
              child: Text("Test"),
            )
          ),

          // Cards - Popular places
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: Text("Popular cards"),
            )
          ),
          
          // Cards - Nearby places
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              child: Text("Nearby cards"),
            )
          )
        ],
      )
    );
  }
}