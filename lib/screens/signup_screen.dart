import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:traveltrails/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String _gender = 'male';
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    // Request permissions
    PermissionStatus permission = await Permission.photos.request();
    if (!permission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to access gallery')),
      );
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  Future<void> _selectDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() {
      _dobController.text = "${pickedDate!.toLocal()}".split(' ')[0];
    });
  }

  bool _validateFields() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        !_isEmailValid(_emailController.text) ||
        _passwordController.text.length < 6 ||
        _phoneController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly.')),
      );
      return false;
    }
    return true;
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  Future<void> _signup() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2/signup.php'),
      );

      request.fields.addAll({
        'username': _usernameController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'date_of_birth': _dobController.text,
        'gender': _gender,
      });

      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          _profileImage!.path,
        ));
      } else {
        request.fields['profile_picture'] = 'default.png';
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print(
          'Response Body: $responseBody'); // Debug print to check the response

      final responseData = json.decode(responseBody); // Attempt to decode JSON

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Sign-up failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up',
            style: TextStyle(color: AppConstants.whiteColor)),
        backgroundColor: AppConstants.appbarColor,
        iconTheme: const IconThemeData(color: AppConstants.whiteColor),
        elevation: 10.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print("Profile Picture tapped");
                  _pickImage();
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(65.0),
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt,
                          size: 50, color: Colors.white)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(65.0),
                          child: Image.file(
                            File(_profileImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('First Name', _firstNameController),
              _buildTextField('Last Name', _lastNameController),
              _buildTextField('Email', _emailController),
              _buildTextField('Username', _usernameController),
              _buildTextField('Phone', _phoneController),
              _buildTextField('Address', _addressController),
              GestureDetector(
                onTap: _selectDateOfBirth,
                child: AbsorbPointer(
                  child: _buildTextField('Date of Birth', _dobController),
                ),
              ),
              Row(
                children: <Widget>[
                  const Text('Gender:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ...['male', 'female', 'other'].map((String gender) => Row(
                        children: [
                          Radio<String>(
                            value: gender,
                            groupValue: _gender,
                            onChanged: (String? value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                          Text(gender[0].toUpperCase() + gender.substring(1)),
                        ],
                      )),
                ],
              ),
              _buildTextField('Password', _passwordController,
                  obscureText: true),
              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signup,
                      style: AppConstants.buttonStyle,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
