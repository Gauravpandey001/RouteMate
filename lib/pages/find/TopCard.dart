import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Leaving from...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Material(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                onTap: () {
                  // Add functionality to handle search icon click
                },
                borderRadius: BorderRadius.circular(22.0),
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
