import 'package:cloud_firestore/cloud_firestore.dart';

class User{
    String? userID;
    String? location;
    String? profileURL;


    User.NoData(){}

    User(
        String? this.userID,
        String? this.location,
        String? this.profileURL,
        );

    FirebaseFirestore db = FirebaseFirestore.instance;


    Future<User> retrieveUserData(String userID) async {
        User userData = new User.NoData();
        final retrievedData = await db.collection("users").where("id", isEqualTo: userID).get().then((event){
            for (var doc in event.docs) {
                var queryElement = doc.data();
                userData = new User(queryElement["id"],queryElement["location"],queryElement["profileURL"]);
            }
        });
        return userData;
    }

    Future<void> addUser(String userID) async{
        final retrievedData = await db.collection("users").where("id", isEqualTo: userID).get().then((event){
            if(event.docs.length == 0){

                db.collection("users").add({
                        "id": userID,
                        "location": "Spain",
                        "profileURL": "https://steamuserimages-a.akamaihd.net/ugc/885384897182110030/F095539864AC9E94AE5236E04C8CA7C2725BCEFF/"
                });
            }
        });
    }


}