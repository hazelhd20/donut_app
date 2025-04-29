// Importaciones necesarias para el funcionamiento de la pantalla
import 'package:donut_app/pages/login_page.dart';    // Importa la pantalla de inicio de sesión
import 'package:donut_app/pages/register_page.dart'; // Importa la pantalla de registro
import 'package:flutter/material.dart';              // Proporciona los widgets básicos de Flutter
import 'package:donut_app/utils/constants.dart';     // Constantes de la aplicación (colores, tamaños, etc.)

/// Clase principal para la pantalla de onboarding (introducción)
/// Es un StatefulWidget porque necesita mantener estado (página actual)
class OnboardingScreen extends StatefulWidget {
  // Constructor con la clave opcional requerida por el sistema de widgets
  const OnboardingScreen({super.key});

  @override
  // Crea el estado asociado a este widget
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

/// Clase de estado para la pantalla de onboarding
/// Mantiene el estado y la lógica de la UI
class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controlador para manejar el PageView y sus transiciones
  final PageController _pageController = PageController();
  // Variable para rastrear la página actual mostrada
  int _currentPage = 0;

  // Datos de contenido para cada página del onboarding
  // Estructura de datos usando una lista de mapas para almacenar imagen, título y descripción
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/onboarding//donuts.webp",
      "title": "Deliciosas Donas",
      "description": "Prueba nuestras donas recién horneadas y llenas de sabor.",
    },
    {
      "image": "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/onboarding//burger.webp",
      "title": "Hamburguesas Jugosas",
      "description": "Carnes frescas, ingredientes de calidad y mucho sabor.",
    },
    {
      "image": "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/onboarding//pizza.webp",
      "title": "Pizza Irresistible",
      "description": "Masa crujiente, queso derretido y los mejores ingredientes.",
    },
    {
      "image": "https://yrhopuqxxlhjrzmnmikk.supabase.co/storage/v1/object/public/onboarding//smoothie.webp",
      "title": "Smoothies Refrescantes",
      "description": "Bebidas saludables y deliciosas para acompañar tu comida.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Estructura principal de la pantalla
    return Scaffold(
      backgroundColor: appBackgroundColor, // Color de fondo definido en constantes
      body: SafeArea(
        // SafeArea asegura que el contenido esté dentro de los límites seguros de la pantalla
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // Espaciado horizontal
          child: Column(
            children: [
              // PageView que ocupa la mayor parte de la pantalla
              Expanded(
                child: PageView.builder(
                  controller: _pageController, // Controlador para manejar el desplazamiento
                  onPageChanged: (index) {
                    // Actualiza el estado cuando cambia la página
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length, // Número de páginas basado en los datos
                  itemBuilder: (context, index) {
                    // Construye cada página individual
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
                      children: [
                        // Imagen de la página actual
                        Image.network(
                          _onboardingData[index]["image"]!, // URL de la imagen (! indica que no puede ser nulo)
                          height: 250,
                          fit: BoxFit.contain, // Ajusta la imagen sin distorsionarla
                        ),
                        const SizedBox(height: 30), // Espacio vertical

                        // Título de la página actual
                        Text(
                          _onboardingData[index]["title"]!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15), // Espacio vertical

                        // Descripción de la página actual
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _onboardingData[index]["description"]!,
                            textAlign: TextAlign.center, // Centra el texto horizontalmente
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              height: 1.5, // Espaciado entre líneas para mejor legibilidad
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Indicador de páginas (puntos para mostrar en qué página estamos)
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centra los indicadores horizontalmente
                children: List.generate(
                  _onboardingData.length,
                  (index) => AnimatedContainer(
                    // Contenedor animado que cambia suavemente cuando cambia la página
                    duration: const Duration(milliseconds: 200), // Duración de la animación
                    margin: const EdgeInsets.symmetric(horizontal: 4), // Espacio entre indicadores
                    width: _currentPage == index ? 20 : 8, // Ancho diferente para la página actual
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4), // Bordes redondeados
                      color: _currentPage == index
                          ? appPrimaryColor // Color primario para la página actual
                          : Colors.grey.withOpacity(0.4), // Color gris transparente para las demás
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40), // Espacio vertical antes de los botones

              // Sección de botones de acción
              Column(
                children: [
                  // Botón de registro (estilo lleno)
                  SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child: FilledButton(
                      onPressed: () {
                        // Navega a la pantalla de registro cuando se presiona
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16), // Padding vertical para hacerlo más grande
                        backgroundColor: appPrimaryColor, // Color de fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Bordes redondeados
                        ),
                      ),
                      child: const Text(
                        "Regístrate",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600, // Semibold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15), // Espacio entre botones

                  // Botón de inicio de sesión (estilo de contorno)
                  SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child: OutlinedButton(
                      onPressed: () {
                        // Navega a la pantalla de inicio de sesión cuando se presiona
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16), // Padding vertical para hacerlo más grande
                        side: BorderSide(
                          color: appPrimaryColor, // Color del borde
                          width: 2, // Grosor del borde
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Bordes redondeados
                        ),
                      ),
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          fontSize: 18,
                          color: appPrimaryColor, // Color del texto igual al color primario
                          fontWeight: FontWeight.w600, // Semibold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Espacio al final de la pantalla
            ],
          ),
        ),
      ),
    );
  }
}