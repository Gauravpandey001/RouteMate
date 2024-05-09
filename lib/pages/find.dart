import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindPage extends StatelessWidget {
  final String userId;

  FindPage({required this.userId});

  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(29.42796133580664, 79.085749655962),
    zoom: 20.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("find riders nearby"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
              myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller)
              {
                _controllerGoogleMap.complete(controller);
              },
          )
        ],
      )
    );
  }
}
