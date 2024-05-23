import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manage your reminders:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Reminder 1'),
              subtitle: Text('Description of Reminder 1'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Implement functionality for editing reminder
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Reminder 2'),
              subtitle: Text('Description of Reminder 2'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Implement functionality for editing reminder
                },
              ),
            ),
            // Add more reminders as needed
          ],
        ),
      ),
    );
  }
}
