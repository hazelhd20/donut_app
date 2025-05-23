import 'package:donut_app/utils/pancake_tile.dart';
import 'package:flutter/material.dart';

class PancakeTab extends StatelessWidget {
  final List<List<dynamic>> pancakesOnSale = [
    ["Classic", 50.0, Colors.brown, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
    ["Blueberry", 60.0, Colors.blue, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
    ["Chocolate", 70.0, Colors.brown, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
    ["Strawberry", 65.0, Colors.red, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
    ["Banana", 55.0, Colors.yellow, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
    ["Nutella", 80.0, Colors.grey, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
    ["Caramel", 75.0, Colors.orange, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
    ["Mixed Fruit", 85.0, Colors.purple, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/pancakes//classic_pancake.png"],
  ];

  PancakeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pancakesOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        return PancakeTile(
          key: ValueKey(pancakesOnSale[index][0]), // Mejor rendimiento
          pancakeFlavor: pancakesOnSale[index][0],
          pancakePrice: pancakesOnSale[index][1].toString(),
          pancakeColor: pancakesOnSale[index][2],
          imageName: pancakesOnSale[index][3],
        );
      },
    );
  }
}