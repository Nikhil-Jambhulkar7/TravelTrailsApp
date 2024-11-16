import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, String>> _cartItems = [];

  List<Map<String, String>> get cartItems => _cartItems;

  void addToCart(String title, String description, String price, String image) {
    _cartItems.add({
      'title': title,
      'description': description,
      'price': price,
      'image': image,
    });
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> item) {
    _cartItems.remove(item);
    notifyListeners();
  }
}
