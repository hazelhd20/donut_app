import 'package:donut_app/utils/burger_tile.dart';
import 'package:flutter/material.dart';

class BurgerTab extends StatelessWidget {
  // Lista de hamburguesas
  final List<List<dynamic>> burgersOnSale = [
    ["Cheese Burger", 50.0, Colors.yellow, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
    ["Bacon Burger", 65.0, Colors.red, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
    ["Veggie Burger", 55.0, Colors.green, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
    ["BBQ Burger", 70.0, Colors.brown, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
    ["Spicy Burger", 60.0, Colors.orange, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
    ["Mushroom Burger", 75.0, Colors.purple, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
    ["Double Patty", 85.0, Colors.blue, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
    ["Classic Burger", 45.0, Colors.indigo, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/burgers//cheese_burger.png"],
  ];

  BurgerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: burgersOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        return BurgerTile(
          key: ValueKey(burgersOnSale[index][0]), // Mejor rendimiento
          burgerFlavor: burgersOnSale[index][0],
          burgerPrice: burgersOnSale[index][1].toString(), // Convertir a String si es necesario
          burgerColor: burgersOnSale[index][2],
          imageName: burgersOnSale[index][3],
        );
      },
    );
  }
}
