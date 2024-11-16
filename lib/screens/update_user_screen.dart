import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveltrails/utils/constants.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController =
      TextEditingController(); // First name field
  final TextEditingController _lastNameController =
      TextEditingController(); // Last name field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch user data when the screen loads
  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId!.isNotEmpty) {
      final response = await http.get(
        Uri.parse('http://192.168.43.11/getUserProfile.php?userId=$userId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final user = data['user'];
          setState(() {
            _usernameController.text = user['username'] ?? '';
            _firstNameController.text = user['first_name'] ?? '';
            _lastNameController.text = user['last_name'] ?? '';
            _emailController.text = user['email'] ?? '';
            _phoneController.text = user['phone'] ?? '';
            _addressController.text = user['address'] ?? '';
          });
        } else {
          throw Exception('Failed to load user data');
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      // Handle error if userId is not available
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Update user information on the backend
  Future<void> _updateUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId!.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2/updateProfile.php'),
          body: {
            'userId': userId,
            'username': _usernameController.text,
            'first_name': _firstNameController.text, // Send first name
            'last_name': _lastNameController.text, // Send last name
            'email': _emailController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'success') {
            // Show success popup
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Success'),
                  content: const Text('User Information updated successfully'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );

            // Wait for 2 seconds and then navigate to the Profile screen
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context); // Close the UpdateUserScreen
              Navigator.pushReplacementNamed(
                  context, '/profile'); // Navigate to Profile screen
            });
          } else {
            throw Exception('Failed to update profile');
          }
        } else {
          throw Exception('Failed to update profile');
        }
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating profile data')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details',
            style: TextStyle(color: AppConstants.whiteColor)),
        backgroundColor: AppConstants.appbarColor,
        iconTheme: const IconThemeData(color: AppConstants.whiteColor),
        elevation: 10.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    // First name field
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Last name field
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Phone field
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Address field
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Update button
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateUserInfo,
                        style: AppConstants.buttonStyle,
                        child: const Text('Update Information'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
