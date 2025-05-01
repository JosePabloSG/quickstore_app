import 'package:flutter/material.dart';
import 'product_catalog_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  titleSpacing: 0, // Para que el logo esté bien pegado al borde
  title: Padding(
    padding: const EdgeInsets.only(left: 12),
    child: Image.asset(
      'assets/images/logo.png',
      height: 90, // Ajusta el tamaño a tu gusto
      fit: BoxFit.contain,
    ),
  ),
  backgroundColor: Colors.white,
  elevation: 2,
),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.store),
          label: const Text('Ver catálogo de productos'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductCatalogScreen()),
            );
          },
        ),
      ),
    );
  }
}
