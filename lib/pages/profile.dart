import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../auth/phoneauth.dart';
import 'package:routemate/pages/profileRedirection/languages.dart';
import 'package:routemate/pages/profileRedirection/permissions.dart';
import 'package:routemate/pages/profileRedirection/theme.dart';
import 'package:routemate/pages/profileRedirection/change_password.dart';
import 'package:routemate/pages/profileRedirection/reminders.dart';
import 'package:routemate/pages/profileRedirection/data_preferences.dart';
import 'package:routemate/pages/profileRedirection/about_routemate.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseReference _userRef;
  String _userName = '';
  String _userEmail = '';
  String _userGender = '';
  String _userDob = '';
  String? _imageUrl;
  bool _isLoading = false;

  List<Map<String, dynamic>> profileOptions = [
    {
      'label': 'Language',
      'icon': Icons.language,
      'screen': LanguagesScreen(),
    },
    {
      'label': 'Permissions',
      'icon': Icons.security,
      'screen': PermissionsScreen(),
    },
    {
      'label': 'Theme',
      'icon': Icons.palette,
      'screen': ThemeScreen(),
    },
    {
      'label': 'Change Password',
      'icon': Icons.lock,
      'screen': ChangePasswordScreen(),
    },
    {
      'label': 'Reminders',
      'icon': Icons.alarm,
      'screen': RemindersScreen(),
    },
    {
      'label': 'Data Preferences',
      'icon': Icons.data_usage,
      'screen': DataPreferencesScreen(),
    },
    {
      'label': 'About RouteMate',
      'icon': Icons.info,
      'screen': AboutRouteMateScreen(),
    },
  ];

  get _showEditImageOptions => null;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.reference().child('users').child(
        widget.userId);
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      DataSnapshot snapshot = await _userRef.get();
      if (snapshot.exists) {
        dynamic userData = snapshot.value;
        print('User data: $userData');
        if (userData != null && userData is Map<dynamic, dynamic>) {
          setState(() {
            _userName =
                '${userData['firstName']} ${userData['lastName']}' ?? 'No Name';
            _userEmail = userData['email'] ?? 'No Email';
            _userGender = userData['gender'] ?? 'No Gender';
            _userDob = userData['dob'] ?? 'No Date of Birth';
            _imageUrl = userData['profileImageUrl']; // Fetching image URL
          });
        } else {
          print('User data is not in the expected format');
        }
      } else {
        print('User data does not exist');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Hello $_userName', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileImage(),
            SizedBox(height: 20),
            _buildProfileCard(),
            SizedBox(height: 20),
            _buildOptionsList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User ID: ${widget.userId}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _showEditImageOptions,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _imageUrl != null
                ? NetworkImage(_imageUrl!)
                : null,
            backgroundColor: Colors.blue.shade200,
            child: _imageUrl == null ? Icon(
                Icons.person, size: 80, color: Colors.white) : null,
          ),
          if (_isLoading)
            CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return SizedBox(
      height: 350,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.blue.shade50,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileInfo('User Name:', _userName),
              _buildProfileInfo('Email:', _userEmail),
              _buildProfileInfo('Gender:', _userGender),
              _buildProfileInfo('Date of Birth:', _userDob),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: profileOptions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => profileOptions[index]['screen']),
            );
          },
          child: Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(profileOptions[index]['icon']),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      profileOptions[index]['label'],
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _logout() {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhoneAuth()),
      );
    }).catchError((error) {
      print('Error signing out: $error');
    });
  }
}
