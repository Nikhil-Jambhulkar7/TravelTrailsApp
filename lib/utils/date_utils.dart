import 'package:intl/intl.dart';

// Format date into a specific pattern
String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

// Convert timestamp to DateTime
DateTime timestampToDate(int timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}
