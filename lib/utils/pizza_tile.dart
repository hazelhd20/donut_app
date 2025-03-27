import 'package:flutter/material.dart';

class PizzaTile extends StatelessWidget {
  final String pizzaFlavor;
  final String pizzaPrice;
  final MaterialColor pizzaColor;
  final String imageName;
  final double borderRadius = 14;
  final VoidCallback? onAddPressed; // Nuevo: callback para añadir

  const PizzaTile({
    super.key,
    required this.pizzaFlavor,
    required this.pizzaPrice,
    required this.pizzaColor,
    required this.imageName,
    this.onAddPressed, // Nuevo: parámetro opcional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: pizzaColor[50] ?? Colors.grey[50],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            // price (sin cambios)
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

            // pizza picture (sin cambios)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 4),
              child: Image.asset(imageName, errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 50, color: Colors.red);
              }),
            ),

            // pizza flavor (sin cambios)
            Text(
              pizzaFlavor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Pizza House',
              style: TextStyle(color: Colors.grey[600]),
            ),

            // love icon + add button (modificado solo el onPressed del add)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // love icon (sin cambios)
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.pink[400] ?? Colors.pink),
                    onPressed: () {
                      debugPrint('Favorito presionado');
                    },
                  ),

                  // plus button (actualizado)
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.grey[800] ?? Colors.grey),
                    onPressed: onAddPressed ?? () { // Usa el callback o el comportamiento por defecto
                      debugPrint('Añadir presionado');
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
