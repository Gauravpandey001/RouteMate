import 'package:flutter/material.dart';

class AboutRouteMateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About RouteMate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'RouteMate',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'RouteMate is an app for managing routes and rides. It helps users plan their journeys efficiently and provides real-time navigation and tracking features.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Contact us at support@routemate.com for any assistance or feedback.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
