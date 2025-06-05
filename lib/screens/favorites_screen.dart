import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickstore_app/providers/product_provider.dart';
import 'package:quickstore_app/widgets/add_to_cart_dialog.dart';
import 'package:quickstore_app/widgets/popular_product.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FavoritesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const FavoritesScreen({super.key, this.onBack});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String sortOption = 'default';
  bool showGrid = false;
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();
    List<Product> products = [...favoritesProvider.favorites];
    final productProvider = context.watch<ProductProvider>();
    final popularProducts = productProvider.products.take(5).toList();
    if (sortOption == 'price') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == 'title') {
      products.sort((a, b) => a.title.compareTo(b.title));
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(showGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                showGrid = !showGrid;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => favoritesProvider.clearFavorites(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => sortOption = value),
            itemBuilder:
                (_) => const [
                  PopupMenuItem(value: 'default', child: Text('Default')),
                  PopupMenuItem(value: 'price', child: Text('By price')),
                  PopupMenuItem(value: 'title', child: Text('By name')),
                ],
          ),
        ],
      ),
      body:
          products.isEmpty
              ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 120),
                          Image.asset(
                            'assets/Images/fav.png',
                            width: 180,
                            height: 180,
                          ),
                          const SizedBox(height: 125),
                        ],
                      ),
                    ),
                    const Text(
                      'Most Popular',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularProducts.length,
                        itemBuilder: (context, index) {
                          final product = popularProducts[index];
                          return PopularProductCard(product: product);
                        },
                      ),
                    ),
                  ],
                ),
              )
              : showGrid
              ? GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isOutOfStock = product.stock == 0;
                  final hasPriceChanged = product.hasPriceChanged;
                  return Container(
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
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product.imageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  LucideIcons.trash2,
                                  color: Colors.redAccent,
                                ),
                                onPressed:
                                    () => favoritesProvider.removeFavorite(
                                      product.id,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (hasPriceChanged)
                              Text(
                                '\$${(product.price + 5).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 13,
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
                        if (isOutOfStock)
                          const Text(
                            'Out of stock',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed:
                              isOutOfStock
                                  ? null
                                  : () {
                                    cartProvider.addToCart(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Product added to cart'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text("Add to cart"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004CFF),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 36),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    icon: const Icon(
                                      LucideIcons.trash2,
                                      color: Colors.redAccent,
                                      size: 22,
                                    ),
                                    onPressed:
                                        () => favoritesProvider.removeFavorite(
                                          product.id,
                                        ),
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
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Color(0xFF004CFF),
                            size: 22,
                          ),
                          onPressed:
                              isOutOfStock
                                  ? null
                                  : () {
                                    cartProvider.addToCart(product);
                                    showDialog(
                                      context: context,
                                      builder: (_) => const AddToCartDialog(),
                                    );
                                  },
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
