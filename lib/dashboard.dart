import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routemate/pages/home.dart';
import 'package:routemate/pages/myrides.dart';
import 'package:routemate/pages/wallet.dart';
import 'package:routemate/pages/profile.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  DashboardScreen({required this.userId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Define your custom colors
  Color blueColor = Colors.blue;
  Color yellowColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: blueColor, // Set app bar color
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(userId: widget.userId),
          MyRidesScreen(userId: widget.userId),
          WalletScreen(userId: widget.userId),
          ProfileScreen(userId: widget.userId), // Pass userId here
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'My Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: blueColor, // Set selected item color
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        onTap: _onItemTapped,
        backgroundColor: yellowColor, // Set bottom navigation bar color
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
