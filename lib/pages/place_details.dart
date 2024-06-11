// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:madridmug_flutter/controllers/place.dart';
import 'package:madridmug_flutter/controllers/place_test.dart';
import 'package:madridmug_flutter/pages/map_screen.dart';

class PlaceDetails extends StatefulWidget {
  Place place;
  final double latitude;
  final double longitude;

  /* 
    places[index].description.toString(),
    places[index].category.toString(),
    places[index].idPlace!.toInt(),
    places[index].imgURLs,
    places[index].coordinates,
    places[index].placeName.toString(),
    places[index].rating!.toDouble());
  */
  PlaceDetails({
    super.key,
    required this.place,
    required this.latitude,
    required this.longitude});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(top: 45, left: 25, right: 25),
      child: Column(
        children: [
          // Images of the place
          Expanded(
            flex: 6,
            child: CarouselSlider(
              options: CarouselOptions(height: 350, enableInfiniteScroll: false, ),
              items: widget.place.imgURLs.map((image){
                return Builder(builder: (BuildContext context){
                  return Container(
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(image)),
                    ),
                  );
                });
              }).toList(),
            ),
          ),

          // Title and rating
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.place.placeName!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("${widget.place.rating} ⭐"),
                ],
              )),

          // Description
          Expanded(
              flex: 2,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    widget.place.description!,
                    textAlign: TextAlign.justify,
                  ))),
          // Reviews title & View on map button
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Stack(
                children: [
                  // Reviews title
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reviews",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // Floating button
                  Container(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.map,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return MapScreen(latitude: widget.latitude, longitude: widget.longitude, places: [widget.place]);
                        },));
                      }
                    ),
                  ),
              ]),
            ),
          ),
          // Reviews
          Expanded(
              flex: 4,
              child: Container(
                  alignment: Alignment.topLeft, child: Text("ReviewsList"))),
        ],
      ),
    ));
  }
}
