import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PopularProductCard extends StatelessWidget {
  final Product product;

  const PopularProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = product.hasPriceChanged;
    final double originalPrice = product.price;
    final double discountedPrice =
        hasDiscount ? originalPrice * 0.75 : originalPrice;
    final int discountPercent =
        hasDiscount
            ? ((1 - (discountedPrice / originalPrice)) * 100).round()
            : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'product-image-${product.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Botón nuevo
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      final cartProvider = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );
                      cartProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.title} añadido al carrito',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFF004CFF),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 2),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  hasDiscount
                      ? Row(
                        children: [
                          Text(
                            '\$${originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${discountedPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        '\$${originalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
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
