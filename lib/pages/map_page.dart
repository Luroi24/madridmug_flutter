// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: Container(
          child: Text("Map page"),
      ),),
    );
  }
}