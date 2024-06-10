import 'package:cloud_firestore/cloud_firestore.dart';

class User{
    String? userID;
    String? location;
    String? profileURL;


    User.NoData(){}

    User(
        String? this.userID,
        String? this.location,
        String? this.profileURL
        );

    FirebaseFirestore db = FirebaseFirestore.instance;





}