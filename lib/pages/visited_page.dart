import 'package:flutter/material.dart';

class VisitedPage extends StatelessWidget {
  const VisitedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      body: Center(
        child: Container(
          child: Text("Visited page"),
      ),),
    );
  }
}