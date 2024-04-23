// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, TextEditingController> controllers = {};

  Future<Map<String, dynamic>> _fetchAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<String, dynamic> prefsMap = {};
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
      controllers[key] = TextEditingController(text: prefs.get(key).toString());
    }
    return prefsMap;
  }

  Future<void> _updatePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchAllPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              return ListView(
                children: snapshot.data!.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: TextField(
                      controller: controllers[entry.key],
                      decoration:
                          InputDecoration(hintText: "Enter ${entry.key}"),
                      onSubmitted: (value) {
                        _updatePreference(entry.key, value);
                      },
                    ),
                  );
                }).toList(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      );
  }
}
