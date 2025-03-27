import 'package:donut_app/tab/burger_tab.dart';
import 'package:donut_app/tab/donut_tab.dart';
import 'package:donut_app/tab/pancake_tab.dart';
import 'package:donut_app/tab/pizza_tab.dart';
import 'package:donut_app/tab/profiletab.dart';
import 'package:donut_app/tab/smoothie_tab.dart';
import 'package:donut_app/utils/constants.dart';
import 'package:donut_app/utils/my_tab.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:donut_app/pages/login_screen.dart';

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});
}

class CartManager {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(String name, double price) {
    final existingItemIndex = _items.indexWhere((item) => item.name == name);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity++;
    } else {
      _items.add(CartItem(name: name, price: price));
    }
  }

  void removeItem(String name) {
    final existingItemIndex = _items.indexWhere((item) => item.name == name);
    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity--;
      } else {
        _items.removeAt(existingItemIndex);
      }
    }
  }

  void clearCart() {
    _items.clear();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartManager _cartManager = CartManager();

  // User information
  late User? _currentUser;
  String _userName = 'Usuario';
  String _userEmail = 'usuario@email.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      setState(() {
        _userName = _currentUser!.displayName ?? 'Usuario';
        _userEmail = _currentUser!.email ?? 'usuario@email.com';
      });
    }
  }

  Future<void> _logout() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // If signed in with Google, also sign out from Google
      await GoogleSignIn().signOut();

      // Navigate to login screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Show error if logout fails
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
    }
  }

  void _addToCart(double price, String name) {
    setState(() {
      _cartManager.addItem(name, price);
    });
  }

  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 15),
            const Text(
              'Your Cart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _cartManager.items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _cartManager.items.length,
                      itemBuilder: (ctx, index) {
                        final item = _cartManager.items[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Quantity: ${item.quantity}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            leading: IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _cartManager.removeItem(item.name);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${_cartManager.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _cartManager.clearCart();
                          Navigator.pop(context);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Clear Cart',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> myTabs = const [
    MyTab(iconPath: 'lib/assets/icons/donut.png', tabName: 'Donuts'),
    MyTab(iconPath: 'lib/assets/icons/burger.png', tabName: 'Burger'),
    MyTab(iconPath: 'lib/assets/icons/smoothie.png', tabName: 'Smoothie'),
    MyTab(iconPath: 'lib/assets/icons/pancakes.png', tabName: 'PanCakes'),
    MyTab(iconPath: 'lib/assets/icons/pizza.png', tabName: 'Pizza'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.grey[800], size: 30),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.person, color: Colors.grey[800], size: 30),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileTab()),
                  );
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(_userName),
                accountEmail: Text(_userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: appPrimaryColor),
                ),
                decoration: BoxDecoration(color: appPrimaryColor),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Perfil"),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileTab()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Inicio"),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Carrito de Compras"),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  _showCartModal(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Configuración"),
                onTap: () {
                  // TODO: Implement settings screen
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Cerrar Sesión"),
                onTap: _logout,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Text(
                    'I want to ',
                    style: TextStyle(fontSize: 24, color: Colors.grey[800]),
                  ),
                  Text(
                    'Eat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              tabs: myTabs,
              labelColor: appPrimaryColor,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DonutTab(onAddToCart: (price, name) => _addToCart(price, name)),
                  BurgerTab(onAddToCart: (price, name) => _addToCart(price, name)),
                  SmoothieTab(onAddToCart: (price, name) => _addToCart(price, name)),
                  PancakeTab(onAddToCart: (price, name) => _addToCart(price, name)),
                  PizzaTab(onAddToCart: (price, name) => _addToCart(price, name)),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_cartManager.itemCount} Items | \$${_cartManager.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Delivery Charges Included",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showCartModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                    ),
                    child: const Text(
                      "View Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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