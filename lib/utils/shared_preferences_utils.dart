import 'package:shared_preferences/shared_preferences.dart';

// Save data to shared preferences
Future<void> saveToSharedPreferences(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

// Retrieve data from shared preferences
Future<String?> getFromSharedPreferences(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

// Remove data from shared preferences
Future<void> removeFromSharedPreferences(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
