// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:madridmug_flutter/components.dart/popular_tile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String streetName;
  final double latitude;
  final double longitude;

  const HomePage({
    super.key,
    required this.streetName,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> weatherData = {};
  late String apiKey = '964c6239cde629e1100a493b2b9fb5d9';
  final double _overallPadding = 25;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      print(
          'Fetching weather data for coordinates: ${widget.latitude}, ${widget.longitude}');
      print(
          'Weather API URL: ${Uri.parse('https://api.openweathermap.org/data/2.5/find?lat=${widget.latitude}&lon=${widget.longitude}')}');

      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${widget.latitude}&lon=${widget.longitude}&appid=${apiKey}'));
      if (response.statusCode == 200) {
        print('Weather API response: ${response.body}');
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

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
                  padding: EdgeInsets.symmetric(horizontal: _overallPadding),
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
                                  child: Text(
                                    widget.streetName,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              children: [
                                Icon(Icons.location_on),
                                Text(
                                  widget.streetName,
                                  maxLines: 15,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )),

            // Cards - Popular places
            Expanded(
                flex: 4,
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: _overallPadding),
                    color: Colors.red,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            Text(
                              "See all",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return PopularTile();
                            },
                          ),
                        )
                      ],
                    ))),

            // Cards - Nearby places
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: Text("Nearby cards"),
                )),
            Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Image.asset("lib/images/etsisi.png",
                            color: Colors.grey[600], height: 105),
                      ),
                      Text("Developed by DarKbYte & Luroi"),
                    ],
                  ),
                ))
          ],
        ));
  }
}
