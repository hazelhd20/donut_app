import 'package:donut_app/utils/pizza_tile.dart';
import 'package:flutter/material.dart';

class PizzaTab extends StatelessWidget {
  final Function(double, String) onAddToCart; // Función callback para añadir al carrito
  
  // Lista de pizzas manteniendo las imágenes originales del primer código
  final List<List<dynamic>> pizzasOnSale = [
    ["Pepperoni", 120.0, Colors.red, "lib/assets/images/pepperoni_pizza.png"],
    ["Margherita", 100.0, Colors.green, "lib/assets/images/pepperoni_pizza.png"],
    ["BBQ Chicken", 140.0, Colors.brown, "lib/assets/images/pepperoni_pizza.png"],
    ["Veggie", 110.0, Colors.orange, "lib/assets/images/pepperoni_pizza.png"],
    ["Hawaiian", 130.0, Colors.yellow, "lib/assets/images/pepperoni_pizza.png"],
    ["Meat Lovers", 150.0, Colors.red, "lib/assets/images/pepperoni_pizza.png"],
    ["Cheese", 90.0, Colors.blue, "lib/assets/images/pepperoni_pizza.png"],
    ["Supreme", 135.0, Colors.purple, "lib/assets/images/pepperoni_pizza.png"],
  ];

  PizzaTab({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pizzasOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
        mainAxisSpacing: 12, // Espaciado vertical entre items (del segundo código)
        crossAxisSpacing: 12, // Espaciado horizontal entre items (del segundo código)
      ),
      itemBuilder: (context, index) {
        return PizzaTile(
          key: ValueKey(pizzasOnSale[index][0]), // Clave única para mejor rendimiento
          pizzaFlavor: pizzasOnSale[index][0], // Nombre de la pizza
          pizzaPrice: pizzasOnSale[index][1].toString(), // Precio convertido a String
          pizzaColor: pizzasOnSale[index][2], // Color asociado
          imageName: pizzasOnSale[index][3], // Imagen (se mantienen las originales)
          onAddPressed: () => onAddToCart( // Función para añadir al carrito
            pizzasOnSale[index][1], // Precio como double
            pizzasOnSale[index][0]  // Nombre de la pizza
          ),
        );
      },
    );
  }
}
