import 'package:flutter/material.dart';

class OfferPage extends StatelessWidget {
  final String userId;

  OfferPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Offer a Ride Section for User $userId'),
      ),
    );
  }
}
