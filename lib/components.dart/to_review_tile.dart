import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:madridmug_flutter/controllers/place.dart';

class ToReviewTile extends StatelessWidget {
  Place place;
  ToReviewTile({
    super.key,
    required this.place,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          blurRadius: 5,
          offset: Offset(1,5),
          color: Colors.grey.shade200
          )
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          place.placeName!,
          overflow: TextOverflow.ellipsis,
        )
      ),
    );
  }
}
