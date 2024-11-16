import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:traveltrails/utils/constants.dart';
import 'package:traveltrails/utils/custom_appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlertDialog('Please fill in both username and password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/login.php'),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      setState(() {
        _isLoading = false;
      });

      // Check if the response is a valid JSON and handle it accordingly
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (response.statusCode == 200 && responseData['status'] == 'success') {
          final userData = responseData['user'];

          // Store user data in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userData['id'].toString());
          await prefs.setString('username', userData['username']);
          await prefs.setString('email', userData['email']);
          await prefs.setString('first_name', userData['first_name']);
          await prefs.setString('last_name', userData['last_name']);

          // Navigate to home screen
          Navigator.pushReplacementNamed(context, '/home', arguments: userData);
        } else {
          _handleResponseStatus(responseData);
        }
      } else {
        _showAlertDialog('Unexpected error occurred.');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showAlertDialog('Network error. Check your connection and try again.');
    }
  }

  void _handleResponseStatus(Map<String, dynamic> responseData) {
    switch (responseData['status']) {
      case 'user_not_found':
        _showAlertDialog('User not found. Please check your username.');
        break;
      case 'incorrect_password':
        _showAlertDialog('Incorrect password. Please try again.');
        break;
      default:
        _showAlertDialog('Unexpected error. Please try again.');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Login'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: AppConstants.buttonStyle,
                    child: const Text('Login'),
                  ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
