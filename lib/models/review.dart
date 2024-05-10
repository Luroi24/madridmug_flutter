import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Review{
  String? description;
  int? idPlace;
  String? userName;
  String? userID;
  double? rating;

  FirebaseFirestore db = FirebaseFirestore.instance;

  Review.NoData(){}

  Review(   String this.description,
      int this.idPlace,
      String this.userName,
      String this.userID,
      double this.rating
      );

  Future<List<Review>> retrieveAllData() async {
   List<Review> data = [];
    final test1 = await db.collection("reviews").get().then((event){
      for (var doc in event.docs) {
            var test = doc.data();
           data.add(Review(test["description"],test["placeID"],test["userName"],test["userID"],test["rating"]));
            var w = test.containsKey("userName");
           //print(test["userName"]);
            test.forEach((key, value){
             // print(" $key -> $value");
            });
            //print("-----------------------------");
      }
    });
    //print(data.length);
    return data;
  }

  void addReview(){

  }

  void updateReview(){

  }

  void deleteReview(){

  }

}

