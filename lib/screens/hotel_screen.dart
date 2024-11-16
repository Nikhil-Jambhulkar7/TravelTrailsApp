import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traveltrails/utils/constants.dart';
import 'dart:convert';
import 'package:traveltrails/utils/custom_appbar.dart';
import 'package:traveltrails/utils/custom_bottom_navbar.dart';
import 'package:shimmer/shimmer.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  List<dynamic> _hotels = [];
  int _selectedIndex = 1;

  Future<void> _fetchHotels() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/get_hotels.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _hotels = data;
        });
      } else {
        // Handle error if the request fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load hotels')),
        );
      }
    } catch (e) {
      // Catch JSON decoding errors or any other exceptions
      print("Error parsing JSON: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error parsing hotels data')),
      );
    }
  }

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
  void initState() {
    super.initState();
    _fetchHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Hotels'),
      body: _hotels.isEmpty
          ? ListView.builder(
              itemCount: 5, // Number of shimmer placeholders
              itemBuilder: (ctx, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    title: Container(
                      width: double.infinity,
                      height: 20.0,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 15.0,
                      color: Colors.white,
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: _hotels.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    _hotels[index]['name'],
                    style: AppConstants.heading3Style,
                  ),
                  subtitle: Text(_hotels[index]['location']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailScreen(
                          hotel: _hotels[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HotelDetailScreen extends StatelessWidget {
  final dynamic hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hotel['name'],
          style: const TextStyle(color: AppConstants.whiteColor),
        ),
        backgroundColor: AppConstants.appbarColor,
        iconTheme: const IconThemeData(color: AppConstants.whiteColor),
        elevation: 10.0,
      ),
      body: Column(
        children: [
          hotel['image'] != null
              ? Image.network(
                  hotel['image'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              hotel['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Location: ${hotel['location']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Overview: ${hotel['description']}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/hotels');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/destinations');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/packages');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
