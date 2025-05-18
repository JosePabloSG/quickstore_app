import 'package:flutter/material.dart';
import 'package:quickstore_app/screens/cart_screen.dart';
import 'package:quickstore_app/screens/favorites_screen.dart';
import 'package:quickstore_app/screens/product_catalog_screen.dart';
import 'package:quickstore_app/screens/profile_screen.dart';
import 'package:quickstore_app/widgets/botton_navBar.dart';
import 'home_screen.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}
class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    ProductCatalogScreen(),
    CartScreen(),
    ProfileScreen(),
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

