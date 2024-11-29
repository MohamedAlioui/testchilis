import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((_, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Modifiez cette méthode pour accepter la quantité
  void addItem(String productId, String title, double price, int quantity, String image) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          image: existingCartItem.image,
          quantity: existingCartItem.quantity + quantity, // Ajoutez la quantité à celle déjà existante
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: productId,
          title: title,
          price: price,
          image: image,
          quantity: quantity, // Utilisez la quantité fournie
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  void updateItemQuantity(String itemId, int newQuantity) {
    if (_items.containsKey(itemId)) {
      if (newQuantity <= 0) {
        removeItem(itemId);
      } else {
        _items.update(
          itemId,
              (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            image: existingItem.image,
            quantity: newQuantity,
          ),
        );
      }
      notifyListeners();
    }
  }
}

