import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routemate/pages/divider.dart';

class BottomCard extends StatelessWidget {
  final Function(LatLng) onLocationSelected;

  BottomCard({required this.onLocationSelected});

  TextEditingController _searchController = TextEditingController();

  void _searchLocation(BuildContext context) async {
    String query = _searchController.text;
    List<Location> locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      Location firstLocation = locations.first;
      onLocationSelected(LatLng(firstLocation.latitude, firstLocation.longitude));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location not found!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.0),
            Text("Hi there,", style: TextStyle(fontSize: 12.0)),
            Text("What's your destination?", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold")),
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.blueAccent,),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Location',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => _searchLocation(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Icon(Icons.home, color: Colors.grey,),
                SizedBox(width: 12.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Home"),
                    SizedBox(height: 4.0,),
                    Text("Enter your home address", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                  ],
                )
              ],
            ),
            DividerWidget(),
            SizedBox(height: 24.0),
            Row(
              children: [
                Icon(Icons.work, color: Colors.grey,),
                SizedBox(width: 12.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Work"),
                    SizedBox(height: 4.0,),
                    Text("Enter your office address", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
