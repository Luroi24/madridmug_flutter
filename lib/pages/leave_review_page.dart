// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart' as User1;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:madridmug_flutter/controllers/place.dart';
import 'package:madridmug_flutter/controllers/place_test.dart';
import 'package:madridmug_flutter/pages/visited_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart/review_tile.dart';
import '../controllers/review.dart';
import '../controllers/user.dart';
import 'package:madridmug_flutter/pages/map_screen.dart';

import 'menu_page.dart';

class LeaveReview extends StatefulWidget {
  Place place;
  final double latitude;
  final double longitude;
  Review? review;

  LeaveReview({
    super.key,
    required this.place,
    required this.latitude,
    required this.longitude});

  @override
  State<LeaveReview> createState() => _LeaveReviewState();
}

class _LeaveReviewState extends State<LeaveReview> {
  late List<Review> reviews = [];
  User userData = new User.NoData();
  final Map<Review,User> data = {};
  late User currentUser;
  final myController = TextEditingController();
  late String userName = "";
  late double placeRat = 0.0;
  late List<Place> _places = [];
  @override
  void initState() {
    fetchReviews(widget.place.idPlace!);
    fetchPlaces();
    //print(widget.place.idPlace!);
    super.initState();

  }

  Future<void> fetchPlaces() async {
    try {
      _places = await new Place.NoData().retrieveAllPlaces();
      _places.sort((a, b) => a.rating!.compareTo(b.rating!));
      _places = _places.reversed.toList();
      print("Places: $_places");
    } catch (e) {
      print('Error: $e');
    }
    return;
  }

  Future<void> fetchReviews(int idPlace) async {
    try {
      reviews = await new Review.NoData().retrieveDataById(idPlace);
      for(var i=0;i<reviews.length;i++){
        data[reviews[i]] = await fetchUserData(reviews[i].userID.toString());
      }
      currentUser = await fetchUserData(User1.FirebaseAuth.instance.currentUser!.uid);

      //print(reviews.length);
    } catch (e) {
      print('Error: $e');
    }
    setState(() {});
    return;
  }

  Future<dynamic> getSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<User> fetchUserData(String userID) async {
    try {
      userData = await new User.NoData().retrieveUserData(userID);
      userName = await getSharedPreferences("username");
      print("Username $userName");
    } catch (e) {
      print('Error: $e');
    }
    setState(() {});
    return userData;
  }

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
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.place.description!,
                      textAlign: TextAlign.justify,
                    ),
                  ))),
          // Reviews title & View on map button
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Leave your review here!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          // Reviews
          Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 20),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(4, 8), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(vertical:5),
                                child: RatingBar(
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 36,
                                  glowColor: Color(0x99F8D675),
                                  ratingWidget: RatingWidget(
                                      full: const Icon(
                                        Icons.star_rounded,
                                        color: Color(0xFFF8D675),
                                      ),
                                      half: const Icon(Icons.star_half_rounded,
                                          color: Color(0xFFF8D675)),
                                      empty: const Icon(Icons.star_border_rounded,
                                          color: Color(0xFFD9D9D9))),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    placeRat = rating;
                                  }),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Make sure you roast this coffee!',
                                  ),
                                  controller: myController,
                                ),
                              ),),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        child: FloatingActionButton(
                          onPressed: () {
                            print("a");
                            var x = new Review(myController.text, widget.place.idPlace!, userName, userData.userID!,placeRat);
                            x.addReview(x);
                            fetchReviews(widget.place.idPlace!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuPage(),
                              ),
                            );
                          },
                          child: Icon(Icons.send_rounded, color: Colors.amber.shade700,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    ));
  }
}
