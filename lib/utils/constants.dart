import 'package:flutter/material.dart';

class AppConstants {
  // Base URL for the API
  static const String baseUrl = 'http://your-backend-api.com/';

  // API endpoints
  static const String signupEndpoint = 'signup.php';
  static const String loginEndpoint = 'login.php';
  static const String getHotelsEndpoint = 'get_hotels.php';

  // Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color buttonColor = Color(0xFF00B3DC);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color textPrimaryColor = Color(0xFF000000);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color appbarColor = Color(0xFF00B3DC);
  static const Color whiteColor = Color(0xFFFFFFFF);

  // Text Sizes
  static const double heading1 = 32.0;
  static const double heading2 = 24.0;
  static const double heading3 = 18.0;
  static const double bodyText = 16.0;
  static const double smallText = 14.0;
  static const double captionText = 12.0;

  // Text Styles
  static const TextStyle heading1Style = TextStyle(
    fontSize: heading1,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle heading2Style = TextStyle(
    fontSize: heading2,
    fontWeight: FontWeight.w600,
    color: whiteColor,
  );

  static const TextStyle heading3Style = TextStyle(
    fontSize: heading3,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: bodyText,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
  );

  static const TextStyle smallTextStyle = TextStyle(
    fontSize: smallText,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
  );

  static const TextStyle captionTextStyle = TextStyle(
    fontSize: captionText,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
  );

  // Button Styles
  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: buttonColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
  static final ButtonStyle logoutbuttonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: const Color.fromARGB(255, 243, 59, 35),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  // Error Text Style
  static const TextStyle errorTextStyle = TextStyle(
    fontSize: bodyText,
    fontWeight: FontWeight.bold,
    color: errorColor,
  );

  // Success Text Style
  static const TextStyle successTextStyle = TextStyle(
    fontSize: bodyText,
    fontWeight: FontWeight.bold,
    color: successColor,
  );
}
