import 'package:donut_app/utils/burger_tile.dart';
import 'package:flutter/material.dart';

class BurgerTab extends StatelessWidget {
  final Function(double, String) onAddToCart;
  
  // Lista de hamburguesas (manteniendo las imágenes originales del primer código)
  final List<List<dynamic>> burgersOnSale = [
    ["Cheese Burger", 50.0, Colors.yellow, "lib/assets/images/cheese_burger.png"],
    ["Bacon Burger", 65.0, Colors.red, "lib/assets/images/cheese_burger.png"],
    ["Veggie Burger", 55.0, Colors.green, "lib/assets/images/cheese_burger.png"],
    ["BBQ Burger", 70.0, Colors.brown, "lib/assets/images/cheese_burger.png"],
    ["Spicy Burger", 60.0, Colors.orange, "lib/assets/images/cheese_burger.png"],
    ["Mushroom Burger", 75.0, Colors.purple, "lib/assets/images/cheese_burger.png"],
    ["Double Patty", 85.0, Colors.blue, "lib/assets/images/cheese_burger.png"],
    ["Classic Burger", 45.0, Colors.indigo, "lib/assets/images/cheese_burger.png"],
  ];

  BurgerTab({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: burgersOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
        mainAxisSpacing: 12, // Añadido del segundo código
        crossAxisSpacing: 12, // Añadido del segundo código
      ),
      itemBuilder: (context, index) {
        return BurgerTile(
          key: ValueKey(burgersOnSale[index][0]),
          burgerFlavor: burgersOnSale[index][0],
          burgerPrice: burgersOnSale[index][1].toString(),
          burgerColor: burgersOnSale[index][2],
          imageName: burgersOnSale[index][3],
          onAddPressed: () => onAddToCart(
            burgersOnSale[index][1], // Precio como double
            burgersOnSale[index][0]  // Nombre del producto
          ),
        );
      },
    );
  }
}
