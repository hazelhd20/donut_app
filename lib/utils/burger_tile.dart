import 'package:flutter/material.dart';

class BurgerTile extends StatelessWidget {
  final String burgerFlavor;
  final String burgerPrice;
  final MaterialColor burgerColor;
  final String imageName;
  final double borderRadius = 14;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onAddPressed;

  const BurgerTile({
    super.key,
    required this.burgerFlavor,
    required this.burgerPrice,
    required this.burgerColor,
    required this.imageName,
    this.onFavoritePressed,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: burgerColor[50] ?? Colors.grey[50],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            // Precio
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: burgerColor[100] ?? Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '\$$burgerPrice',
                    style: TextStyle(
                      color: burgerColor[800] ?? Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            // Imagen de la hamburguesa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 4),
              child: Image.asset(
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

            // Nombre del sabor
            Text(
              burgerFlavor,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Burger House',
              style: TextStyle(color: Colors.grey[600]),
            ),

            // Botones de favorito y añadir
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de favorito
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.pink[400] ?? Colors.pink,
                    ),
                    onPressed: onFavoritePressed ?? () {
                      debugPrint('Favorito presionado');
                    },
                  ),

                  // Botón de añadir
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey[800] ?? Colors.grey,
                    ),
                    onPressed: onAddPressed ?? () {
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
