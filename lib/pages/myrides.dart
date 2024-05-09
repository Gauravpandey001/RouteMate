import 'package:flutter/material.dart';

class MyRidesScreen extends StatelessWidget {
  final String userId;

  MyRidesScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable automatic back button
        title: Text('My Rides'),
      ),
      body: Center(
        child: Text('Your rides will be displayed here, User $userId'),
      ),
    );
  }
}
