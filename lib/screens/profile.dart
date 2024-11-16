import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveltrails/screens/update_user_screen.dart';
import 'package:traveltrails/utils/constants.dart';
import 'package:traveltrails/utils/custom_appbar.dart';
import 'package:traveltrails/utils/custom_bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = true;
  late String userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Retrieve userId from SharedPreferences with added check
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    print(
        "Retrieved userId from SharedPreferences: $userId"); // Debug statement

    if (userId.isEmpty) {
      // Show error and redirect to login if userId is not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User ID is not available. Please login again.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _fetchUserData();
    }
  }

  // Fetch user data from the server
  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.11/getUserProfile.php?userId=$userId'),
      );

      // print('Server response: ${response.body}'); // Debugging response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final user = data['user'];
          setState(() {
            _usernameController.text = user['username'] ?? '';
            _fullNameController.text = user['first_name'] != null
                ? '${user['first_name']} ${user['last_name']}'
                : '';
            _emailController.text = user['email'] ?? '';
            _phoneController.text = user['phone'] ?? '';
            _addressController.text = user['address'] ?? '';
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Error fetching profile');
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching profile data.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Toggle between edit and view modes
  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // Update profile information on the server
  Future<void> _updateProfileInfo() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/updateProfile.php'),
        body: {
          'userId': userId,
          'username': _usernameController.text,
          'full_name': _fullNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          setState(() {
            _isEditing = false;
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
        const SnackBar(content: Text('Error updating profile data.')),
      );
    }
  }

  // Logout the user and clear session data
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data

    Navigator.pushReplacementNamed(context, '/login');
  }

  // Show logout confirmation dialog
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _logout(); // Proceed with logout
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Bottom navigation item tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/hotels');
        break;
      case 2:
        Navigator.pushNamed(context, '/destinations');
        break;
      case 3:
        Navigator.pushNamed(context, '/packages');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/default.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileDetail(
                    title: 'Full Name',
                    detailController: _fullNameController,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 10),
                  ProfileDetail(
                    title: 'Username',
                    detailController: _usernameController,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 10),
                  ProfileDetail(
                    title: 'Email',
                    detailController: _emailController,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 10),
                  ProfileDetail(
                    title: 'Phone',
                    detailController: _phoneController,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 10),
                  ProfileDetail(
                    title: 'Address',
                    detailController: _addressController,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: AppConstants.buttonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UpdateUserScreen()),
                          );
                        },
                        child: const Text('Edit Info'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _showLogoutConfirmation,
                        style: AppConstants.logoutbuttonStyle,
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String title;
  final TextEditingController detailController;
  final bool isEditing;

  const ProfileDetail({
    super.key,
    required this.title,
    required this.detailController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: isEditing
              ? TextField(
                  controller: detailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                )
              : Text(
                  detailController.text,
                  style: const TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }
}
