import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../models/cart_item.dart';
import 'home_page.dart';
import 'cart_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<CartItem> _cartItems = [];


  final List<Drink> _drinkList = const [
    Drink(
      id: 'D01',
      name: 'Espresso',
      price: 18000,
      imageUrl: 'assets/cafe.png',
    ),
    Drink(
      id: 'D02',
      name: 'Americano',
      price: 20000,
      imageUrl: 'assets/cafe.png',
    ),
    Drink(
      id: 'D03',
      name: 'Matcha Latte',
      price: 25000,
      imageUrl: 'assets/cafe.png',
    ),
    Drink(
      id: 'D04',
      name: 'Chocolate Frappe',
      price: 28000,
      imageUrl: 'assets/cafe.png',
    ),
  ];


  void _addToCart(Drink drink, int quantity) {
    if (quantity < 1) return;

    setState(() {
      final index = _cartItems.indexWhere(
        (item) => item.drink.id == drink.id,
      );

      if (index >= 0) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });
  }

  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _cartItems.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Warung IS - Menu' : 'Keranjang Anda',
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            drinkList: _drinkList,
            onAddToCart: _addToCart,
          ),
          CartPage(
            cartItems: _cartItems,
            onRemoveFromCart: _removeFromCart,
            onCheckout: _clearCart,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1767A8),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (totalItems > 0)
                  Positioned(
                    right: -12,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
