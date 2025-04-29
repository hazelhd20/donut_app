// Importación de dependencias necesarias
import 'package:donut_app/pages/cart_page.dart'; // Importa la página del carrito de compras
import 'package:donut_app/pages/change_password_page.dart'; // Importa la página de cambio de contraseña
import 'package:donut_app/pages/login_page.dart'; // Importa la página de inicio de sesión
import 'package:donut_app/pages/profile_page.dart'; // Importa la página de perfil de usuario
import 'package:donut_app/tab/burger_tab.dart'; // Importa la pestaña de hamburguesas
import 'package:donut_app/tab/donut_tab.dart'; // Importa la pestaña de donas
import 'package:donut_app/tab/pancake_tab.dart'; // Importa la pestaña de pancakes
import 'package:donut_app/tab/pizza_tab.dart'; // Importa la pestaña de pizzas
import 'package:donut_app/tab/smoothie_tab.dart'; // Importa la pestaña de smoothies
import 'package:donut_app/utils/cart_provider.dart'; // Importa el proveedor de estado para el carrito
import 'package:donut_app/utils/constants.dart'; // Importa constantes de la aplicación
import 'package:donut_app/utils/my_tab.dart'; // Importa el widget personalizado para las pestañas
import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para la autenticación
import 'package:google_sign_in/google_sign_in.dart'; // Importa Google Sign In para la autenticación con Google
import 'package:provider/provider.dart'; // Importa Provider para la gestión de estado

// Definición de la clase HomePage como un StatefulWidget
// Se usa StatefulWidget porque esta página necesita mantener estado (usuario actual, pestañas, etc.)
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor con parámetro key opcional

  @override
  State<HomePage> createState() => _HomePageState(); // Crea el estado asociado a este widget
}

// Clase que mantiene el estado de HomePage
class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Clave global para controlar el Scaffold (usado para el drawer)

  // Variables para la información del usuario
  late User? _currentUser; // Usuario actual de Firebase Auth
  String _userName = 'Usuario'; // Nombre de usuario predeterminado
  String _userEmail = 'usuario@email.com'; // Email de usuario predeterminado

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Carga los datos del usuario al inicializar el widget
  }

  // Método para cargar los datos del usuario actual
  void _loadUserData() {
    _currentUser = FirebaseAuth.instance.currentUser; // Obtiene el usuario actual de Firebase
    if (_currentUser != null) { // Verifica si hay un usuario autenticado
      setState(() {
        // Actualiza el estado con el nombre y email del usuario
        _userName = _currentUser!.displayName ?? 'Usuario'; // Usa el nombre del usuario o el valor predeterminado
        _userEmail = _currentUser!.email ?? 'usuario@email.com'; // Usa el email del usuario o el valor predeterminado
      });
    }
  }

  // Método para cerrar sesión del usuario
  Future<void> _logout() async {
    try {
      // Cierra sesión en Firebase
      await FirebaseAuth.instance.signOut();

      // Si se inició sesión con Google, también cierra sesión en Google
      await GoogleSignIn().signOut();

      // Navega a la pantalla de inicio de sesión y elimina todas las rutas anteriores
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()), // Navega a la pantalla de login
        (route) => false, // Elimina todas las rutas anteriores
      );
    } catch (e) {
      // Muestra un error si falla el cierre de sesión
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
    }
  }

  // Lista de pestañas personalizadas para la aplicación
  List<Widget> myTabs = const [
    MyTab(iconPath: 'lib/assets/icons/donut.png', tabName: 'Donuts'), // Pestaña de donas
    MyTab(iconPath: 'lib/assets/icons/burger.png', tabName: 'Burger'), // Pestaña de hamburguesas
    MyTab(iconPath: 'lib/assets/icons/smoothie.png', tabName: 'Smoothie'), // Pestaña de smoothies
    MyTab(iconPath: 'lib/assets/icons/pancakes.png', tabName: 'PanCakes'), // Pestaña de pancakes
    MyTab(iconPath: 'lib/assets/icons/pizza.png', tabName: 'Pizza'), // Pestaña de pizzas
  ];

  @override
  Widget build(BuildContext context) {
    // Estructura principal de la página con TabController para las pestañas
    return DefaultTabController(
      length: myTabs.length, // Número de pestañas
      child: Scaffold(
        key: _scaffoldKey, // Asigna la clave del Scaffold para poder abrirlo programáticamente
        backgroundColor: appBackgroundColor, // Color de fondo definido en constants.dart
        appBar: AppBar(
          backgroundColor: Colors.transparent, // AppBar transparente
          elevation: 0, // Sin sombra
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0), // Padding izquierdo
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.grey[800], size: 30), // Icono de menú
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer(); // Abre el drawer al presionar
              },
            ),
          ),
          // Botones en la parte derecha de la AppBar
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0), // Padding derecho
              child: IconButton(
                icon: Icon(Icons.person, color: Colors.grey[800], size: 30), // Icono de perfil
                onPressed: () {
                  // Navega a la pantalla de perfil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        // Menú lateral (drawer)
        drawer: Drawer(
          backgroundColor: appBackgroundColor, // Color de fondo del drawer
          child: Column(
            children: [
              // Encabezado del drawer con información del usuario
              UserAccountsDrawerHeader(
                accountName: Text(_userName), // Nombre del usuario
                accountEmail: Text(_userEmail), // Email del usuario
                currentAccountPicture:
                    _currentUser?.photoURL != null
                        ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            _currentUser!.photoURL!, // Foto de perfil del usuario si existe
                          ),
                        )
                        : CircleAvatar(
                          backgroundColor: Colors.white, // Fondo blanco si no hay foto
                          child: Icon(
                            Icons.person, // Icono de persona como respaldo
                            size: 50,
                            color: appPrimaryColor, // Color primario de la app
                          ),
                        ),
                decoration: BoxDecoration(color: appPrimaryColor), // Color de fondo del encabezado
              ),
              // Elementos del menú lateral
              ListTile(
                leading: Icon(Icons.person), // Icono de perfil
                title: Text("Perfil"), // Texto del elemento
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  // Navega a la pantalla de perfil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.home), // Icono de inicio
                title: Text("Inicio"), // Texto del elemento
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  // No navega a ningún sitio porque ya estamos en la página de inicio
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart), // Icono de carrito
                title: const Text("Carrito de Compras"), // Texto del elemento
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  // Navega a la página del carrito
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings), // Icono de configuración
                title: const Text("Configuración"), // Texto del elemento
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  // Navega a la página de cambio de contraseña
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout), // Icono de cerrar sesión
                title: Text("Cerrar Sesión"), // Texto del elemento
                onTap: _logout, // Llama al método de cierre de sesión
              ),
            ],
          ),
        ),
        // Cuerpo principal de la página
        body: Column(
          children: [
            // Encabezado "I want to Eat"
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Text(
                    'I want to ', // Primera parte del texto
                    style: TextStyle(fontSize: 24, color: Colors.grey[800]),
                  ),
                  Text(
                    'Eat', // Segunda parte del texto (enfatizada)
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // Texto en negrita
                      decoration: TextDecoration.underline, // Texto subrayado
                    ),
                  ),
                ],
              ),
            ),
            // Barra de pestañas con iconos personalizados
            TabBar(
              tabs: myTabs, // Lista de pestañas definida anteriormente
              labelColor: appPrimaryColor, // Color de la pestaña seleccionada
              unselectedLabelColor: Colors.grey, // Color de las pestañas no seleccionadas
            ),
            // Contenido de las pestañas (ocupa el espacio restante)
            Expanded(
              child: TabBarView(
                children: [
                  DonutTab(), // Contenido de la pestaña de donas
                  BurgerTab(), // Contenido de la pestaña de hamburguesas
                  SmoothieTab(), // Contenido de la pestaña de smoothies
                  PancakeTab(), // Contenido de la pestaña de pancakes
                  PizzaTab(), // Contenido de la pestaña de pizzas
                ],
              ),
            ),
            // Barra inferior con resumen del carrito (usando Consumer para actualización automática)
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Container(
                  color: Colors.white, // Fondo blanco
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, // Consistente con el padding del encabezado
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      // Información del carrito (cantidad de items y precio total)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
                          children: [
                            Text(
                              "${cart.itemCount} ${cart.itemCount == 1 ? 'Item' : 'Items'} | \$${cart.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold, // Texto en negrita
                              ),
                            ),
                            const SizedBox(height: 4), // Espacio vertical pequeño
                            const Text(
                              "Delivery Charges Included", // Indica que el precio incluye envío
                              style: TextStyle(fontSize: 12), // Texto pequeño
                            ),
                          ],
                        ),
                      ),
                      // Botón para ver el carrito completo
                      ElevatedButton(
                        onPressed: () {
                          // Navega a la página del carrito
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor, // Color de fondo del botón
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Bordes redondeados
                          ),
                        ),
                        child: const Text(
                          "View Cart", // Texto del botón
                          style: TextStyle(
                            color: Colors.white, // Texto blanco
                            fontWeight: FontWeight.bold, // Texto en negrita
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}