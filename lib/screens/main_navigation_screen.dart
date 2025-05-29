import 'package:flutter/material.dart';
import 'package:quickstore_app/screens/cart_screen.dart';
import 'package:quickstore_app/screens/favorites_screen.dart';
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

  final List<Widget> _screens = [
    const HomeScreen(),
    FavoritesScreen(onBack: () {}), // No necesitamos onBack aquí
    CartScreen(onBack: () {}), // No necesitamos onBack aquí
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: changeTab,
        ),
      ),
    );
  }
}
