import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:madridmug_flutter/models/place_test.dart';

class PopularTile extends StatelessWidget {
  PlaceTest place;
  PopularTile({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(right: 25.0),
      width: 190,
      decoration: BoxDecoration(
          image: DecorationImage(
            // TODO: Remplazar con la imagen de firebase
            image: AssetImage(place.images[1]),
            fit: BoxFit.cover,
          ),
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4.0, right: 6.0),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(77, 86, 82, 1.0),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          place.name,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(77, 86, 82, 1.0),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${place.rating.toString()} ⭐",
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Icon(
                  place.rating > 3 ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
