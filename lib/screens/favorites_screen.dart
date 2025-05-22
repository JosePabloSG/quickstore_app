// screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

class FavoritesScreen extends StatefulWidget {

 final VoidCallback? onBack;

  const FavoritesScreen({super.key, this.onBack});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}



class _FavoritesScreenState extends State<FavoritesScreen> {
  String sortOption = 'default';


  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();
    List<Product> products = [...favoritesProvider.favorites];

    if (sortOption == 'price') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == 'title') {
      products.sort((a, b) => a.title.compareTo(b.title));
    }

    return Scaffold(
      appBar: AppBar(
     leading: IconButton(
  icon: const Icon(Icons.arrow_back, color: Colors.black),
  onPressed: widget.onBack ?? () => Navigator.pop(context),
),
        title: const Text('Favorites',
          style: TextStyle(
         fontSize: 24,           
        fontWeight: FontWeight.w700, 
         color: Colors.black,    
         ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => favoritesProvider.clearFavorites(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => sortOption = value),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'default', child: Text('Default')),
              PopupMenuItem(value: 'price', child: Text('By price')),
              PopupMenuItem(value: 'title', child: Text('By name')),
            ],
          ),
        ],
      ),
     body: products.isEmpty
    ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/fav.png',
              width: 180,
              height: 180,
            ),
          ],
        ),
      )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];
                final isOutOfStock = product.stock == 0;
                final hasPriceChanged = product.hasPriceChanged;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => favoritesProvider.removeFavorite(product.id),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (hasPriceChanged)
                                  Text(
                                    '\$${(product.price + 5).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                const SizedBox(width: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                              
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (isOutOfStock)
                              const Text(
                                'Out of stock',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                     IconButton(
  icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 28),
  onPressed: isOutOfStock
      ? null
      : () {
          cartProvider.addToCart(product);

          showDialog(
            context: context,
            builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Product added to cart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Continue Shopping'),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: -40,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 35,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
)

                    ],
                  ),
                );
              },
            ),
    );
  }
}
