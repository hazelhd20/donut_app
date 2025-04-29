// Importación de dependencias necesarias
import 'package:donut_app/utils/cart_provider.dart'; // Importa el proveedor del carrito que gestiona el estado
import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter
import 'package:provider/provider.dart'; // Importa el paquete Provider para la gestión de estado
import 'package:donut_app/utils/constants.dart'; // Importa constantes de la aplicación (como colores)

// Definición de la clase CartPage como un StatelessWidget
// Se usa StatelessWidget porque todo el estado se maneja a través del CartProvider
class CartPage extends StatelessWidget {
  const CartPage({super.key}); // Constructor con parámetro key opcional

  @override
  Widget build(BuildContext context) {
    // Obtiene la instancia de CartProvider del árbol de widgets
    // Esto permite acceder al estado del carrito en toda la página
    final cartProvider = Provider.of<CartProvider>(context);

    // Estructura principal de la página con Scaffold
    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo gris claro para la página
      appBar: AppBar(
        title: Text(
          'Mi Carrito', // Título de la barra de navegación
          style: TextStyle(
            color: Colors.grey[800], // Color de texto oscuro
            fontWeight: FontWeight.bold, // Texto en negrita
          ),
        ),
        backgroundColor: Colors.white, // Fondo blanco para la AppBar
        elevation: 1, // Sombra ligera bajo la AppBar
        iconTheme: IconThemeData(color: Colors.grey[800]), // Iconos oscuros en la AppBar
        centerTitle: true, // Centra el título en la AppBar
      ),
      body: Column(
        children: [
          Expanded(
            // Área expandible que contiene la lista de productos
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Margen horizontal
              child: cartProvider.items.isEmpty
                  ? Center(
                      // Mensaje cuando el carrito está vacío
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined, // Icono de carrito vacío
                            size: 64, // Tamaño grande del icono
                            color: Colors.grey[400], // Color gris para el icono
                          ),
                          const SizedBox(height: 16), // Espacio vertical
                          Text(
                            'Tu carrito está vacío', // Mensaje principal
                            style: TextStyle(
                              fontSize: 18, // Tamaño de fuente más grande
                              color: Colors.grey[600], // Color gris oscuro
                            ),
                          ),
                          const SizedBox(height: 8), // Espacio vertical pequeño
                          Text(
                            'Agrega productos para continuar', // Mensaje secundario
                            style: TextStyle(color: Colors.grey[500]), // Color gris medio
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      // Lista de productos cuando hay items en el carrito
                      itemCount: cartProvider.items.length, // Número de elementos en la lista
                      separatorBuilder: (context, index) => const SizedBox(height: 8), // Separador entre items
                      itemBuilder: (context, index) {
                        // Construye cada elemento de la lista
                        final item = cartProvider.items[index]; // Obtiene el item actual
                        return Container(
                          // Contenedor con estilo para cada producto
                          decoration: BoxDecoration(
                            color: Colors.white, // Fondo blanco
                            borderRadius: BorderRadius.circular(12), // Bordes redondeados
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05), // Sombra sutil
                                blurRadius: 6, // Difuminado de la sombra
                                offset: const Offset(0, 2), // Desplazamiento de la sombra
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12), // Relleno interno
                            child: Row(
                              // Organiza elementos horizontalmente
                              children: [
                                ClipRRect(
                                  // Contenedor para la imagen con bordes redondeados
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageName, // URL de la imagen del producto
                                    width: 70, // Ancho fijo
                                    height: 70, // Alto fijo
                                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el espacio
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      // Widget que se muestra si hay error al cargar la imagen
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200], // Fondo gris claro
                                      child: Icon(
                                        Icons.fastfood, // Icono de comida como respaldo
                                        color: Colors.grey[400], // Color gris para el icono
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16), // Espacio horizontal
                                Expanded(
                                  // Contenido expandible (nombre y precio)
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Alinea al inicio horizontalmente
                                    children: [
                                      Text(
                                        item.name, // Nombre del producto
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold, // Texto en negrita
                                          fontSize: 16, // Tamaño de fuente medio
                                        ),
                                      ),
                                      const SizedBox(height: 4), // Espacio vertical pequeño
                                      Text(
                                        '\$${item.price} c/u', // Precio por unidad
                                        style: TextStyle(
                                          color: Colors.grey[600], // Color gris oscuro
                                          fontSize: 14, // Tamaño de fuente pequeño
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // Control de cantidad (- y +)
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100], // Fondo gris muy claro
                                    borderRadius: BorderRadius.circular(20), // Bordes muy redondeados
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Minimiza el tamaño horizontal
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, size: 18, color: Colors.grey[800]), // Botón de reducir
                                        onPressed: () => cartProvider.decreaseQuantity(index), // Reduce la cantidad
                                        padding: EdgeInsets.zero, // Sin relleno interno
                                        constraints: const BoxConstraints(), // Sin restricciones de tamaño
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8), // Margen horizontal
                                        child: Text(
                                          '${item.quantity}', // Muestra la cantidad actual
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold, // Texto en negrita
                                            fontSize: 16, // Tamaño de fuente medio
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, size: 18, color: Colors.grey[800]), // Botón de aumentar
                                        onPressed: () => cartProvider.increaseQuantity(index), // Aumenta la cantidad
                                        padding: EdgeInsets.zero, // Sin relleno interno
                                        constraints: const BoxConstraints(), // Sin restricciones de tamaño
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red[300]), // Icono de eliminar
                                  onPressed: () => cartProvider.removeItem(index), // Elimina el item del carrito
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Área de resumen y compra (solo visible si hay productos)
          if (cartProvider.items.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200]!, // Borde superior gris claro
                    width: 1, // Grosor del borde
                  ),
                ),
              ),
              padding: const EdgeInsets.all(20), // Relleno interno
              child: Column(
                children: [
                  Row(
                    // Fila para el subtotal
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Separa los elementos
                    children: [
                      Text(
                        'Subtotal', // Etiqueta
                        style: TextStyle(
                          color: Colors.grey[600], // Color gris oscuro
                          fontSize: 16, // Tamaño de fuente medio
                        ),
                      ),
                      Text(
                        '\$${cartProvider.totalPrice.toStringAsFixed(2)}', // Precio total con 2 decimales
                        style: const TextStyle(
                          fontSize: 16, // Tamaño de fuente medio
                          fontWeight: FontWeight.bold, // Texto en negrita
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Espacio vertical pequeño
                  Row(
                    // Fila para el costo de envío
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Separa los elementos
                    children: [
                      Text(
                        'Envío', // Etiqueta
                        style: TextStyle(
                          color: Colors.grey[600], // Color gris oscuro
                          fontSize: 16, // Tamaño de fuente medio
                        ),
                      ),
                      const Text(
                        'Gratis', // Envío gratuito
                        style: TextStyle(
                          fontSize: 16, // Tamaño de fuente medio
                          fontWeight: FontWeight.bold, // Texto en negrita
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Espacio vertical mediano
                  Row(
                    // Fila para el total final
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Separa los elementos
                    children: [
                      Text(
                        'Total', // Etiqueta
                        style: TextStyle(
                          color: Colors.grey[800], // Color casi negro
                          fontSize: 18, // Tamaño de fuente grande
                          fontWeight: FontWeight.bold, // Texto en negrita
                        ),
                      ),
                      Text(
                        '\$${cartProvider.totalPrice.toStringAsFixed(2)}', // Precio total con 2 decimales
                        style: TextStyle(
                          color: appPrimaryColor, // Color primario de la app (del archivo constants.dart)
                          fontSize: 18, // Tamaño de fuente grande
                          fontWeight: FontWeight.bold, // Texto en negrita
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Espacio vertical grande
                  SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implementar checkout - Pendiente implementar la funcionalidad de pago
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPrimaryColor, // Color primario de la app para el botón
                        padding: const EdgeInsets.symmetric(vertical: 16), // Relleno vertical grande
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Bordes redondeados
                        ),
                      ),
                      child: const Text(
                        'Proceder al pago', // Texto del botón
                        style: TextStyle(
                          color: Colors.white, // Texto blanco
                          fontSize: 16, // Tamaño de fuente medio
                          fontWeight: FontWeight.bold, // Texto en negrita
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}