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

  Review(
      String this.description,
      int this.idPlace,
      String this.userName,
      String this.userID,
      double this.rating
      );

  Future<List<Review>> retrieveAllData() async {
   List<Review> data = [];
    final retrievedData = await db.collection("reviews").get().then((event){
      for (var doc in event.docs) {
            var queryElement = doc.data();
           data.add(Review(queryElement["description"],queryElement["placeID"],queryElement["userName"],queryElement["userID"],queryElement["rating"]));
            var w = queryElement.containsKey("userName");
           //print(test["userName"]);
            queryElement.forEach((key, value){
             // print(" $key -> $value");
            });
            //print("-----------------------------");
      }
    });
    //print(data.length);
    return data;
  }


  Future<List<Review>> retrieveDataById(int idPlace) async {
    List<Review> data = [];
    final retrievedData = await db.collection("reviews").where("placeID", isEqualTo: idPlace).get().then((event){
      for (var doc in event.docs) {
        var queryElement = doc.data();
        data.add(Review(queryElement["description"],queryElement["placeID"],queryElement["userName"],queryElement["userID"],queryElement["rating"]));
        var w = queryElement.containsKey("userName");
        //print(test["userName"]);
        queryElement.forEach((key, value){
          // print(" $key -> $value");
        });
        //print("-----------------------------");
      }

    });
    //print(data.length);
    return data;
  }

  Future<List<Review>> retrieveDataByUserId(String userID) async {
    List<Review> data = [];
    final retrievedData = await db.collection("reviews").where("userID", isEqualTo: userID).get().then((event){
      for (var doc in event.docs) {
        var queryElement = doc.data();
        data.add(Review(queryElement["description"],queryElement["placeID"],queryElement["userName"],queryElement["userID"],queryElement["rating"]));
        var w = queryElement.containsKey("userName");
        //print(test["userName"]);
        queryElement.forEach((key, value){
          // print(" $key -> $value");
        });
        //print("-----------------------------");
      }

    });
    //print(data.length);
    return data;
  }

  Future<void> addReview(Review rev) async{
      await db.collection("reviews").add({
        "description": rev.description,
        "placeID": rev.idPlace,
        "rating": rev.rating,
        "userID": rev.userID,
        "userName": rev.userName
      });
  }

  void updateReview(){

  }

  void deleteReview(){

  }

}

