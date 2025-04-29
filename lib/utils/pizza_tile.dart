import 'package:donut_app/utils/cart_provider.dart';
import 'package:donut_app/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PizzaTile extends StatelessWidget {
  final String pizzaFlavor;
  final String pizzaPrice;
  final MaterialColor pizzaColor;
  final String imageName;
  final double borderRadius = 14;

  const PizzaTile({
    super.key,
    required this.pizzaFlavor,
    required this.pizzaPrice,
    required this.pizzaColor,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: pizzaColor[50] ?? Colors.grey[50], // Asegura un color seguro
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            // price
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: pizzaColor[100] ?? Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '\$$pizzaPrice',
                    style: TextStyle(
                      color: pizzaColor[800] ?? Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            // pizza picture
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 42.0,
                vertical: 4,
              ),
              child: Image.network(
                imageName,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.red,
                  );
                },
              ),
            ),

            // pizza flavor
            Text(
              pizzaFlavor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text('Pizza House', style: TextStyle(color: Colors.grey[600])),

            // love icon + add button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // love icon
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.pink[400] ?? Colors.pink,
                    ),
                    onPressed: () {
                      debugPrint('Favorito presionado');
                    },
                  ),

                  // plus button
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey[800] ?? Colors.grey,
                    ),
                    onPressed: () {
                      cartProvider.addItem(pizzaFlavor, pizzaPrice, 'Pizza', imageName,);
                      showCustomSnackBar(context, 'Pizza $pizzaFlavor añadido al carrito',);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
