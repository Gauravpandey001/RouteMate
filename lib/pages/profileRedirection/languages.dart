import 'package:flutter/material.dart';

class LanguagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your preferred language:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement functionality for selecting language
              },
              child: Text('English'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement functionality for selecting language
              },
              child: Text('Spanish'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement functionality for selecting language
              },
              child: Text('French'),
            ),
            // Add more language buttons as needed
          ],
        ),
      ),
    );
  }
}
