import 'package:flutter/material.dart';

class SmoothieTile extends StatelessWidget {
  final String smoothieFlavor;
  final String smoothiePrice;
  final MaterialColor smoothieColor;
  final String imageName;
  final double borderRadius = 14;
  final VoidCallback? onFavoritePressed; // Nuevo: callback para favoritos
  final VoidCallback? onAddPressed;      // Nuevo: callback para añadir

  const SmoothieTile({
    super.key,
    required this.smoothieFlavor,
    required this.smoothiePrice,
    required this.smoothieColor,
    required this.imageName,
    this.onFavoritePressed,              // Nuevo: parámetro opcional
    this.onAddPressed,                   // Nuevo: parámetro opcional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: smoothieColor[50] ?? Colors.grey[50],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            // Sección de precio (sin cambios)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: smoothieColor[100] ?? Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '\$$smoothiePrice',
                    style: TextStyle(
                      color: smoothieColor[800] ?? Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            // Imagen del smoothie (sin cambios)
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

            // Nombre y marca (sin cambios)
            Text(
              smoothieFlavor,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Smoothie Bar',
              style: TextStyle(color: Colors.grey[600]),
            ),

            // Botones de acción (modificado solo los onPressed)
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
