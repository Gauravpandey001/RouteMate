import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routemate/pages/find/BottomCard.dart';
import 'package:routemate/pages/find/TopCard.dart';
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
  bool _pickupConfirmed = false; // Variable to track if pickup is confirmed
  LatLng? _centerLocation; // Center location of the map
  String? _locationAddress; // Address of the center location
  bool _searchingForRiders = false; // Flag to indicate searching for riders

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
              _centerLocation = position.target; // Update the center location
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
          if (!_bottomCardVisible)
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _bottomCardVisible = true;
                    _pickupConfirmed = true; // Pickup confirmed
                  });
                  if (_centerLocation != null) {
                    await _getAddressFromLatLng(_centerLocation!);
                  }
                },
                child: Text('Confirm Pickup Location'),
              ),
            ),
          if (!_bottomCardVisible && _pickupConfirmed) // Show button only if pickup is confirmed
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _searchingForRiders = true;
                  });
                  // Implement logic for confirming drop location and searching for riders
                  // For demonstration purposes, we use a delay to simulate searching for riders
                  await Future.delayed(Duration(seconds: 3));
                  setState(() {
                    _searchingForRiders = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Confirm Drop Location'),
              ),
            ),
          if (_searchingForRiders)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Looking for riders nearby...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Reset all states and markers
                      setState(() {
                        _searchingForRiders = false;
                        _bottomCardVisible = true;
                        _pickupConfirmed = false;
                        _pickupMarker = null;
                      });
                    },
                    child: Text('Cancel'),
                  ),
                ],
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
                child: BottomCard(
                  onLocationSelected: (LatLng position) {
                    _addPickupMarker(position);
                  },
                ), // Use the BottomCard widget here
              ),
            ),
          TopCard(location: _locationAddress), // Use TopCard widget here
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
      markerId: MarkerId("current"),
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: "Current Location",
        snippet: "This is your current location",
      ),
    );

    // Set Pickup Marker
    _pickupMarker = Marker(
      markerId: MarkerId("Pickup Marker"),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: "Pickup Location",
        snippet: "Your pickup location",
      ),
    );

    // Get the GoogleMapController
    final GoogleMapController controller = await _controllerGoogleMap.future;

    // Animate camera to the current position
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 17));

    // Update the UI to show the markers
    setState(() {});
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _locationAddress =
        "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void _addPickupMarker(LatLng position) async {
    _pickupMarker = Marker(
      markerId: MarkerId("pickup"),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: "Pickup Location",
        snippet: "Selected pickup location",
      ),
    );

    final GoogleMapController controller = await _controllerGoogleMap.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 17));

    setState(() {
      _bottomCardVisible = false;
    });
  }
}

