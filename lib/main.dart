// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:madridmug_flutter/pages/counter_page.dart';
import 'package:madridmug_flutter/pages/menu_page.dart';
import 'package:madridmug_flutter/pages/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        primaryColor: Colors.yellow,
      ),
      home: MenuPage(),
    );
  }
}