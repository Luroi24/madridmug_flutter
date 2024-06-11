// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:madridmug_flutter/controllers/place.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final List<Place> places;

  const MapScreen({super.key, required this.latitude, required this.longitude, required this.places});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> placesMarkers = [];

  @override
  void initState(){
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    List<Marker> loadedMarkers = widget.places.map((record) {
    return Marker(
      point: LatLng(record.coordinates[0], record.coordinates[1]),
      width: 80,
      height: 80,
      alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.5),
      child: Icon(
        Icons.location_pin,
        size: 60,
        color: Colors.red,
      ),
    );
  }).toList();
  Marker temp = Marker(
    point: LatLng(widget.latitude,widget.longitude),
    width: 80,
    height: 80,
    alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.5),
    child: Icon(
      Icons.location_pin,
      size: 60,
      color: Colors.brown,
    ),
  );
  loadedMarkers.add(temp);
  setState(() {
    placesMarkers = loadedMarkers;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(widget.latitude,widget.longitude),
            initialZoom: 15,
            interactionOptions:
                const InteractionOptions(flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag)),
        children: [
          openStreetMapTileLayer,
          MarkerLayer(markers: placesMarkers),
          PolylineLayer(
            polylines: placesMarkers.length > 2 ? [] : [
              Polyline(
                points: [
                  LatLng(widget.latitude,widget.longitude),
                  LatLng(widget.places[0].coordinates[0], widget.places[0].coordinates[1])
                ],
                color: Colors.pink.shade700,
                strokeWidth: 8
              ),
            ],
          )
        ]);
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
