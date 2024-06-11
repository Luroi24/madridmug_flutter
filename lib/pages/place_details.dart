// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:madridmug_flutter/controllers/place.dart';
import 'package:madridmug_flutter/controllers/place_test.dart';

import '../components.dart/review_tile.dart';
import '../controllers/review.dart';
import '../controllers/user.dart';

class PlaceDetails extends StatefulWidget {
  Place place;
  Review? review;
  PlaceDetails({super.key, required this.place});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  late List<Review> reviews = [];
  User userData = new User.NoData();
  final Map<Review,User> data = {};
  @override
  void initState() {
    fetchReviews(widget.place.idPlace!);
    //print(widget.place.idPlace!);
    super.initState();

  }

  Future<void> fetchReviews(int idPlace) async {
    try {
      reviews = await new Review.NoData().retrieveDataById(idPlace);
      for(var i=0;i<reviews.length;i++){
        data[reviews[i]] = await fetchUserData(reviews[i].userID.toString());
      }
      //print(reviews.length);
    } catch (e) {
      print('Error: $e');
    }
    setState(() {});
    return;
  }

  Future<User> fetchUserData(String userID) async {
    try {
      userData = await new User.NoData().retrieveUserData(userID);
      //print(reviews.length);
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
                      onPressed: () =>     setState(() {})

                    ),
                  ),
              ]),
            ),
          ),
          // Reviews
          Expanded(
              flex: 4,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: reviews.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context,index){
                    Review review1 = Review(
                      reviews[index].description.toString(),
                      reviews[index].idPlace!.toInt(),
                      reviews[index].userName.toString(),
                      reviews[index].userID.toString(),
                      reviews[index].rating!.toDouble()
                    );
                    userData = data[reviews[index]] ?? new User("1zZN5372jIRzwZCKyEfNGIM8weQ2","Mexico","https://scontent-mad1-1.xx.fbcdn.net/v/t39.30808-6/440053274_827597302719647_1588826766469346134_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=5f2048&_nc_ohc=1f4b40E9lUcQ7kNvgHwKJ-o&_nc_ht=scontent-mad1-1.xx&oh=00_AYC2xOdMLnS8qvV4PIo4_z5rIoGfwKa2gwBn9MMlJKiHNw&oe=666D93B2");
                    return GestureDetector(
                      onTap: () {

                      },
                      child: ReviewTile(
                        review: review1,
                        user: userData,
                      ),
                    );

                  }


              )
          ),
        ],
      ),
    ));
  }






}
