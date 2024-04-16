import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class VisitedPage extends StatefulWidget {
  const VisitedPage({super.key});

  @override
  State<VisitedPage> createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  List<List<String>> _coordinates = [];
  @override
  void initState() {
    super.initState();
    _loadCoordinates();
  }

  Future<void> _loadCoordinates() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/gps_coordinates.csv');
    List<String> lines = await file.readAsLines();
    setState(() {
      _coordinates = lines.map((line) => line.split(';')).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      body: ListView.builder(
        itemCount: _coordinates.length,
        itemBuilder: (context, index) {
          var coord = _coordinates[index];
          var formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(coord[0])));
          return ListTile(
            title: Text('Timestamp: $formattedDate'),
            subtitle: Text('Latitude: ${coord[1]}, Longitude: ${coord[2]}'),
          );
        },
      ),
    );
  }
}
