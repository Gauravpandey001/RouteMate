import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../auth/phoneauth.dart';

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

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.reference().child('users').child(widget.userId);
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
            _userName = '${userData['firstName']} ${userData['lastName']}' ?? 'No Name';
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
        title: Text( 'Helllo '+_userName ,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileImage(),
                SizedBox(height: 40),
                _buildProfileCard(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Logout',style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
                SizedBox(height: 20),
                Text(
                  'User ID: ${widget.userId}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
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
            backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
            backgroundColor: Colors.blue.shade200,
            child: _imageUrl == null ? Icon(Icons.person, size: 80, color: Colors.white) : null,
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
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

  void _logout() {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneAuth()),
      );
    }).catchError((error) {
      print('Error signing out: $error');
    });
  }

  void _showEditImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _editImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Upload Image'),
                onTap: () {
                  Navigator.pop(context);
                  _editImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editImageFromCamera() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      _handleImageSelection(File(pickedImage.path));
    }
  }

  Future<void> _editImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _handleImageSelection(File(pickedImage.path));
    }
  }

  void _handleImageSelection(File pickedImage) {
    setState(() {
      _isLoading = true;
    });

    FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${widget.userId}.jpg')
        .putFile(pickedImage)
        .then((uploadTask) {
      uploadTask.ref.getDownloadURL().then((imageUrl) {
        setState(() {
          _imageUrl = imageUrl;
          _isLoading = false;
        });
        print('Image URL: $imageUrl');

        _userRef.child('profileImageUrl').set(imageUrl).then((_) {
          print('Profile image URL updated successfully.');
        }).catchError((error) {
          print('Error updating profile image URL: $error');
          setState(() {
            _isLoading = false;
          });
        });
      }).catchError((error) {
        print('Error getting download URL: $error');
        setState(() {
          _isLoading = false;
        });
      });
    }).catchError((error) {
      print('Error uploading image: $error');
      setState(() {
        _isLoading = false;
      });
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(userId: '123'), // Example user ID
  ));
}
