import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.locations}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
  final List<LatLng> locations;
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // List of LatLng coordinates for markers
  final List<LatLng> points = [
    // LatLng(37.7749, -122.4194), // San Francisco
    // LatLng(34.0522, -118.2437), // Los Angeles
    LatLng(40.7128, -74.0060),  // New York City
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Locations'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(12.8248508, 80.0452181), // Initial position centered on San Francisco
          zoom: 4.0,
        ),
        markers: _createMarkers(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return points.map((point) {
      return Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Some Location',
          snippet: 'Lat: 12.8248508, Lng: 80.0452181}',
        ),
      );
    }).toSet();
  }
}