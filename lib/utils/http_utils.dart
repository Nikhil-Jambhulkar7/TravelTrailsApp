import 'package:http/http.dart' as http;
import 'dart:convert';

// Method for making POST requests
Future<Map<String, dynamic>> postRequest(
    String url, Map<String, String> data) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      body: data,
    );

    // Handle success or failure based on the status code
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

// Method for making GET requests
Future<Map<String, dynamic>> getRequest(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
