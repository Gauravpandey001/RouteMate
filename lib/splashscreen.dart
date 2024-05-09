import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/phoneauth.dart';
import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay before navigating to the Dashboard or PhoneAuth screen
    Future.delayed(Duration(seconds: 2), () {
      // Check the user's authentication status
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in, navigate to Dashboard directly
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(userId: user.uid)),
        );
      } else {
        // User is not signed in, navigate to PhoneAuth screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PhoneAuth()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "RouteMate",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Image.asset('lib/assets/logo.png'), // Display the logo image from the assets folder
            ],
          ),
        ),
      ),
    );
  }
}
