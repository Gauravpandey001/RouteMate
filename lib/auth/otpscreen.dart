import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routemate/dashboard.dart';
import 'package:routemate/registration.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;

  OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Screen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                suffixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(
                  PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text.toString(),
                  ),
                );

                if (userCredential.additionalUserInfo!.isNewUser) {
                  // If the user is new, navigate to registration screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen(userId: userCredential.user!.uid)),
                  );
                } else {
                  // If the user already exists, navigate to dashboard screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen(userId: userCredential.user!.uid)),
                  );
                }
              } catch (ex) {
                log(ex.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("OTP verification failed. Please try again."),
                  ),
                );
              }
            },
            child: Text("Verify OTP"),
          ),
        ],
      ),
    );
  }
}
