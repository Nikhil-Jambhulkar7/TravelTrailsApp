import 'package:flutter/material.dart';
import 'package:traveltrails/models/cart.dart';
import 'package:traveltrails/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BookingScreen extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String image;

  const BookingScreen({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isImageLoaded = false;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer effect for the image while it loads
            _isImageLoaded
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.image,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              "Rs. ${widget.price}/-",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showPurchaseDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Simulate a delay for the image to be loaded.
    _loadImage();
  }

  // Simulating image load time (replace with actual loading logic if necessary)
  Future<void> _loadImage() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isImageLoaded = true;
    });
  }

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Package Bought Successfully'),
          content: const Text('You have successfully bought the package.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<CartModel>(context, listen: false).addToCart(
                  widget.title,
                  widget.description,
                  widget.price,
                  widget.image,
                );
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
