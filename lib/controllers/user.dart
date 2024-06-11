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


}