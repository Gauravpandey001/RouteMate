import 'package:flutter/material.dart';

// Mock database to simulate user data
Map<String, Map<String, String>> mockDatabase = {
  'user1': {
    'name': 'Rajesh Joshi',
    'profilePicUrl': 'https://example.com/profile1.jpg',
  },
  'user2': {
    'name': 'Gaurav Pandey',
    'profilePicUrl': 'https://example.com/profile2.jpg',
  },
  'user3': {
    'name': 'Vijay Joshi',
    'profilePicUrl': 'https://example.com/profile3.jpg',
  },
  'user4': {
    'name': 'Rajendra Singh Arora',
    'profilePicUrl': 'https://example.com/profile3.jpg',
  },
};

class Ride {
  final String riderId;
  final String passengerId;
  final String distanceTravelled;
  final String amount;
  final String pickUpPoint;
  final String destinationPoint;

  Ride({
    required this.riderId,
    required this.passengerId,
    required this.distanceTravelled,
    required this.amount,
    required this.pickUpPoint,
    required this.destinationPoint,
  });
}

class MyRidesScreen extends StatelessWidget {
  final String userId;

  MyRidesScreen({super.key, required this.userId});

  final List<Ride> rideHistory = [
    Ride(
      riderId: 'user1',
      passengerId: 'user2',
      distanceTravelled: '15 km',
      amount: '\$20',
      pickUpPoint: 'DBUU',
      destinationPoint: 'Manduwala Chauk',
    ),
    Ride(
      riderId: 'user3',
      passengerId: 'user2',
      distanceTravelled: '10 km',
      amount: '\$15',
      pickUpPoint: 'Sudhowala',
      destinationPoint: 'Clock Tower',
    ),
    Ride(
      riderId: 'user1',
      passengerId: 'user3',
      distanceTravelled: '20 km',
      amount: '\$30',
      pickUpPoint: 'Ballupur',
      destinationPoint: 'Rajpur Road',
    ),    Ride(
      riderId: 'user4',
      passengerId: 'user2',
      distanceTravelled: '40 km',
      amount: '\$55',
      pickUpPoint: 'vikash nagar',
      destinationPoint: 'Rajpur Road',
    ),
    // Add more mock rides as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade800,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Rides'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: rideHistory.length,
        itemBuilder: (context, index) {
          final ride = rideHistory[index];
          return FutureBuilder<Map<String, String>?>(
            future: _getRideUserDetails(ride),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error loading user details');
              }
              final rideUserDetails = snapshot.data!;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 25.0),
                color: Colors.blue[800],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildUserDetailRow(
                        'Rider:',
                        rideUserDetails['riderName']!,
                        rideUserDetails['riderProfilePicUrl']!,
                      ),SizedBox(height: 20,),
                      _buildUserDetailRow(
                        'Passenger:',
                        rideUserDetails['passengerName']!,
                        rideUserDetails['passengerProfilePicUrl']!,
                      ),
                      const Divider(),
                      _buildRideDetails(ride),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserDetailRow(String role, String name, String profilePicUrl) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(profilePicUrl),
        ),
        const SizedBox(width: 8),
        Text(
          '$role $name',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildRideDetails(Ride ride) {
    TextStyle detailTextStyle = const TextStyle(fontSize: 20, color: Colors.white);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Distance: ${ride.distanceTravelled}', style: detailTextStyle),
        Text('Amount: ${ride.amount}', style: detailTextStyle),
        Text('From: ${ride.pickUpPoint}', style: detailTextStyle),
        Text('To: ${ride.destinationPoint}', style: detailTextStyle),
      ],
    );
  }


  Future<Map<String, String>?> _getRideUserDetails(Ride ride) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final riderDetails = mockDatabase[ride.riderId];
    final passengerDetails = mockDatabase[ride.passengerId];
    return {
      'riderName': riderDetails!['name']!,
      'riderProfilePicUrl': riderDetails['profilePicUrl']!,
      'passengerName': passengerDetails!['name']!,
      'passengerProfilePicUrl': passengerDetails['profilePicUrl']!,
    };
  }
}

void main() {
  runApp(MaterialApp(
    home: MyRidesScreen(userId: 'user1'),
  ));
}
