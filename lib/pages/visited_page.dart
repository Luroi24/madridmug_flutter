import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:madridmug_flutter/components.dart/reviewed_tile.dart';
import 'package:madridmug_flutter/components.dart/to_review_tile.dart';
import 'package:madridmug_flutter/controllers/place.dart';
import 'package:madridmug_flutter/pages/leave_review_page.dart';
import 'package:madridmug_flutter/pages/place_details.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/review.dart';
import '../db/database_helper.dart';

class VisitedPage extends StatefulWidget {
  final List<Place> places;
  final double latitude;
  final double longitude;
  final String userID;
  const VisitedPage({
    super.key,
    required this.places,
    required this.latitude,
    required this.longitude,
    required this.userID
  });

  @override
  State<VisitedPage> createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  List<List<String>> _coordinates = [];
  List<List<String>> _dbCoordinates = [];
  Set<Place> placesToRate = {};
  late List<Review> userReviews = [];
  late String userID = "";
  late Map<int,String> temp = {};
  @override
  void initState() {
    super.initState();
    fetchUserID();
    _loadCoordinates();
    _loadDbCoordinates();
  }

  Future<void> fetchUserID() async {
    try {
      userID = await widget.userID;
      setState(() { });
    } catch (e) {
      print('Error: $e');
    }
    fetchUserReviews();
    return;
  }

  Future<void> fetchUserReviews() async {
    try {
      print(userID);
      userReviews = await new Review.NoData().retrieveDataByUserId(widget.userID);
      for(var i=0;i<widget.places.length;i++){
        temp[widget.places[i].idPlace!] = widget.places[i].placeName.toString();
      }
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
    return;
  }


  Future<void> _loadCoordinates() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/gps_coordinates.csv');
    List<String> lines = await file.readAsLines();
    setState(() {
      _coordinates = lines.map((line) => line.split(';')).toList();
    });
  }

  Future<void> _loadDbCoordinates() async {
    List<Map<String, dynamic>> dbCoords = await DatabaseHelper.instance.getCoordinates(widget.userID); // Corrected
    setState(() {
      _dbCoordinates = dbCoords.map((c) => [
        c['timestamp'].toString(), // Corrected
        c['latitude'].toString(), // Corrected
        c['longitude'].toString(), // Corrected
      ]).toList();
    });
    availableToRate();
  }
  void availableToRate(){
    Set<Place> temp = {};
    print("Test: ${_dbCoordinates.length}");
    print("Test2: ${widget.places.length}");
    for(var coordinate in _dbCoordinates){
      for (var place in widget.places) {
        // TODO: Cambiar a valores más pequeños (las sumas que se hacen a las coordenadas de los lugares)
        if(double.parse(coordinate[1]) <= (place.coordinates[0]+1) && 
            double.parse(coordinate[1]) >= (place.coordinates[0]-1) &&
            double.parse(coordinate[2]) <= (place.coordinates[1]+1) &&
            double.parse(coordinate[2]) >= (place.coordinates[1]-1)){
          temp.add(place);
        }
      }
    }
    print("places: $temp");
    setState(() {
      placesToRate = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // To review title
          Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "About to brew up",
                  style: TextStyle(fontSize: 24),),
                // To review subtitle
                Text("You can leave a review here"),
              ],
            ),
          ),
          // Listview of places to review
          Container(
            height: 250,
            child: ListView.builder(
              itemCount: placesToRate.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaveReview(place: placesToRate.toList()[index], latitude: widget.latitude, longitude: widget.longitude),));
                  },
                  child: ToReviewTile(place: placesToRate.toList()[index],));
              },
            ),
          ),
          // Reviewed title
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Roasted coffee",
                  style: TextStyle(fontSize: 24),
                ),
                // To review subtitle
                Text("Someone cooked here..."),
              ],
            ),
          ),
          // Listview of places to review
          Container(
            height: 250,
            margin: const EdgeInsets.only(bottom: 50),
            child: ListView.builder(
              itemCount: userReviews.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ReviewdTile(review: userReviews[index], placesNames: temp);
              },
            ),
          ),
        ],
      ),
      /*body: ListView.builder(
        itemCount: _coordinates.length + _dbCoordinates.length,
        itemBuilder: (context, index){
          if (index < _coordinates.length){
            var coord = _coordinates[index];
            var formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(int.parse(coord[0])));
              return ListTile(
                title: Text('Timestamp: $formattedDate'),
                subtitle: Text(
                  '${coord[1]}\nLatitude: ${coord[2]}, Longitude: ${coord[3]}'),
                );
          }else{
            var dbIndex = index - _coordinates.length;
            var coord = _dbCoordinates[dbIndex];
            return ListTile(
              title: Text('DB Timestamp: ${coord[0]}', style: TextStyle(color: Colors.blue)),
              subtitle: Text('Latitude: ${coord[1]}, Longitude: ${coord[2]}', style: TextStyle(color: Colors.blue)),
              onTap: () => _showDeleteDialog(coord[0]),
              // Passing timestamp to the delete dialog
              onLongPress: () => _showUpdateDialog(coord[0], coord[1], coord[2]),
            );
          }
        },
      ),*/
    );
  }


  void _showDeleteDialog(String timestamp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm delete ${timestamp}"),
          content: Text("Do you want to delete this coordinate?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await DatabaseHelper.instance.deleteCoordinate(timestamp);
                Navigator.of(context).pop(); // Dismiss the dialog
                _loadDbCoordinatesAndUpdate(); // Reload data and update UI
              },
            ),
          ],
        );
      },
    );
  }


  void _loadDbCoordinatesAndUpdate() async {
    List<Map<String, dynamic>> dbCoords = await DatabaseHelper.instance.getCoordinates(widget.userID);
    setState(() {
      _dbCoordinates = dbCoords.map((c) => [
        c['timestamp'].toString(),
        c['latitude'].toString(),
        c['longitude'].toString()
      ]).toList();
    });
  }



  void _showUpdateDialog(String timestamp, String currentLat, String currentLong) {
    TextEditingController latController = TextEditingController(
        text: currentLat);
    TextEditingController longController = TextEditingController(
        text: currentLong);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update coordinates for ${timestamp}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: latController,
                decoration: InputDecoration(labelText: "Latitude"),
              ),
              TextField(
                controller: longController,
                decoration: InputDecoration(labelText: "Longitude"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update"),
              onPressed: () async {
                Navigator.of(context).pop();
                await DatabaseHelper.instance.updateCoordinate(
                    timestamp, latController.text, longController.text);
                _loadDbCoordinatesAndUpdate();
              },
            ),
          ],
        );
      },
    );
  }

}
