import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveltrails/models/cart.dart';
import 'package:traveltrails/utils/custom_appbar.dart';
import 'package:traveltrails/utils/custom_bottom_navbar.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isFirstLogin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();
    _loadData();
  }

  Future<void> _checkFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

    if (isFirstLogin) {
      setState(() {
        _isFirstLogin = true;
      });
      await prefs.setBool('isFirstLogin', false);
    }
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating data load
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
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
    var cartItems = Provider.of<CartModel>(context).cartItems;

    return Scaffold(
      appBar: const CustomAppBar(title: 'TravelTrails'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search destinations...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_isFirstLogin) ...[
                const Text(
                  'Welcome to TravelTrails!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your gateway to amazing travel experiences',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 40),
              _isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildDestinationCard('assets/home_page/beach.jpg',
                              'Beautiful Beaches', Colors.blueAccent),
                          _buildDestinationCard('assets/home_page/mountain.jpg',
                              'Mountain Adventures', Colors.greenAccent),
                          _buildDestinationCard('assets/home_page/culture.jpg',
                              'Cultural Exploration', Colors.orangeAccent),
                        ],
                      ),
                    ),
              const SizedBox(height: 40),
              if (_isLoading) ...[
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: List.generate(
                      2,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: double.infinity,
                        height: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ] else if (cartItems.isEmpty) ...[
                const Text(
                  'You have not bought any packages yet.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/packages');
                  },
                  child: const Text('Browse Packages'),
                ),
              ] else ...[
                const Text(
                  'Your Purchased Packages:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.receipt),
                                  onPressed: () {
                                    _showReceiptDialog(context, item);
                                  },
                                ),
                              ],
                            ),
                            Text(item['description'] ?? ''),
                            const SizedBox(height: 10),
                            Text('Price: Rs. ${item['price']}'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<CartModel>(context, listen: false)
                                    .removeFromCart(item);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              child: const Text('Cancel Package'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildDestinationCard(String imagePath, String title, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          print('Tapped on $title');
        },
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                backgroundColor: color.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showReceiptDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${item['title']} Receipt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${item['description']}'),
              const SizedBox(height: 10),
              Text('Price: Rs. ${item['price']}'),
              const SizedBox(height: 10),
              Text('Departure Date: ${item['departureDate'] ?? 'N/A'}'),
              const SizedBox(height: 10),
              Text('General Information: ${item['generalInfo'] ?? 'N/A'}'),
              const SizedBox(height: 20),
              const Text('User Information:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Name: ${item['name'] ?? 'N/A'}'),
              Text('Age: ${item['age'] ?? 'N/A'}'),
              Text('Gender: ${item['gender'] ?? 'N/A'}'),
              Text('Address: ${item['address'] ?? 'N/A'}'),
              Text('Phone: ${item['phone'] ?? 'N/A'}'),
              Text('Email: ${item['email'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
