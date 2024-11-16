import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveltrails/models/cart.dart';
import 'package:traveltrails/screens/destinations.dart';
import 'package:traveltrails/screens/home_screen.dart';
import 'package:traveltrails/screens/hotel_screen.dart';
import 'package:traveltrails/screens/login_screen.dart';
import 'package:traveltrails/screens/packages.dart';
import 'package:traveltrails/screens/profile.dart';
import 'package:traveltrails/screens/signup_screen.dart';
import 'package:traveltrails/utils/constants.dart';

void main() {
  runApp(const TravelTrailsApp());
}

class TravelTrailsApp extends StatelessWidget {
  const TravelTrailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        title: 'TravelTrails',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: AppConstants.backgroundColor,
        ),
        initialRoute: '/login',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/hotels': (context) => const HotelScreen(),
          '/destinations': (context) => const DestinationsScreen(),
          '/packages': (context) => const PackagesScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
