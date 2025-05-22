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

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

    late List<Widget> _screens;

@override
void initState() {
  super.initState();
  _screens = [
    const HomeScreen(),
    FavoritesScreen(onBack: () => setState(() => _currentIndex = 0)),
    const ProductCatalogScreen(),
    CartScreen(onBack: () => setState(() => _currentIndex = 0)), 
    const ProfileScreen(),
  ];
} 
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

