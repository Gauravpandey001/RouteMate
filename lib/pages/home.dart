import 'package:flutter/material.dart';
import 'package:routemate/pages/find.dart';
import 'package:routemate/pages/offer.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable automatic back button
        toolbarHeight: 1, // Set toolbar height
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.search),
              text: 'Find Riders',
            ),
            Tab(
              icon: Icon(Icons.directions_car),
              text: 'Offer a Ride',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FindPage(userId: widget.userId),
          OfferPage(userId: widget.userId),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
