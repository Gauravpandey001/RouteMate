import 'package:flutter/material.dart';
import 'package:routemate/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegistrationScreen extends StatefulWidget {
  final String userId;
  const RegistrationScreen({Key? key, required this.userId}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _selectedGender = 'Male'; // Default gender
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  Future<void> _registerUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if any required field is empty
        if (_firstNameController.text.trim().isEmpty ||
            _lastNameController.text.trim().isEmpty ||
            _emailController.text.trim().isEmpty ||
            _dobController.text.trim().isEmpty) {
          // Show error message to user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("All fields are required"),
            ),
          );
          return; // Exit registration process
        }

        // Set user data in Realtime Database
        await _database.child('users').child(widget.userId).set({
          'userId': widget.userId,
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'dob': _dobController.text.trim(),
          'gender': _selectedGender,
        });

        // Navigate to dashboard screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(userId: widget.userId)),
        );
      }
    } catch (error) {
      print('Error registering user: $error');
      // Display error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error registering user. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(

        backgroundColor: Colors.grey.shade900,
        title: Text('RouteMate',style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        )),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100], // Set background color
        ),
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFieldWithLabel('First Name', _firstNameController),
              SizedBox(height: 16.0,),
              _buildTextFieldWithLabel('Last Name', _lastNameController),
              SizedBox(height: 16.0),
              _buildTextFieldWithLabel('Email', _emailController),
              SizedBox(height: 16.0),
              _buildDateFieldWithLabel('Date of Birth', _dobController),
              SizedBox(height: 16.0),
              _buildDropdownWithLabel('Gender', _selectedGender),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                ),
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFieldWithLabel(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: Icon(Icons.calendar_today),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownWithLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
          },
          items: <String>['Male', 'Female', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: RegistrationScreen(userId: '123'), // Example user ID
  ));
}
