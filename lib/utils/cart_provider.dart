import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String price;
  final String type;
  final String imageName;
  int quantity; // Nueva propiedad para la cantidad

  CartItem({
    required this.name,
    required this.price,
    required this.type,
    required this.imageName,
    this.quantity = 1, // Valor por defecto 1
  });

  // Método para incrementar cantidad
  void incrementQuantity() {
    quantity++;
  }

  // Método para decrementar cantidad
  bool decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      return false; // No eliminar
    }
    return true; // Eliminar si la cantidad llega a 0
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(String name, String price, String type, String imageName) {
    // Buscar si ya existe un item igual
    final existingIndex = _items.indexWhere(
      (item) => item.name == name && item.type == type,
    );

    if (existingIndex >= 0) {
      // Si existe, incrementar cantidad
      _items[existingIndex].incrementQuantity();
    } else {
      // Si no existe, añadir nuevo item
      _items.add(CartItem(
        name: name,
        price: price,
        type: type,
        imageName: imageName,
      ));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index].incrementQuantity();
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_items[index].decrementQuantity()) {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice {
    return _items.fold(0, (sum, item) {
      return sum + (double.tryParse(item.price) ?? 0) * item.quantity;
    });
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}