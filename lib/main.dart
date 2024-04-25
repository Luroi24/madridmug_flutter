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
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xffFBE287),
          onPrimary: Colors.yellow.shade200, 
          secondary: Colors.black,
          onSecondary: const Color.fromARGB(221, 69, 69, 69),
          error: Colors.red,
          onError: Colors.red.shade200,
          background: Colors.white,
          onBackground: Color.fromARGB(255, 130, 106, 35),
          surface: Colors.white,
          onSurface: Color.fromARGB(255, 130, 106, 35),
        ),
        primarySwatch: Colors.yellow,
        primaryColor: Colors.yellow,
      ),
      home: CounterPage(),
    );
  }
}