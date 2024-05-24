import 'package:flutter/material.dart';

class RiderCard extends StatelessWidget {
  final VoidCallback onCancel;

  RiderCard({required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Your card UI here
      child: ElevatedButton(
        onPressed: onCancel,
        child: Text('Cancel'),
      ),
    );
  }
}
