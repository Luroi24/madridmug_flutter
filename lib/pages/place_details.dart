// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:madridmug_flutter/models/place_test.dart';

class PlaceDetails extends StatelessWidget {
  PlaceTest place;
  PlaceDetails({super.key, required this.place});

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
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: place.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 350,
                    width: 335,
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(place.images[index])),
                    ),
                  );
                },
              ),
            ),
          ),

          // Title and rating
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    place.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("${place.rating} ⭐"),
                ],
              )),

          // Description
          Expanded(flex: 2, child: Container(
            alignment: Alignment.topLeft,
            child: Text("Test"))),
          // View on map button
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(Icons.map, color: Colors.black,),
                onPressed: () => print("jiji")
                ),
            ),),
          // Reviews title
          Expanded(
            flex: 1, 
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
                ),
            )
            ),
          // Reviews
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topLeft,
              child: Text("ReviewsList"))),
        ],
      ),
    ));
  }
}
