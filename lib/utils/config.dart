import 'dart:io';

class Config {
  // Base URL
  static String getBaseUrl() {
    if (Platform.isAndroid) {
      // If running on Android emulator or physical device
      return isDevice()
          ? 'http://192.168.1.2/' // replace with your local machine's IP address for device
          : 'http://10.0.2.2/'; // for Android emulator
    } else if (Platform.isIOS) {
      // For iOS simulator or device
      return 'http://localhost/'; // Replace with appropriate URL for iOS
    } else {
      return 'http://localhost/'; // You can customize for web or other platforms
    }
  }

  // Checks if the app is running on a physical device
  static bool isDevice() {
    return !Platform.isIOS &&
        !Platform.isMacOS &&
        !Platform.isWindows &&
        !Platform.isLinux;
  }

  // Example endpoint function
  static String getHotelsEndpoint() {
    return '${getBaseUrl()}get_hotels.php';
  }
}
