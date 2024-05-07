// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  final String streetName;
  const HomePage({super.key, required this.streetName});

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
              padding: EdgeInsets.only(left: 30),
              color: Colors.yellow,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Explore"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(streetName, style: TextStyle(fontSize: 24),),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("You're currently at ... $streetName")),
                ],
              ),
            )
          ),

          // Cards - Popular places
          Expanded(
            flex: 4,
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
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(bottom: 80),
              alignment: Alignment.bottomCenter,
              color: Colors.green,
              child: Text("Developed by DarKbYte & Luroi"),
            )
          )
        ],
      )
    );
  }
}