import 'package:donut_app/utils/smoothie_tile.dart';
import 'package:flutter/material.dart';

class SmoothieTab extends StatelessWidget {
  final Function(double, String) onAddToCart; // Callback para añadir al carrito
  
  // Lista de smoothies manteniendo las imágenes originales
  final List<List<dynamic>> smoothiesOnSale = [
    ["Strawberry", 40.0, Colors.red, "lib/assets/images/strawberry_smoothie.png"],
    ["Banana", 35.0, Colors.yellow, "lib/assets/images/strawberry_smoothie.png"],
    ["Berry Mix", 50.0, Colors.purple, "lib/assets/images/strawberry_smoothie.png"],
    ["Mango", 45.0, Colors.orange, "lib/assets/images/strawberry_smoothie.png"],
    ["Avocado", 55.0, Colors.green, "lib/assets/images/strawberry_smoothie.png"],
    ["Chocolate", 60.0, Colors.brown, "lib/assets/images/strawberry_smoothie.png"],
    ["Vanilla", 38.0, Colors.blue, "lib/assets/images/strawberry_smoothie.png"],
    ["Green Detox", 65.0, Colors.teal, "lib/assets/images/strawberry_smoothie.png"],
  ];

  SmoothieTab({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: smoothiesOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
        mainAxisSpacing: 12, // Espaciado añadido
        crossAxisSpacing: 12, // Espaciado añadido
      ),
      itemBuilder: (context, index) {
        return SmoothieTile(
          smoothieFlavor: smoothiesOnSale[index][0],
          smoothiePrice: smoothiesOnSale[index][1].toString(),
          smoothieColor: smoothiesOnSale[index][2],
          imageName: smoothiesOnSale[index][3],
          onAddPressed: () => onAddToCart(
            smoothiesOnSale[index][1], // Precio como double
            smoothiesOnSale[index][0]  // Nombre del smoothie
          ),
        );
      },
    );
  }
}
