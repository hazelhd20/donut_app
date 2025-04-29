// Importación del paquete principal de Flutter para acceder a elementos de UI y gestión de estado
import 'package:flutter/material.dart';

// Clase que define la estructura de un ítem del carrito de compras
class CartItem {
  final String name;      // Nombre del producto
  final String price;     // Precio del producto (almacenado como String)
  final String type;      // Tipo o categoría del producto
  final String imageName; // Nombre del archivo de imagen del producto
  int quantity;           // Cantidad de unidades del producto en el carrito

  // Constructor que requiere valores obligatorios y establece cantidad por defecto
  CartItem({
    required this.name,
    required this.price,
    required this.type,
    required this.imageName,
    this.quantity = 1,    // Valor predeterminado: 1 unidad
  });

  // Método para aumentar la cantidad del producto en una unidad
  void incrementQuantity() {
    quantity++;
  }

  // Método para disminuir la cantidad del producto en una unidad
  // Retorna true si el ítem debe ser eliminado (cantidad = 0)
  bool decrementQuantity() {
    if (quantity > 1) {
      quantity--;         // Reduce la cantidad si es mayor a 1
      return false;       // No eliminar del carrito
    }
    return true;          // Eliminar del carrito si la cantidad llega a 0
  }
}

// Clase principal para gestionar el estado del carrito usando el patrón Provider
class CartProvider extends ChangeNotifier {
  List<CartItem> _items = []; // Lista privada de ítems en el carrito

  // Getter que expone la lista de ítems (pero no permite modificarla directamente)
  List<CartItem> get items => _items;

  // Método para añadir un producto al carrito
  void addItem(String name, String price, String type, String imageName) {
    // Busca si el producto ya existe en el carrito por nombre y tipo
    final existingIndex = _items.indexWhere(
      (item) => item.name == name && item.type == type,
    );

    if (existingIndex >= 0) {
      // Si el producto ya existe, incrementa su cantidad
      _items[existingIndex].incrementQuantity();
    } else {
      // Si es un producto nuevo, lo añade al carrito
      _items.add(CartItem(
        name: name,
        price: price,
        type: type,
        imageName: imageName,
      ));
    }
    notifyListeners(); // Notifica a los widgets que escuchan este provider para que se actualicen
  }

  // Método para eliminar un ítem del carrito por su índice
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners(); // Notifica cambios
  }

  // Método para aumentar la cantidad de un producto específico
  void increaseQuantity(int index) {
    _items[index].incrementQuantity();
    notifyListeners(); // Notifica cambios
  }

  // Método para disminuir la cantidad de un producto específico
  void decreaseQuantity(int index) {
    if (_items[index].decrementQuantity()) {
      // Si decrementQuantity retorna true, elimina el ítem del carrito
      _items.removeAt(index);
    }
    notifyListeners(); // Notifica cambios
  }

  // Getter que calcula el número total de artículos en el carrito (sumando cantidades)
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Getter que calcula el precio total del carrito considerando precios y cantidades
  double get totalPrice {
    return _items.fold(0, (sum, item) {
      // Convierte el precio de String a double y multiplica por la cantidad
      // Si la conversión falla, usa 0 como valor por defecto
      return sum + (double.tryParse(item.price) ?? 0) * item.quantity;
    });
  }

  // Método para vaciar completamente el carrito
  void clearCart() {
    _items.clear();       // Limpia la lista de ítems
    notifyListeners();    // Notifica cambios
  }
}