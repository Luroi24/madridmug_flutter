// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  String greetingMessage = "";

  // Text editing controller.
  TextEditingController myController = TextEditingController();
  
  // Greeting method
  void greetUser(){
    setState(() {
      String username = myController.text;
      greetingMessage = "Hello, " + username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Greeting message
              Text(greetingMessage),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: "Type your name here!",
                  border: OutlineInputBorder(),
                ),
              ),
          
              // Button
              ElevatedButton(
                onPressed: greetUser,
                child: Text("Tap"),
              )
            ],
          ),
        ),
      ),
    );
  }
}