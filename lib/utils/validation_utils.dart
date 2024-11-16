// Validate email format
bool isValidEmail(String email) {
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

// Validate password strength (at least 8 characters, contains both letters and numbers)
bool isValidPassword(String password) {
  final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  return passwordRegex.hasMatch(password);
}

// Validate phone number (basic validation for 10-digit phone number)
bool isValidPhoneNumber(String phone) {
  final phoneRegex = RegExp(r'^\d{10}$');
  return phoneRegex.hasMatch(phone);
}
