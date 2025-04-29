import 'package:donut_app/utils/donut_tile.dart';
import 'package:flutter/material.dart'; 

class DonutTab extends StatelessWidget {
  // Lista de donuts
  final List<List<dynamic>> donutsOnSale = [
    ["Ice Cream", 36.0, Colors.blue, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//icecream_donut.png"],
    ["Strawberry", 45.0, Colors.red, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//strawberry_donut.png"],
    ["Grape Ape", 84.0, Colors.purple, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//grape_donut.png"],
    ["Choco", 95.0, Colors.brown, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//chocolate_donut.png"],
    ["Vanilla", 50.0, Colors.yellow, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//vanilla_donut.png"],
    ["Matcha", 70.0, Colors.green, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//matcha_donut.png"],
    ["Caramel", 60.0, Colors.orange, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//caramel_donut.png"],
    ["Blueberry", 80.0, Colors.indigo, "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/donuts//blueberry_donut.png"],
  ];

  DonutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: donutsOnSale.length,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (context, index) {
        return DonutTile(
          key: ValueKey(donutsOnSale[index][0]), // Mejor rendimiento
          donutFlavor: donutsOnSale[index][0],
          donutPrice: donutsOnSale[index][1].toString(), // Convertir a String si es necesario
          donutColor: donutsOnSale[index][2],
          imageName: donutsOnSale[index][3],
        );
      },
    );
  }
}
