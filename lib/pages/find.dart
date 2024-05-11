import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routemate/pages/find/BottomCard.dart';
import 'package:routemate/pages/find/TopCard.dart'; // Import TopCard.dart

class FindPage extends StatefulWidget {
  final String userId;

  FindPage({required this.userId});

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer<GoogleMapController>();
  Marker? _currentLocationMarker; // Current Location Marker
  Marker? _pickupMarker; // Pickup Marker
  bool _bottomCardVisible = true;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(29.42796133580664, 79.085749655962),
    zoom: 5,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
            },
            markers: Set.of([
              if (_currentLocationMarker != null) _currentLocationMarker!,
              if (_pickupMarker != null) _pickupMarker!,
            ]),
            onCameraMove: (CameraPosition position) {
              if (_bottomCardVisible) {
                setState(() {
                  _bottomCardVisible = false;
                });
              }
            },
          ),
          if (_pickupMarker != null) // Display Pickup Marker
            Positioned(
              left: MediaQuery.of(context).size.width / 2.14 - 12,
              top: MediaQuery.of(context).size.height / 2.87 - 10,
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 48,
              ),
            ),
          if (_bottomCardVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: BottomCard(), // Use the BottomCard widget here
              ),
            ),
          if (!_bottomCardVisible)
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _bottomCardVisible = true;
                  });
                },
                child: Text('Confirm'),
              ),
            ),
          TopCard(), // Use TopCard widget here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }

  void _getCurrentLocation() async {
    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Create a LatLng object from the current position
    LatLng latLng = LatLng(position.latitude, position.longitude);

    // Create a Marker for the current location
    _currentLocationMarker = Marker(
      markerId: MarkerId("Pickup Marker"),
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: "Pickup Location",
        snippet: "Your pickup location",
      ),
    );

    // Set Pickup Marker
    _pickupMarker = Marker(
      markerId: MarkerId("current"),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: "Current Location",
        snippet: "This is your current location",
      ),
    );

    // Get the GoogleMapController
    final GoogleMapController controller = await _controllerGoogleMap.future;

    // Animate camera to the current position
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 17));

    // Update the UI to show the markers
    setState(() {});
  }
}
