import 'package:flutter/material.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/aulavirtual_page.dart';
import 'package:ulima_app/presentation/pages/cart/cart_page.dart';
import 'package:ulima_app/presentation/pages/chatbot/chatbot_page.dart';
import 'package:ulima_app/presentation/pages/horario/horario_page.dart';
import 'package:ulima_app/presentation/pages/menu/menu_page.dart';
import 'package:ulima_app/presentation/pages/miulima/miulima_page.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> cart = [];

  final List<Map<String, String>> _messages = [];

  int _selectedIndex = 0;

  void addToCart(
      String id, int quantity, String nombre, double precio, String imagenUrl) {
    final index = cart.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      setState(() {
        cart[index]['quantity'] = quantity;
      });
    } else {
      setState(() {
        cart.add({
          'id': id,
          'quantity': quantity,
          'nombre': nombre,
          'precio': precio,
          'imagenUrl': imagenUrl
        });
      });
    }
    print(cart);
  }

  List<Widget> get _pages => [
        const HorarioPage(),
        const AulavirtualPage(),
        MenuPage(addToCart: addToCart, cart: cart),
        MiulimaPage()
      ];

  final List<IconButton?> _appBarIcon = [
    null,
    IconButton(
      icon: const Icon(Icons.visibility),
      onPressed: () {
        print("Aula virtual");
      },
    ),
    null, // El ícono del carrito se construye dinámicamente en el AppBar
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        print("Log out");
      },
    ),
  ];

  Widget buildCartIcon() {
    final cartCount =
        cart.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)));
          },
        ),
        if (cartCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                '$cartCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatbotPage(
                            getMenuItemsUseCase: injector<GetMenuItems>(),
                            messages: _messages)));
              },
              backgroundColor: UlimaColors.orange,
              child: Icon(Icons.chat_bubble,
                  color: Theme.of(context).colorScheme.background),
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Center(
          child: SafeArea(
            child: Image.asset(
              'assets/images/ulima_white_icon.png',
              height: 35,
              width: 35,
            ),
          ),
        ),
        backgroundColor: UlimaColors.orange,
        actions: _selectedIndex == 2
            ? [buildCartIcon()]
            : _appBarIcon[_selectedIndex] != null
                ? [_appBarIcon[_selectedIndex]!]
                : null,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Horario"),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: "Aula virtual"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "Menú"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Mi ulima"),
        ],
      ),
    );
  }
}
