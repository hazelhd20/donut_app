import 'package:donut_app/utils/donut_tile.dart';
import 'package:flutter/material.dart';

class DonutTab extends StatelessWidget {
  final Function(double, String) onAddToCart;
  
  // Lista de donuts manteniendo las imágenes originales del primer código
  final List<List<dynamic>> donutsOnSale = [
    ["Ice Cream", 36.0, Colors.blue, "lib/assets/images/icecream_donut.png"],
    ["Strawberry", 45.0, Colors.red, "lib/assets/images/strawberry_donut.png"],
    ["Grape Ape", 84.0, Colors.purple, "lib/assets/images/grape_donut.png"],
    ["Choco", 95.0, Colors.brown, "lib/assets/images/chocolate_donut.png"],
    ["Vanilla", 50.0, Colors.yellow, "lib/assets/images/vanilla_donut.png"],
    ["Matcha", 70.0, Colors.green, "lib/assets/images/matcha_donut.png"],
    ["Caramel", 60.0, Colors.orange, "lib/assets/images/caramel_donut.png"],
    ["Blueberry", 80.0, Colors.indigo, "lib/assets/images/blueberry_donut.png"],
  ];

  DonutTab({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: donutsOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
        mainAxisSpacing: 12, // Añadido del segundo código
        crossAxisSpacing: 12, // Añadido del segundo código
      ),
      itemBuilder: (context, index) {
        return DonutTile(
          key: ValueKey(donutsOnSale[index][0]),
          donutFlavor: donutsOnSale[index][0],
          donutPrice: donutsOnSale[index][1].toString(),
          donutColor: donutsOnSale[index][2],
          imageName: donutsOnSale[index][3],
          onAddPressed: () => onAddToCart(
            donutsOnSale[index][1], // Precio como double
            donutsOnSale[index][0]  // Nombre del producto
          ),
        );
      },
    );
  }
}
