import 'package:flutter/material.dart';
import 'package:madridmug_flutter/models/place_test.dart';

class NearbyTile extends StatelessWidget {
  PlaceTest place;
  NearbyTile({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(right: 25.0),
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Transform.translate(
                    offset: const Offset(0,-5),
                    child: Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 11,
                      ),  
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 95,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(place.imagePath), 
                fit: BoxFit.fill
              ),
              borderRadius: BorderRadius.circular(12)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 79.5, left: 117.5),
            alignment: Alignment.center,
            height: 25,
            width: 55,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 82, left: 120),
            alignment: Alignment.center,
            height: 20,
            width: 50,
            decoration: BoxDecoration(
                color: const Color(0xFF3A544F), borderRadius: BorderRadius.circular(12)),
            child: Text(
              "${place.rating} ⭐",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
