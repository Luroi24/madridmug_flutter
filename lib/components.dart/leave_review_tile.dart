import 'package:flutter/material.dart';
import 'package:madridmug_flutter/controllers/place_test.dart';
import '../controllers/review.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import '../controllers/user.dart';

class ReviewTile extends StatelessWidget {
  Review review;
  User user;

  ReviewTile({super.key, required this.review, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(right: 25.0, bottom: 20),
      width: 180,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(4, 8), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("je"),
          ),
        ],
      ),
    );
  }
}
