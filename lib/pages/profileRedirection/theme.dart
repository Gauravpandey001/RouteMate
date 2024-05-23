import 'package:flutter/material.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Customize app theme:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement functionality for changing theme
              },
              child: Text('Light Theme'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement functionality for changing theme
              },
              child: Text('Dark Theme'),
            ),
            // Add more theme options as needed
          ],
        ),
      ),
    );
  }
}
