import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewdTile extends StatelessWidget {
  const ReviewdTile({super.key});

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Cafeteria number X",
                overflow: TextOverflow.ellipsis,
                ))),
          Expanded(
            flex: 1,
            child: RatingBar(
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 32,
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
                }),
          )
        ],
      ),
    );
  }
}
