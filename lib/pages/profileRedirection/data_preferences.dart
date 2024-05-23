import 'package:flutter/material.dart';

class DataPreferencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Preferences'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manage your data preferences:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Analytics'),
              subtitle: Text('Enable analytics data collection'),
              value: true, // Example value, replace with actual preference value
              onChanged: (value) {
                // Implement functionality for toggling analytics preference
              },
            ),
            SwitchListTile(
              title: Text('Notifications'),
              subtitle: Text('Enable push notifications'),
              value: false, // Example value, replace with actual preference value
              onChanged: (value) {
                // Implement functionality for toggling notifications preference
              },
            ),
            // Add more data preferences as needed
          ],
        ),
      ),
    );
  }
}
