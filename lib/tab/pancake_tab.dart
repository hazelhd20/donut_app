import 'package:donut_app/utils/pancake_tile.dart';
import 'package:flutter/material.dart';

class PancakeTab extends StatelessWidget {
  final Function(double, String) onAddToCart;
  
  // Lista de pancakes manteniendo las imágenes originales
  final List<List<dynamic>> pancakesOnSale = [
    ["Classic", 50.0, Colors.brown, "lib/assets/images/classic_pancake.png"],
    ["Blueberry", 60.0, Colors.blue, "lib/assets/images/classic_pancake.png"],
    ["Chocolate", 70.0, Colors.brown, "lib/assets/images/classic_pancake.png"],
    ["Strawberry", 65.0, Colors.red, "lib/assets/images/classic_pancake.png"],
    ["Banana", 55.0, Colors.yellow, "lib/assets/images/classic_pancake.png"],
    ["Nutella", 80.0, Colors.grey, "lib/assets/images/classic_pancake.png"],
    ["Caramel", 75.0, Colors.orange, "lib/assets/images/classic_pancake.png"],
    ["Mixed Fruit", 85.0, Colors.purple, "lib/assets/images/classic_pancake.png"],
  ];

  PancakeTab({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pancakesOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
        mainAxisSpacing: 12, // Añadido del segundo código
        crossAxisSpacing: 12, // Añadido del segundo código
      ),
      itemBuilder: (context, index) {
        return PancakeTile(
          key: ValueKey(pancakesOnSale[index][0]),
          pancakeFlavor: pancakesOnSale[index][0],
          pancakePrice: pancakesOnSale[index][1].toString(),
          pancakeColor: pancakesOnSale[index][2],
          imageName: pancakesOnSale[index][3],
          onAddPressed: () => onAddToCart(
            pancakesOnSale[index][1], // Precio como double
            pancakesOnSale[index][0]  // Nombre del producto
          ),
        );
      },
    );
  }
}
