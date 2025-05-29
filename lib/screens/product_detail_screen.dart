import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickstore_app/providers/buyNow_provider.dart';
import 'package:quickstore_app/providers/favorites_provider.dart';
import 'package:quickstore_app/screens/payment_methods_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/color_selector.dart';
import '../widgets/size_selector.dart';
import '../utils/notification_helper.dart';
import '../widgets/review_section.dart';

class ProductDetailScreen extends StatefulWidget {

  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;
  String selectedColor = 'Pink';
  String selectedSize = 'M';
  final Map<String, int> stockByVariant = {
    'Pink-M': 5,
    'Pink-L': 2,
    'Blue-M': 0,
    'Black-M': 3,
    'Green-M': 4,
  };
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final currentStock = stockByVariant['$selectedColor-$selectedSize'] ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              Share.share(
                'Check out this product: ${product.title} for \$${product.price}',
                subject: 'New product on our store!',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-image-detail-${product.id}',
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
                  product.hasPriceChanged
                      ? Row(
                        children: [
                          Text(
                            '\$${(product.price * 1.25).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.title,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            //description
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
            // Color selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ColorSelector(
                selectedColor: selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    selectedColor = color;
                    quantity = 1;
                  });
                },
              ),
            ),
            // Size selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizeSelector(
                selectedSize: selectedSize,
                sizes: const ['S', 'M', 'L', 'XL'],
                onSizeSelected: (size) {
                  setState(() {
                    selectedSize = size;
                    quantity = 1;
                  });
                },
              ),
            ),
            // Specifications
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Specifications',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Material: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(product.material),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Origin: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(product.origin),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stock
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Available stock: $currentStock',
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            // Quantity selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed:
                        quantity > 1 ? () => setState(() => quantity--) : null,
                  ),
                  Text('$quantity', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (quantity < currentStock) {
                        setState(() => quantity++);
                      } else {
                        showTopNotification(
                          context,
                          'There are no more units available',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            // Sección de Reseñas Detalladas
            ReviewSection(productId: product.id),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Favorite toggle
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final favoritesProvider =
                            context.read<FavoritesProvider>();
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                        if (isFavorite) {
                          favoritesProvider.addFavorite(widget.product);
                        } else {
                          favoritesProvider.removeFavorite(widget.product.id);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Add to cart
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          currentStock > 0
                              ? () {
                                Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                ).addToCart(widget.product, quantity: quantity);
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    20,
                                                    60,
                                                    20,
                                                    24,
                                                  ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    'Product added to cart',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 24),
                                                  ElevatedButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.black,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 14,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Continue Shopping',
                                                    ),
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
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Add to cart'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Buy now
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          currentStock == 0
                              ? null
                              : () {
                                final buyNow = Provider.of<BuyNowProvider>(
                                  context,
                                  listen: false,
                                );
                                buyNow.setPurchase(widget.product, quantity);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const PaymentScreen(
                                          fromBuyNow: true,
                                        ),
                                  ),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004CFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Buy now'),
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
