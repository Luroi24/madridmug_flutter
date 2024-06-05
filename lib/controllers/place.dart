


import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Place{
  String? description;
  String? category;
  int? idPlace;
  List <dynamic?> imgURLs= [];
  List<dynamic?> coordinates=[];
  String? placeName;
  double? rating;

  FirebaseFirestore db = FirebaseFirestore.instance;

  Place.NoData(){}

  Place(
      String this.description,
      String this.category,
      int this.idPlace,
      List<dynamic> this.imgURLs,
      List<dynamic> this.coordinates,
      String this.placeName,
      double this.rating
      );


  Future<List<Place>> retrieveAllPlaces() async{
    List<Place> places = [];
    final retrievedData = await db.collection("places").get().then((event){
      for (var doc in event.docs) {
        var queryElement = doc.data();
        places.add(Place(queryElement["description"],queryElement["category"],queryElement["id"],queryElement["imgURLs"],queryElement["location"],queryElement["name"],queryElement["rating"]));
        //var w = queryElement.containsKey("userName");
        //print(test["userName"]);
        queryElement.forEach((key, value){
          //print(" $key -> $value");
        });
        //print("-----------------------------");
      }
    });
    return places;
  }

}