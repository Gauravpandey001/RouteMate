import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  final String userId;

  WalletScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable automatic back button
        title: Text('Wallet'),
      ),
      body: Center(
        child: Text('Your wallet information will be displayed here, User $userId'),
      ),
    );
  }
}
