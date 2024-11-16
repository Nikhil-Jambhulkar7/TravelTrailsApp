import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://localhost/traveltrails/";

  // Example: Login API
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login.php'),
      body: {
        'email': email,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }

  // Example: Signup API
  Future<Map<String, dynamic>> signup(String email, String password,
      String name, String phone, String address) async {
    final response = await http.post(
      Uri.parse('${baseUrl}signup.php'),
      body: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'address': address,
      },
    );

    return jsonDecode(response.body);
  }

  // Example: Get Hotels API
  Future<List<dynamic>> getHotels() async {
    final response = await http.get(Uri.parse('${baseUrl}get_hotels.php'));

    return jsonDecode(response.body);
  }
}
