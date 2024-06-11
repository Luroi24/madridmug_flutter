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
      height: 150,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10,left: 10),
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          radius: 100.0,
                          backgroundImage: NetworkImage(user.profileURL.toString()),
                        ),
                      ),
                      Container(
                        width: 85.0,
                      height: 30.0,
                      child: Text(
                        review.userName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9.2,
                          overflow: TextOverflow.ellipsis
                        ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                      )
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 190,
                        // https://pub.dev/packages/flutter_rating_stars
                        child: RatingStars(
                          value: review.rating!.toDouble(),
                          starBuilder: (index, color) => Icon(
                            Icons.star,
                            color: color,
                          ),
                          starCount: 5,
                          starSize: 20,
                          valueLabelColor: const Color(0xff9b9b9b),
                          valueLabelTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          valueLabelRadius: 10,
                          maxValue: 5,
                          starSpacing: 2,
                          maxValueVisibility: true,
                          valueLabelVisibility: true,
                          animationDuration: Duration(milliseconds: 2000),
                          valueLabelPadding:
                          const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                          valueLabelMargin: const EdgeInsets.only(right: 8),
                          starOffColor: const Color(0xffe7e8ea),
                          starColor: Colors.yellow,
                        )
                      ),
                      ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        width: 190,
                        child: Text(
                    review.description.toString(),
                    maxLines: 6,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                          textAlign: TextAlign.justify,
                  ),
                      )
                  ]
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
